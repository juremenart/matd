`timescale 1 ps / 1 ps

// TODO: Check where JJJ is in the comment - problem with using logic from interface axi4_lite_if during elaboration (only for simulation)

module phase_ctrl_axi #(
                        int unsigned DW = 32, // Width of AXI data    bus
                        int unsigned AW = 16, // Width of AXI address bus
                        int unsigned PWM_CNT = 64, // number of PWMs                     
                        int          PWM_CNT_WIDTH = 24) // width of PWM counters
  (
   // AXI-Lite slave
   axi4_lite_if.s axi_bus,

   output logic phase_ctrl_en_o,

   output logic [PWM_CNT-1:0]                     phase_ch_en_o,
   output logic [PWM_CNT-1:0]                     phase_edge_o,
   output logic [PWM_CNT-1:0]               [3:0] phase_mode_o,
   output logic [PWM_CNT-1:0]               [7:0] phase_cnt_o,
   output logic [PWM_CNT-1:0]               [7:0] phase_skip_cnt_o,
   output shortint                                phase_step_o[PWM_CNT-1:0],

   input logic [PWM_CNT-1:0]                      phase_ch_en_i,
   input logic [PWM_CNT-1:0] [PWM_CNT_WIDTH-1:0]  phase_start_rb_i,
   input logic [PWM_CNT-1:0] [PWM_CNT_WIDTH-1:0]  phase_cur_rb_i
   );

   // Register map
   // PHASE_CTRL engine control:
   // - bit0 - enable engine
   localparam PHASE_CTRL      = 3'h0; // PHASE_CTRL engine control

   // 0x04 - 0x1C registers reserved
   // CH_PHASE_CTRL:
   // - bit0 - automatic (1) or manual (0) control - self clearing if/when automatic action is done
   // - bit1 - change on positive (0) or negative (1) pulse
   // - bits[7:4] - control mode:
   //     - 4'h0 - static (no change stay at PHASE_START)
   //     - 4'h1 - full phase counts of phase_cnt_o with PHASE_STEP
   //     - others reserved (static mode)
   localparam CH_PHASE_CTRL          = 3'h4; // 0x10 + (0x10 * i) - channel phase control register
   localparam CH_PHASE_CNT_STEP      = 3'h5; // 0x14 + (0x10 * i) - channel phase count and step value
   localparam CH_PHASE_START_CUR_RB  = 3'h6; // 0x18 + (0x10 * i) - channel starting and currnet phase readback
   
   localparam CH_SEL_SIZE    = 11; // channel selector size
   localparam CH_SEL_MSB     = 12; // channel selector MSB (from address bits)
   localparam CH_SEL_LSB     =  2; // channel selector LSB (from address bits)

   //----------------------------------------------
   //-- Signals for user logic register space example
   //------------------------------------------------
   localparam int unsigned ADDR_LSB = $clog2(DW/8);

   logic                   slv_reg_rden;
   logic                   slv_reg_wren;
   // AXI4LITE signals
   logic [AW-1-ADDR_LSB:0]    axi_awaddr;
   logic [AW-1-ADDR_LSB:0]    axi_araddr;

   logic [CH_SEL_SIZE-1:0]    ch_sel_r, ch_sel_w; // channel register accessed
   logic                      ch_sel_en_r, ch_sel_en_w;
   
   logic phase_ctrl_engine_en;
   logic [PWM_CNT-1:0]                     phase_ch_en;
   logic [PWM_CNT-1:0]                     phase_edge;
   logic [PWM_CNT-1:0]               [3:0] phase_mode;
   logic [PWM_CNT-1:0]               [7:0] phase_cnt;
   logic [PWM_CNT-1:0]               [7:0] phase_skip_cnt;
   shortint                                phase_step[PWM_CNT-1:0];

   assign                phase_ctrl_en_o  = phase_ctrl_engine_en;
   assign                phase_ch_en_o    = phase_ch_en;
   assign                phase_edge_o     = phase_edge;
   assign                phase_mode_o     = phase_mode;
   assign                phase_cnt_o      = phase_cnt;
   assign                phase_skip_cnt_o = phase_skip_cnt;
   assign                phase_step_o     = phase_step;

   // index for channels
   assign                ch_sel_w = axi_awaddr[CH_SEL_MSB:CH_SEL_LSB]-1;
   assign                ch_sel_r = axi_araddr[CH_SEL_MSB:CH_SEL_LSB]-1;

   assign                ch_sel_en_w = |axi_awaddr[CH_SEL_MSB:CH_SEL_LSB];
   assign                ch_sel_en_r = |axi_araddr[CH_SEL_MSB:CH_SEL_LSB];

   logic [PWM_CNT-1:0] phase_ch_en_d; // sample input which is used to reset phase_ch_en
   
   // Write registers
   always_ff @(posedge axi_bus.ACLK)
     if (axi_bus.ARESETn == 1'b0)
       begin
          phase_ctrl_engine_en <= 1'b0;
          phase_ch_en      <= 'h0;
          phase_edge       <= 'h0;
          phase_mode       <= 'h0;
          phase_cnt        <= 'h0;
          phase_skip_cnt   <= 'h0;
       end
     else
       begin
          if (slv_reg_wren)
            begin
               case ({ch_sel_en_w,axi_awaddr[1:0]})
                 PHASE_CTRL:
                   phase_ctrl_engine_en  <= axi_bus.WDATA[0];
                 CH_PHASE_CTRL:
                   begin
                      phase_ch_en[ch_sel_w] <= axi_bus.WDATA[0];
                      phase_edge[ch_sel_w]  <= axi_bus.WDATA[1];
                      phase_mode[ch_sel_w]  <= axi_bus.WDATA[7:4];
                   end
                 CH_PHASE_CNT_STEP:
                   begin
                      phase_cnt[ch_sel_w]      <= axi_bus.WDATA[7:0];
                      phase_skip_cnt[ch_sel_w] <= axi_bus.WDATA[15:8];
                      phase_step[ch_sel_w]     <= axi_bus.WDATA[31:16];
                   end
               endcase // case({ch_sel_en_w,axi_awaddr[1:0]})
            end
          for(integer i = 0; i < PWM_CNT; i = i + 1)
            begin
               if((phase_ch_en_d[i] == 1'b1) && (phase_ch_en_i[i] == 1'b0))
                 begin
                    phase_ch_en[i] <= 1'b0;
                 end
            end
       end // else: !if(axi_bus.ARESETn == 1'b0)

   // Address decoding for reading registers
   // Output register or memory read data
   // When there is a valid read address (ARVALID) with
   // acceptance of read address by the slave (ARREADY),
   always_ff @(posedge axi_bus.ACLK)
     if (axi_bus.ARESETn == 1'b0)
       begin
          axi_bus.RDATA <= 'h0;
       end
     else
       if (slv_reg_rden)
         begin
            case ({ch_sel_en_r,axi_araddr[1:0]})
              PHASE_CTRL:
                axi_bus.RDATA <= { {31{1'b0}}, phase_ctrl_engine_en };
              CH_PHASE_CTRL:
                axi_bus.RDATA <= { {24{1'b0}}, phase_mode[ch_sel_r], {2'b00}, phase_edge[ch_sel_r], phase_ch_en[ch_sel_r] };
              CH_PHASE_CNT_STEP:
                axi_bus.RDATA <= {phase_step[ch_sel_r], phase_skip_cnt[ch_sel_r], phase_cnt[ch_sel_r] };
              CH_PHASE_START_CUR_RB:
                axi_bus.RDATA[PWM_CNT_WIDTH-1:0] <= { {4{1'b0}}, phase_start_rb_i[ch_sel_r], {4{1'b0}}, phase_cur_rb_i[ch_sel_r] };
              default:
                axi_bus.RDATA <= 32'hdeadbeef;
            endcase // case({ch_sel_en_r,axi_araddr[1:0]})
         end

   genvar i;
   generate
      for(i = 0; i < PWM_CNT; i = i + 1)
        begin
           always_ff @(posedge axi_bus.ACLK)
             if(axi_bus.ARESETn == 1'b0)
               begin
                  phase_ch_en_d[i] <= 1'b0;
               end
             else
               begin
                  phase_ch_en_d[i] <= phase_ch_en_i[i];
               end
        end
   endgenerate
   
   // Example-specific design signals
   // local parameter for addressing 32 bit / 64 bit DW

   // Implement AWREADY generation
   // AWREADY is asserted for one ACLK clock cycle when both
   // AWVALID and WVALID are asserted. AWREADY is
   // de-asserted when reset is low.

   // slave is ready to accept write address when
   // there is a valid write address and write data
   // on the write address and data bus. This design
   // expects no outstanding transactions.
   // TODO: implement pipelining
   always_ff @(posedge axi_bus.ACLK)
     if (~axi_bus.ARESETn)
       axi_bus.AWREADY <= 1'b1;
     else
       axi_bus.AWREADY <= ~axi_bus.AWREADY & axi_bus.AWVALID & axi_bus.WVALID;

   // Implement axi_awaddr latching
   // This process is used to latch the address when both
   // AWVALID and WVALID are valid.

   // Write Address latching
   // TODO: remove reset
   // TODO: combine control signal
   always_ff @(posedge axi_bus.ACLK)
     if (~axi_bus.AWREADY & axi_bus.AWVALID & axi_bus.WVALID)
       axi_awaddr[AW-1-ADDR_LSB:0] <= axi_bus.AWADDR [AW-1:ADDR_LSB];

   // Implement WREADY generation
   // WREADY is asserted for one ACLK clock cycle when both
   // AWVALID and WVALID are asserted. WREADY is
   // de-asserted when reset is low.

   // slave is ready to accept write data when
   // there is a valid write address and write data
   // on the write address and data axi_bus. This design
   // expects no outstanding transactions.
   always_ff @(posedge axi_bus.ACLK)
     if (~axi_bus.ARESETn)
       axi_bus.WREADY <= 1'b1;
     else
       axi_bus.WREADY <= ~axi_bus.WREADY & axi_bus.WVALID & axi_bus.AWVALID;

   // Implement memory mapped register select and write logic generation
   // The write data is accepted and written to memory mapped registers when
   // AWREADY, WVALID, WREADY and WVALID are asserted. Write strobes are used to
   // select byte enables of slave registers while writing.
   // These registers are cleared when reset (active low) is applied.
   // Slave register write enable is asserted when valid address and data are available
   // and the slave is ready to accept the write address and write data.
   assign slv_reg_wren = axi_bus.WVALID & axi_bus.WREADY &
          axi_bus.AWVALID & axi_bus.AWREADY;


   // Implement write response logic generation
   // The write response and response valid signals are asserted by the slave
   // when WREADY, WVALID, WREADY and WVALID are asserted.
   // This marks the acceptance of address and indicates the status of
   // write transaction.

   always_ff @(posedge axi_bus.ACLK)
     if (axi_bus.ARESETn == 1'b0)
       axi_bus.BRESP <= 2'b0;
     else
       if (slv_reg_wren & ~axi_bus.BVALID)
         begin
            // indicates a valid write response is available
            axi_bus.BRESP  <= 2'b0; // 'OKAY' response
            // work error responses in future
         end

   always_ff @(posedge axi_bus.ACLK)
     if (axi_bus.ARESETn == 1'b0)
       axi_bus.BVALID  <= 0;
     else begin
        if (slv_reg_wren & ~axi_bus.BVALID) begin
           // indicates a valid write response is available
           axi_bus.BVALID <= 1'b1;
        end else if (axi_bus.BREADY & axi_bus.BVALID) begin
           //check if bready is asserted while bvalid is high)
           //(there is a possibility that bready is always asserted high)
           axi_bus.BVALID <= 1'b0;
        end
     end

   // Implement ARREADY generation
   // ARREADY is asserted for one ACLK clock cycle when
   // ARVALID is asserted. AWREADY is
   // de-asserted when reset (active low) is asserted.
   // The read address is also latched when ARVALID is
   // asserted. axi_araddr is reset to zero on reset assertion.

   // indicates that the slave has acceped the valid read address
   always_ff @(posedge axi_bus.ACLK)
     if (axi_bus.ARESETn == 1'b0)
       axi_bus.ARREADY <= 1'b1;
     else
       axi_bus.ARREADY <= ~axi_bus.ARREADY & axi_bus.ARVALID;

   // Read address latching
   always_ff @(posedge axi_bus.ACLK)
     if (~axi_bus.ARREADY & axi_bus.ARVALID)
       axi_araddr[AW-1-ADDR_LSB:0] <= axi_bus.ARADDR [AW-1:ADDR_LSB];

   // Implement axi_arvalid generation
   // RVALID is asserted for one ACLK clock cycle when both
   // ARVALID and ARREADY are asserted. The slave registers
   // data are available on the RDATA bus at this instance. The
   // assertion of RVALID marks the validity of read data on the
   // bus and RRESP indicates the status of read transaction.RVALID
   // is deasserted on reset (active low). RRESP and RDATA are
   // cleared to zero on reset (active low).
   always_ff @(posedge axi_bus.ACLK)
     if (axi_bus.ARESETn == 1'b0)
       begin
          axi_bus.RRESP <= 2'b0;
       end
     else
       if (slv_reg_rden)
         begin
            // Valid read data is available at the read data bus
            axi_bus.RRESP  <= 2'b0; // 'OKAY' response
         end

   always_ff @(posedge axi_bus.ACLK)
     if (axi_bus.ARESETn == 1'b0)
       begin
          axi_bus.RVALID <= 0;
       end
     else
       begin
          if (slv_reg_rden)
            begin
               // Valid read data is available at the read data bus
               axi_bus.RVALID <= 1'b1;
            end
          else if (axi_bus.RVALID & axi_bus.RREADY)
            begin
               // Read data is accepted by the master
               axi_bus.RVALID <= 1'b0;
            end
       end

   // Implement memory mapped register select and read logic generation
   // Slave register read enable is asserted when valid address is available
   // and the slave is ready to accept the read address.
   assign slv_reg_rden = axi_bus.ARVALID & axi_bus.ARREADY & ~axi_bus.RVALID;

endmodule : phase_ctrl_axi
