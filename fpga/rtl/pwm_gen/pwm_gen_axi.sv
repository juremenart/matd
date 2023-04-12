`timescale 1 ps / 1 ps

// TODO: Check where JJJ is in the comment - problem with using logic from interface axi4_lite_if during elaboration (only for simulation)

module pwm_gen_axi #(
  int unsigned DW = 32, // Width of AXI data    bus
  int unsigned AW = 16, // Width of AXI address bus
  int unsigned PWM_CNT = 64, // number of PWMs                     
  int          PWM_CNT_WIDTH = 24) // width of PWM counters
   (
    // AXI-Lite slave
    axi4_lite_if.s axi_bus,

    output logic                                  pwm_cnt_enable_o,
    output logic [PWM_CNT_WIDTH-1:0]              pwm_period_o,
    output logic [PWM_CNT_WIDTH-1:0]              pwm_active_o,
    output logic [PWM_CNT-1:0]                    pwm_enable_o,
    output logic [PWM_CNT-1:0][PWM_CNT_WIDTH-1:0] pwm_phase_o,

    input logic [PWM_CNT-1:0][PWM_CNT_WIDTH-1:0] pwm_phase_rb_i,
    input logic [PWM_CNT-1:0]                    pwm_auto_end_i
    );

   // Register map
   localparam PWM_CTRL_STATUS = 3'h0; // 0x00 +                R/W PWM Ctrl/Status register
   localparam PWM_PERIOD      = 3'h1; // 0x04 +                R/W PWM Period
   localparam PWM_ACTIVE      = 3'h2; // 0x08                  R/W PWM Active (high)
   // 0x0C reserved
   localparam PWM_ENABLE      = 3'h4; // 0x10 + (0x8 * i) R/W PWM Enable
   localparam PWM_PHASE       = 3'h5; // 0x14 + (0x8 * i) R/W PWM Phase
   localparam PWM_ENABLE_2    = 3'h6; // 0x18 + (0x8 * i) - Also enable
   localparam PWM_PHASE_2     = 3'h7; // 0x1C + (0x8 * i) - Also phase
   localparam PWM_SEL_SIZE    =  12; // PWM Selector size
   localparam PWM_SEL_MSB     =  11; // PWM Selector MSB (from address bits)
   localparam PWM_SEL_LSB     =   2; // PWM Selector LSB (from address bits)

//----------------------------------------------
   //-- Signals for user logic register space example
   //------------------------------------------------
   localparam int unsigned ADDR_LSB = $clog2(DW/8);

   logic                   slv_reg_rden;
   logic                   slv_reg_wren;
   // AXI4LITE signals
   logic [AW-1-ADDR_LSB:0]    axi_awaddr;
   logic [AW-1-ADDR_LSB:0]    axi_araddr;
   logic [PWM_SEL_SIZE:0]   pwm_sel_r, pwm_sel_w;
   logic                    pwm_ch_sel_r, pwm_ch_sel_w; // channel register accessed
   
   logic                     pwm_cnt_enable;
   logic [PWM_CNT_WIDTH-1:0] pwm_period;
   logic [PWM_CNT_WIDTH-1:0] pwm_active;

   logic [PWM_CNT-1:0]                    pwm_enable;
   logic [PWM_CNT-1:0][PWM_CNT_WIDTH-1:0] pwm_phase;
   logic [PWM_CNT-1:0][PWM_CNT_WIDTH-1:0] pwm_phase_s;

   assign pwm_cnt_enable_o = pwm_cnt_enable;
   assign pwm_period_o   = pwm_period;
   assign pwm_active_o   = pwm_active;
   
   assign pwm_enable_o   = pwm_enable;
   assign pwm_phase_o    = pwm_phase_s;

   // index for channels
   assign pwm_sel_w = {axi_awaddr[PWM_SEL_MSB:PWM_SEL_LSB-1]}-2;
   assign pwm_sel_r = {axi_araddr[PWM_SEL_MSB:PWM_SEL_LSB-1]}-2;

   // detect if channel is selected
   assign pwm_ch_sel_r = |axi_araddr[PWM_SEL_MSB:PWM_SEL_LSB];
   assign pwm_ch_sel_w = |axi_awaddr[PWM_SEL_MSB:PWM_SEL_LSB];

   // Write registers
   always_ff @(posedge axi_bus.ACLK)
     if (axi_bus.ARESETn == 1'b0)
       begin
          pwm_cnt_enable <= 1'b0;
          pwm_enable <= 'h0;
          pwm_period <= 'h0;
          pwm_active <= 'h0;
          pwm_phase  <= 'h0;
          pwm_phase_s <= 'h0;
       end
     else
       begin
          if (slv_reg_wren)
            begin
               case ({pwm_ch_sel_w,axi_awaddr[1:0]})
                 PWM_CTRL_STATUS:
                   begin
                      pwm_cnt_enable                <= axi_bus.WDATA[0];
                      // sync
                      if(axi_bus.WDATA[1] == 1'b1)
                        begin
                           pwm_phase_s <= pwm_phase;
                        end
                   end
                 PWM_PERIOD:
                   pwm_period[PWM_CNT_WIDTH-1:0] <= axi_bus.WDATA[PWM_CNT_WIDTH-1:0];
                 PWM_ACTIVE:
                   pwm_active[PWM_CNT_WIDTH-1:0] <= axi_bus.WDATA[PWM_CNT_WIDTH-1:0];
                 PWM_ENABLE:
                   pwm_enable[pwm_sel_w]         <= axi_bus.WDATA[0];
                 PWM_ENABLE_2:
                   pwm_enable[pwm_sel_w]         <= axi_bus.WDATA[0];
                 PWM_PHASE:
                   pwm_phase[pwm_sel_w][PWM_CNT_WIDTH-1:0]  <= axi_bus.WDATA[PWM_CNT_WIDTH-1:0];
                 PWM_PHASE_2:
                   pwm_phase[pwm_sel_w][PWM_CNT_WIDTH-1:0]  <= axi_bus.WDATA[PWM_CNT_WIDTH-1:0];
               endcase
            end // if (slv_reg_wren)

          // see if we need to update pwm_phase
          for(integer i = 0; i < PWM_CNT; i = i + 1)
            begin
               if(pwm_auto_end_i[i] == 1'b1)
                 pwm_phase[i] <= pwm_phase_rb_i[i];
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
            case ({pwm_ch_sel_r,axi_araddr[1:0]})
              PWM_CTRL_STATUS:
                axi_bus.RDATA <= { PWM_CNT[7:0], PWM_CNT_WIDTH[7:0], {7{1'b0}}, pwm_cnt_enable};
              PWM_PERIOD:
                axi_bus.RDATA[PWM_CNT_WIDTH-1:0] <= pwm_period[PWM_CNT_WIDTH-1:0];
              PWM_ACTIVE:
                axi_bus.RDATA[PWM_CNT_WIDTH-1:0] <= pwm_active[PWM_CNT_WIDTH-1:0];
              PWM_ENABLE:
                axi_bus.RDATA <= { {31{1'b0}}, pwm_enable[pwm_sel_r]};
              PWM_ENABLE_2:
                axi_bus.RDATA <= { {31{1'b0}}, pwm_enable[pwm_sel_r]};
              PWM_PHASE:
                axi_bus.RDATA[PWM_CNT_WIDTH-1:0] <= pwm_phase_rb_i[pwm_sel_r][PWM_CNT_WIDTH-1:0];
              PWM_PHASE_2:
                axi_bus.RDATA[PWM_CNT_WIDTH-1:0] <= pwm_phase_rb_i[pwm_sel_r][PWM_CNT_WIDTH-1:0];
              default:
                axi_bus.RDATA <= 32'hdeadbeef;
            endcase // case({pwm_ch_sel_r,axi_araddr[1:0]})
         end

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

endmodule : pwm_gen_axi
