`timescale 1ps / 1ps

  module phase_ctrl_top #(
                     int unsigned DW = 32, // Width of AXI data
                     int unsigned AW = 16, // Width of AXI address
                     int unsigned PWM_CNT = 64,
                     int unsigned PWM_CNT_WIDTH = 24) // Number of PWM generators
    (
     axi4_lite_if.s axi_bus,

     pwm_ctrl_if.s pwm_ctrl
     );

    logic   phase_ctrl_en;
    logic   [PWM_CNT-1:0]                     phase_ch_en;
    logic   [PWM_CNT-1:0]                     phase_edge;
    logic   [PWM_CNT-1:0]               [3:0] phase_mode;
    logic   [PWM_CNT-1:0]               [7:0] phase_cnt;
    logic   [PWM_CNT-1:0]               [7:0] phase_skip_cnt;
    logic   [PWM_CNT-1:0] [PWM_CNT_WIDTH-1:0] phase_start;
    shortint                                  phase_step[PWM_CNT-1:0];

    phase_ctrl_axi #(.DW(DW), .AW(AW), .PWM_CNT(PWM_CNT), .PWM_CNT_WIDTH(PWM_CNT_WIDTH)) phase_ctrl_axi_i
    (
     .axi_bus(axi_bus),

     .phase_ctrl_en_o(phase_ctrl_en),
     .phase_ch_en_o(phase_ch_en),
     .phase_edge_o(phase_edge),
     .phase_mode_o(phase_mode),
     .phase_cnt_o(phase_cnt),
     .phase_skip_cnt_o(phase_skip_cnt),
     .phase_step_o(phase_step),

     .phase_ch_en_i(pwm_ctrl.pwm_ctrl),
     .phase_start_rb_i(phase_start),
     .phase_cur_rb_i(pwm_ctrl.pwm_phase)
    );

   genvar i;
   generate   
        for(i = 0; i < PWM_CNT; i = i +1)
          begin
             phase_ctrl_fsm #(.PWM_CNT_WIDTH(PWM_CNT_WIDTH)) phase_ctrl_fsm_i
               (
                .axi_clk(axi_bus.ACLK),
                .axi_rstn(axi_bus.ARESETn),

                .phase_ctrl_en_i(phase_ctrl_en),
                .phase_ch_en_i(phase_ch_en[i]),
                .phase_edge_i(phase_edge[i]),
                .phase_mode_i(phase_mode[i]),
                .phase_cnt_i(phase_cnt[i]),
                .phase_skip_cnt_i(phase_skip_cnt[i]),
                .phase_step_i(phase_step[i]),
                .phase_start_i(pwm_ctrl.pwm_phase[i]),
                .pwm_period_i(pwm_ctrl.pwm_period),
                .pwm_sig_i(pwm_ctrl.pwm_sig[i]),

                .phase_ch_en_o(pwm_ctrl.pwm_ctrl[i]),
                .phase_start_o(phase_start[i]),
                .phase_cur_phase_o(pwm_ctrl.pwm_auto_phase[i]),
                .phase_fsm_end_o(pwm_ctrl.pwm_auto_end[i])
                );
          end // for (i = 0; i < PWM_CNT; i = i +1)
   endgenerate
   
  endmodule // phase_ctrl_top
