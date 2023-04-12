`timescale 1 ps / 1 ps

module pwm_gen
  #(
   int unsigned CNT_WIDTH = 24
    )
  (
   input logic        axi_clk,
   input logic        axi_rstn,

   output logic       pwm_o,

   input logic [CNT_WIDTH-1:0] main_cnt_i,
   input logic [CNT_WIDTH-1:0] pwm_period_i,
   input logic                 pwm_cnt_enable_i,
   input logic                 pwm_enable_i,
   input logic [CNT_WIDTH-1:0] pwm_active_i,
   input logic [CNT_WIDTH-1:0] pwm_phase_i);
   
   // Main counter
   logic pwm_enable, r_pwm_enable;
   logic [CNT_WIDTH-1:0]       r_active, r_phase;
   logic [CNT_WIDTH-1:0]       overflow, overflow_d;
   logic [CNT_WIDTH-1:0]       delayed_enable;

   logic pwm_out, pwm_out_d;
   
   assign pwm_o = pwm_out;

   always_ff @(posedge axi_clk)
     if(axi_rstn == 1'b0)
       begin
          r_active       <= 'h0;
          r_phase        <= 'h0;
          overflow       <= 'h0;
          overflow_d     <= 'h0;
          r_pwm_enable   <= 'h0;
          delayed_enable <= 'h0;

       end
     else
       begin
          if(delayed_enable > 0)
             delayed_enable <= delayed_enable - 1;

          // When to update to have best output (with no spikes and quick response)
          // If we have phase change and we finished current pulse (negedge)
          // we sample new phase so we will be able to start it if it's before
          // the end of main cnt cycle

          // This is the use-case when we have sliding phase and we wrap from phase 0 to late phase
          if((pwm_out == 1'b0) && (pwm_out_d == 1'b1) &&
             (r_phase != pwm_phase_i) && (pwm_phase_i > main_cnt_i))
            begin
               r_phase <= pwm_phase_i;
               if((pwm_phase_i+pwm_active_i) > pwm_period_i)
                 begin
                    overflow <= (pwm_phase_i+pwm_active_i)-pwm_period_i;
                    // we wait for first counter reset before using the overflow
                    overflow_d <= (pwm_phase_i+pwm_active_i)-pwm_period_i;
                 end
               else
                 begin
                    overflow <= 'h0;
                    overflow_d <= 'h0;
                 end
            end
          // update always at the beginning of the counter
          if((main_cnt_i == (pwm_period_i-1)) && (pwm_cnt_enable_i))
          // update always with neg-edge of PWM output
            begin
              r_active     <= pwm_active_i;
              r_phase      <= pwm_phase_i;
              r_pwm_enable <= pwm_enable_i;

              // Delay to finish overflow sample
              if((r_pwm_enable == 1'b1) && (pwm_enable_i == 1'b0))
                delayed_enable <= overflow_d;

              if((pwm_phase_i+pwm_active_i) > pwm_period_i)
                overflow <= (pwm_phase_i+pwm_active_i)-pwm_period_i;
              else
                overflow <= 'h0;

              // we wait for first counter reset before using the overflow
              overflow_d <= overflow;
            end               
       end // else: !if(axi_rstn == 1'b0)

   assign pwm_enable = r_pwm_enable && pwm_cnt_enable_i;

   always_ff @(posedge axi_clk)
     if(axi_rstn == 1'b0)
       begin
          pwm_out_d        <= 'h0;
       end
     else
       begin
          pwm_out_d        <= pwm_out;
       end

   // complication is for overflow (if phase+pulse > period)
   // delayed enable - if we are in the middle of the pulse we should finish it
   // (overflow counter)
   assign pwm_out = (pwm_enable || (delayed_enable>0)) &&
             (((main_cnt_i <= overflow_d-1) && (overflow_d > 0)) ||
             ((main_cnt_i >= r_phase) && (main_cnt_i < (r_active+r_phase))));

endmodule: pwm_gen
