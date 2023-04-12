//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.3 (lin64) Build 2018833 Wed Oct  4 19:58:07 MDT 2017
//Date        : Fri Dec 22 08:53:28 2017
//Host        : menart-VirtualBox running 64-bit Ubuntu 17.10
//Command     : generate_target bd_system_wrapper.bd
//Design      : bd_system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

`define PWM_CNT      125
//`define PWM_CNT       64
//`define PWM_CNT       4

`define PWM_CNT_WIDTH 12

module bd_system_wrapper
  (DDR_addr,
   DDR_ba,
   DDR_cas_n,
   DDR_ck_n,
   DDR_ck_p,
   DDR_cke,
   DDR_cs_n,
   DDR_dm,
   DDR_dq,
   DDR_dqs_n,
   DDR_dqs_p,
   DDR_odt,
   DDR_ras_n,
   DDR_reset_n,
   DDR_we_n,
   FIXED_IO_ddr_vrn,
   FIXED_IO_ddr_vrp,
   FIXED_IO_mio,
   FIXED_IO_ps_clk,
   FIXED_IO_ps_porb,
   FIXED_IO_ps_srstb,
   pwm);

   inout [14:0]DDR_addr;
   inout [2:0] DDR_ba;
   inout       DDR_cas_n;
   inout       DDR_ck_n;
   inout       DDR_ck_p;
   inout       DDR_cke;
   inout       DDR_cs_n;
   inout [3:0] DDR_dm;
   inout [31:0] DDR_dq;
   inout [3:0]  DDR_dqs_n;
   inout [3:0]  DDR_dqs_p;
   inout        DDR_odt;
   inout        DDR_ras_n;
   inout        DDR_reset_n;
   inout        DDR_we_n;
   inout        FIXED_IO_ddr_vrn;
   inout        FIXED_IO_ddr_vrp;
   inout [53:0] FIXED_IO_mio;
   inout        FIXED_IO_ps_clk;
   inout        FIXED_IO_ps_porb;
   inout        FIXED_IO_ps_srstb;
   output [`PWM_CNT-1:0] pwm;

   wire [14:0]  DDR_addr;
   wire [2:0]   DDR_ba;
   wire         DDR_cas_n;
   wire         DDR_ck_n;
   wire         DDR_ck_p;
   wire         DDR_cke;
   wire         DDR_cs_n;
   wire [3:0]   DDR_dm;
   wire [31:0]  DDR_dq;
   wire [3:0]   DDR_dqs_n;
   wire [3:0]   DDR_dqs_p;
   wire         DDR_odt;
   wire         DDR_ras_n;
   wire         DDR_reset_n;
   wire         DDR_we_n;
   wire         FCLK_CLK0; // 10MHz from PS, used for all AXI4-Lite interconnection
   wire         FCLK_RESET0_N;
   wire         FCLK_CLK1; // 100MHz from PS, used for AXI4-Stream connections
   wire         FCLK_RESET1_N;
   wire         FIXED_IO_ddr_vrn;
   wire         FIXED_IO_ddr_vrp;
   wire [53:0]  FIXED_IO_mio;
   wire         FIXED_IO_ps_clk;
   wire         FIXED_IO_ps_porb;
   wire         FIXED_IO_ps_srstb;


   // AXI4-Lite buses
   // PWM generators physical address: 0x43C0_0000
   axi4_lite_if axi_bus_pwm_gen(.ACLK(FCLK_CLK0), .ARESETn(FCLK_RESET0_N));
   // VIDEO_CTRL physical address: 0x43C1_0000
   axi4_lite_if axi_bus_phase_ctrl(.ACLK(FCLK_CLK0), .ARESETn(FCLK_RESET0_N));
   pwm_ctrl_if #(.PWM_CNT(`PWM_CNT),.PWM_CNT_WIDTH(`PWM_CNT_WIDTH)) pwm_ctrl();

   // Temporary hack to have tow channels with 180 degree shift
   assign       pwm = pwm_ctrl.pwm_sig;
   
   pwm_gen_top #(.PWM_CNT(`PWM_CNT),.PWM_CNT_WIDTH(`PWM_CNT_WIDTH)) pwm_gen_top_i
     (.axi_bus(axi_bus_pwm_gen),
      .pwm_ctrl(pwm_ctrl));

//   phase_ctrl_top #(.PWM_CNT(`PWM_CNT),.PWM_CNT_WIDTH(`PWM_CNT_WIDTH)) phase_ctrl_top_i
//     (
//      .axi_bus(axi_bus_phase_ctrl),
//      .pwm_ctrl(pwm_ctrl));

   bd_system bd_system_i
     (.DDR_addr(DDR_addr),
      .DDR_ba(DDR_ba),
      .DDR_cas_n(DDR_cas_n),
      .DDR_ck_n(DDR_ck_n),
      .DDR_ck_p(DDR_ck_p),
      .DDR_cke(DDR_cke),
      .DDR_cs_n(DDR_cs_n),
      .DDR_dm(DDR_dm),
      .DDR_dq(DDR_dq),
      .DDR_dqs_n(DDR_dqs_n),
      .DDR_dqs_p(DDR_dqs_p),
      .DDR_odt(DDR_odt),
      .DDR_ras_n(DDR_ras_n),
      .DDR_reset_n(DDR_reset_n),
      .DDR_we_n(DDR_we_n),
      .FCLK_CLK0(FCLK_CLK0),
      .FCLK_RESET0_N(FCLK_RESET0_N),
      .FCLK_CLK1_0(FCLK_CLK1),
      .FCLK_RESET1_N_0(FCLK_RESET1_N),
      .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
      .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
      .FIXED_IO_mio(FIXED_IO_mio),
      .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
      .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
      .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
      .M00_AXI_0_araddr(axi_bus_pwm_gen.ARADDR),
      .M00_AXI_0_arprot(axi_bus_pwm_gen.ARPROT),
      .M00_AXI_0_arready(axi_bus_pwm_gen.ARREADY),
      .M00_AXI_0_arvalid(axi_bus_pwm_gen.ARVALID),
      .M00_AXI_0_awaddr(axi_bus_pwm_gen.AWADDR),
      .M00_AXI_0_awprot(axi_bus_pwm_gen.AWPROT),
      .M00_AXI_0_awready(axi_bus_pwm_gen.AWREADY),
      .M00_AXI_0_awvalid(axi_bus_pwm_gen.AWVALID),
      .M00_AXI_0_bready(axi_bus_pwm_gen.BREADY),
      .M00_AXI_0_bresp(axi_bus_pwm_gen.BRESP),
      .M00_AXI_0_bvalid(axi_bus_pwm_gen.BVALID),
      .M00_AXI_0_rdata(axi_bus_pwm_gen.RDATA),
      .M00_AXI_0_rready(axi_bus_pwm_gen.RREADY),
      .M00_AXI_0_rresp(axi_bus_pwm_gen.RRESP),
      .M00_AXI_0_rvalid(axi_bus_pwm_gen.RVALID),
      .M00_AXI_0_wdata(axi_bus_pwm_gen.WDATA),
      .M00_AXI_0_wready(axi_bus_pwm_gen.WREADY),
      .M00_AXI_0_wstrb(axi_bus_pwm_gen.WSTRB),
      .M00_AXI_0_wvalid(axi_bus_pwm_gen.WVALID),
      .M02_AXI_0_araddr(axi_bus_phase_ctrl.ARADDR),
      .M02_AXI_0_arprot(axi_bus_phase_ctrl.ARPROT),
      .M02_AXI_0_arready(axi_bus_phase_ctrl.ARREADY),
      .M02_AXI_0_arvalid(axi_bus_phase_ctrl.ARVALID),
      .M02_AXI_0_awaddr(axi_bus_phase_ctrl.AWADDR),
      .M02_AXI_0_awprot(axi_bus_phase_ctrl.AWPROT),
      .M02_AXI_0_awready(axi_bus_phase_ctrl.AWREADY),
      .M02_AXI_0_awvalid(axi_bus_phase_ctrl.AWVALID),
      .M02_AXI_0_bready(axi_bus_phase_ctrl.BREADY),
      .M02_AXI_0_bresp(axi_bus_phase_ctrl.BRESP),
      .M02_AXI_0_bvalid(axi_bus_phase_ctrl.BVALID),
      .M02_AXI_0_rdata(axi_bus_phase_ctrl.RDATA),
      .M02_AXI_0_rready(axi_bus_phase_ctrl.RREADY),
      .M02_AXI_0_rresp(axi_bus_phase_ctrl.RRESP),
      .M02_AXI_0_rvalid(axi_bus_phase_ctrl.RVALID),
      .M02_AXI_0_wdata(axi_bus_phase_ctrl.WDATA),
      .M02_AXI_0_wready(axi_bus_phase_ctrl.WREADY),
      .M02_AXI_0_wstrb(axi_bus_phase_ctrl.WSTRB),
      .M02_AXI_0_wvalid(axi_bus_phase_ctrl.WVALID));

endmodule
