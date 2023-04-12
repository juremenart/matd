interface pwm_ctrl_if
  #(
    int unsigned PWM_CNT = 64,
    int          PWM_CNT_WIDTH = 24
    )
   (
    );

// write address channel
logic [PWM_CNT-1:0] pwm_ctrl;    // 0-pwm_gen controls, 1-logic controls
logic [PWM_CNT-1:0] pwm_sig;     // PWM value going to pins, generated in the pwm_gen()

// common configuration
logic                     pwm_cnt_enable; // Enable main counter
logic [PWM_CNT_WIDTH-1:0] pwm_period; // Main counter period
logic [PWM_CNT_WIDTH-1:0] pwm_active; // PWM active (signal asserted high)

logic [PWM_CNT-1:0] pwm_enable; // PWM enable - generated in pwm_gen_axi()
// Phase is selected between auto and man depending on pwm_ctrl signal (asserted high
// when phase_ctrl engine is working)
logic [PWM_CNT-1:0][PWM_CNT_WIDTH-1:0] pwm_phase;  // Real PWM phase
logic [PWM_CNT-1:0][PWM_CNT_WIDTH-1:0] pwm_auto_phase;  // PWM phase (from phase_ctrl - automatically calculated)
logic [PWM_CNT-1:0][PWM_CNT_WIDTH-1:0] pwm_man_phase;  // PWM phase (from pwm_gen_axi - manually set)
logic [PWM_CNT-1:0]                    pwm_auto_end;   // Phase ctrl signalised it will end (can latch auto phase for example)

// master port
modport m (
           input  pwm_ctrl,
           output pwm_sig,
           output pwm_cnt_enable,
           output pwm_enable,
           output pwm_period,
           output pwm_active,
           output pwm_phase,
           output pwm_man_phase,
           input  pwm_auto_phase,
           input  pwm_auto_end);

// slave port
modport s (
           output pwm_ctrl,
           input  pwm_sig,
           input  pwm_cnt_enable,
           input  pwm_enable,
           input  pwm_period,
           input  pwm_active,
           input  pwm_phase,
           input  pwm_man_phase,
           output pwm_auto_phase,
           output pwm_auto_end);


endinterface: pwm_ctrl_if
