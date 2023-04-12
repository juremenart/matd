`define FSM_MODE_CNT_FULL_PHASE 4'h01

module phase_ctrl_fsm #(
                        int unsigned PWM_CNT_WIDTH = 24)
  (
   input logic axi_clk,
   input logic axi_rstn,
   
   // from AXI
   // All configuration inputs must be stable during operation
   // It is up to external module to protect (allow change only when
   // phase_ch_en_o == 1'b0
   input logic                     phase_ctrl_en_i,
   input logic                     phase_ch_en_i,
   input logic                     phase_edge_i,
   input logic               [3:0] phase_mode_i,
   input logic               [7:0] phase_cnt_i,
   input logic               [7:0] phase_skip_cnt_i,
   input shortint                  phase_step_i,
   input logic [PWM_CNT_WIDTH-1:0] phase_start_i,
   input logic [PWM_CNT_WIDTH-1:0] pwm_period_i,
   input logic                     pwm_sig_i,

   output logic                     phase_ch_en_o,
   output logic [PWM_CNT_WIDTH-1:0] phase_start_o,
   output logic [PWM_CNT_WIDTH-1:0] phase_cur_phase_o,
   output logic                     phase_fsm_end_o
   );

   logic ch_enable, ch_enable_d, phase_ch_en, phase_ch_en_d;

   logic [PWM_CNT_WIDTH-1:0] phase_cur_phase, phase_start;
   logic [8:0] phase_cnt, phase_skip_cnt;

   typedef enum integer{ IDLE, PREPARE, CNT_FULL_PHASE } fsm_state_t;

   fsm_state_t fsm_state;
   logic fsm_start, fsm_cnt_phase, fsm_cnt_done, fsm_state_end, fsm_cnt_cont;

   logic pwm_sig_d, pwm_edge_det;
   
   // always enabled only if bith - channel and engine are enabled
   assign ch_enable = phase_ctrl_en_i && phase_ch_en_i;
   assign pwm_edge_det =
          ( pwm_sig_i && ~pwm_sig_d &&  phase_edge_i) ||
          (~pwm_sig_i &&  pwm_sig_d && ~phase_edge_i);

   assign phase_start_o     = phase_start;
   assign phase_cur_phase_o = phase_cur_phase;
   assign phase_ch_en_o     = phase_ch_en_d;

   assign phase_fsm_end_o   = fsm_state_end;
   
   // Main state machine
   always_ff @(posedge axi_clk)
     if(axi_rstn == 1'b0)
       begin
          fsm_state       <= IDLE;
          fsm_start       <= 1'b0;
          fsm_cnt_phase   <= 1'b0;
          phase_ch_en     <= 1'b0;
          fsm_state_end   <= 1'b1;
          fsm_cnt_cont    <= 1'b0;
       end
     else
       begin
          fsm_state       <= fsm_state;
          fsm_start       <= 1'b0;
          fsm_cnt_phase   <= 1'b0;
          phase_ch_en     <= 1'b1;
          fsm_state_end   <= 1'b0;
          
          case(fsm_state)
            IDLE:
              begin
                 phase_ch_en <= 1'b0;
                 if((ch_enable_d == 1'b0) && (ch_enable == 1'b1))
                   begin
                      if(phase_mode_i > 0)
                        begin
                           phase_skip_cnt <= phase_skip_cnt_i;
                           fsm_start   <= 1'b1;
                           fsm_state   <= PREPARE;
                           phase_ch_en <= 1'b1;
                        end
                   end
              end // case: IDLE
            PREPARE:
              // register current/start phase before switching control mux
              begin
                 if(ch_enable == 1'b0)
                   begin
                      fsm_state_end <= 1'b1;
                      fsm_state <= IDLE;
                   end
                 case(phase_mode_i)
                   `FSM_MODE_CNT_FULL_PHASE:
                     begin
                        if(phase_cnt_i == 0)
                          fsm_cnt_cont <= 1'b1;
                        else
                          fsm_cnt_cont <= 1'b0;
                        
                        fsm_state <= CNT_FULL_PHASE;
                     end
                   default:
                     begin
                        fsm_state_end <= 1'b1;
                        fsm_state <= IDLE;
                     end
                 endcase // case(phase_mode_i)       
              end // case: PREPARE
            CNT_FULL_PHASE:
              begin
                 if((ch_enable == 1'b0) || (phase_cnt == 0 && ~fsm_cnt_cont))
                   begin
                      fsm_state_end <= 1'b1;
                      fsm_state <= IDLE;
                   end
                 if(pwm_edge_det)
                   begin
                      if(phase_skip_cnt == 0)
                        begin
                           fsm_cnt_phase <= 1'b1;
                           phase_skip_cnt <= phase_skip_cnt_i;
                        end
                      else
                        phase_skip_cnt <= phase_skip_cnt - 1;
                   end
                 
              end
          endcase // case(fsm_state)
       end // else: !if(axi_rstn == 1'b0)

   logic [3:0] debug_wires;
   
   always_ff @(posedge axi_clk)
     if(axi_rstn == 1'b0)
       begin
          phase_cur_phase         <= 'h0;
          phase_start             <= 'h0;
          fsm_cnt_done            <= 1'b0;
          debug_wires <= 'h0;
       end
     else
       begin
          fsm_cnt_done            <= 1'b0;
          if(fsm_start)
            begin
               phase_cur_phase <= phase_start_i;
               phase_start     <= phase_start_i;
               phase_cnt       <= {1'b0, phase_cnt_i} + 1;
            end
          if(fsm_cnt_phase)
            begin
               integer next_step;

               next_step = integer(phase_cur_phase) + phase_step_i;

               // Overflows/Underflow
               if(next_step > integer(pwm_period_i))
                 next_step = next_step - pwm_period_i + 1;
               else if(next_step < 0)
                 next_step = pwm_period_i + next_step - 1;

               // Detect if we counted one phase
               if(integer(phase_cur_phase) + phase_step_i > integer(pwm_period_i))
                 begin
                    debug_wires <= 4'h1;
                    if((phase_start > phase_cur_phase) || (phase_start < next_step))
                      phase_cnt <= phase_cnt - 1;
                 end
               else if(integer(phase_cur_phase) + phase_step_i < 0)
                 begin
                    debug_wires <= 4'h2;
                    if((phase_start < phase_cur_phase) || (phase_start > next_step))
                      phase_cnt <= phase_cnt - 1;
                 end
               else if((phase_cur_phase >= phase_start) && (next_step <= phase_start))
                 begin
                    debug_wires <= 4'h3;
                    phase_cnt <= phase_cnt - 1;
                 end
               else if((phase_cur_phase <= phase_start) && (next_step >= phase_start))
                 begin
                    debug_wires <= 4'h4;
                    phase_cnt <= phase_cnt - 1;
                 end
               else
                 debug_wires <= 4'h0;
               
               phase_cur_phase <= next_step;

            end
       end // else: !if(axi_rstn == 1'b0)

   always_ff @(posedge axi_clk)
     if(axi_rstn == 1'b0)
       begin
          ch_enable_d  <= 1'b0;
          pwm_sig_d    <= 1'b0;
          phase_ch_en_d <= 1'b0;
       end
     else
       begin
          ch_enable_d <= ch_enable;
          pwm_sig_d   <= pwm_sig_i;
          phase_ch_en_d <= phase_ch_en;
       end

endmodule // phase_ctrl_fsm
