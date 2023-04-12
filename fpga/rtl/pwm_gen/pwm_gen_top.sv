`timescale 1ps / 1ps

module pwm_gen_top #(
                     int unsigned DW = 32, // Width of AXI data
                     int unsigned AW = 16, // Width of AXI address
                     int unsigned PWM_CNT = 64,
                     int unsigned PWM_CNT_WIDTH = 24) // Number of PWM generators
  (
      axi4_lite_if.s axi_bus,

      pwm_ctrl_if.m pwm_ctrl
  );

   logic [PWM_CNT_WIDTH-1:0] main_cnt, r_period;
           
  pwm_gen_axi #(.DW(DW), .AW(AW), .PWM_CNT(PWM_CNT), .PWM_CNT_WIDTH(PWM_CNT_WIDTH)) pwm_gen_axi_i
  (
      .axi_bus(axi_bus),

      .pwm_cnt_enable_o(pwm_ctrl.pwm_cnt_enable),
      .pwm_enable_o(pwm_ctrl.pwm_enable),
      .pwm_period_o(pwm_ctrl.pwm_period),
      .pwm_active_o(pwm_ctrl.pwm_active),
      .pwm_phase_o(pwm_ctrl.pwm_man_phase),
      .pwm_phase_rb_i(pwm_ctrl.pwm_phase),
      .pwm_auto_end_i(pwm_ctrl.pwm_auto_end)
  );

  genvar i;
  generate
     for(i = 0; i < PWM_CNT; i = i + 1)
       begin
          assign pwm_ctrl.pwm_phase[i] = pwm_ctrl.pwm_ctrl[i] ?
                                         pwm_ctrl.pwm_auto_phase[i] :
                                         pwm_ctrl.pwm_man_phase[i];

          pwm_gen #(.CNT_WIDTH(PWM_CNT_WIDTH)) pwm_gen_i (
              .axi_clk(axi_bus.ACLK),
              .axi_rstn(axi_bus.ARESETn),

              .pwm_o(pwm_ctrl.pwm_sig[i]),

              .main_cnt_i(main_cnt),
              .pwm_cnt_enable_i(pwm_ctrl.pwm_cnt_enable),
              .pwm_period_i(pwm_ctrl.pwm_period),
              .pwm_active_i(pwm_ctrl.pwm_active),
              .pwm_enable_i(pwm_ctrl.pwm_enable[i]),
              .pwm_phase_i(pwm_ctrl.pwm_phase[i])
           );
        end // for (i = 0; i < PWM_CNT; i = i + 1)
  endgenerate

  // Main PWM counter used for all others
  always_ff @(posedge axi_bus.ACLK)
    if(axi_bus.ARESETn == 1'b0)
      begin
        main_cnt <= '0;
        r_period <= '0;
      end
    else
      begin
        if(pwm_ctrl.pwm_cnt_enable == 1'b0)
          begin
            main_cnt <= '0;
            r_period <= pwm_ctrl.pwm_period;
          end
        else
          begin
            if(main_cnt == 0)
                r_period <= pwm_ctrl.pwm_period;
            if(main_cnt == r_period-1)
              main_cnt <= '0;
            else
              main_cnt <= main_cnt + 1;
          end
      end

endmodule : pwm_gen_top
