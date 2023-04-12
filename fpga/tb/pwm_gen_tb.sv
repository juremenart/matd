`timescale 1ps / 1ps

//`define PWM_CNT       64
`define PWM_CNT        4
`define PWM_CNT_WIDTH 12

module pwm_gen_tb
  #(
    // time periods
    realtime               TP = 20.0ns // 50MHz
    );

   ////////////////////////////////////////////////////////////////////////////////
   // signal generation
   ////////////////////////////////////////////////////////////////////////////////

   logic                                    clk ;
   logic                                    rstn;

   logic                                    pwm0_pad, pwm1_pad;

   // Clock
   initial        clk = 1'b0;
   always #(TP/2) clk = ~clk;

   // Reset
   initial begin
      rstn = 1'b0;
      repeat(4) @(posedge clk);
      rstn = 1'b1;
   end

   ////////////////////////////////////////////////////////////////////////////////
   // test sequence
   ////////////////////////////////////////////////////////////////////////////////

   initial begin
      pwm_gen_axi_write('h00, 0);
      repeat(8) @(posedge clk);

      // switch PWM outputs to PWM_SYS
      // 40kHz 50% duty cycle
      pwm_gen_axi_write('h04, 1250);
      pwm_gen_axi_write('h08, 625);

      repeat(2) @(posedge clk);

      // Channel 0
      pwm_gen_axi_write('h14, 0);
      pwm_gen_axi_write('h10, 1);

      // Channel 1
      pwm_gen_axi_write('h1C, 625);
      pwm_gen_axi_write('h18, 1);

      // Channel 2
      pwm_gen_axi_write('h24, 0);
      pwm_gen_axi_write('h20, 1);

      // Channel 3
      pwm_gen_axi_write('h2C, 625);
      pwm_gen_axi_write('h28, 1);
      
      pwm_gen_axi_write('h00, 1);

      repeat(10000) @(posedge clk);

      phase_ctrl_axi_write('h0, 0);
      
      // Start shifting the phases a little bit
      // We leave channel 0 alone (as reference signal)
      // Edge bit is inverted for ch0 & ch1 and ch2 & ch3 so both
      // phases are updated at the same time (they are 180 degrees shifted
      // because of the differential PWM driver L928N)
      phase_ctrl_axi_write('h14, { shortint(25), 8'h0a, 8'h00 });
      phase_ctrl_axi_write('h10, 'h13);

      // Channel 1
      phase_ctrl_axi_write('h24, { shortint(25), 8'h0a, 8'h00 }); // step, skip, cnt
      phase_ctrl_axi_write('h20,  'h13);

      // Channel 2
      phase_ctrl_axi_write('h34, { shortint(-50), 8'h00, 8'h20 }); // step, skip, cnt
      phase_ctrl_axi_write('h30,  'h13);

      // Channel 3
      phase_ctrl_axi_write('h44, { shortint(-50), 8'h00, 8'h20 }); // step, skip, cnt
      phase_ctrl_axi_write('h40,  'h13);
      

      // Fire the engine!
      phase_ctrl_axi_write('h0, 1);
      
      repeat(100000) @(posedge clk);
      repeat(100000) @(posedge clk);


      $finish();
   end

   task pwm_gen_axi_write (
                   input logic [32-1:0] adr,
                   input logic [32-1:0] dat
                   );
      int                               b;
      pwm_gen_master.WriteTransaction (
                                   .AWDelay (1),  .aw ('{
                                                         addr: adr,
                                                         prot: 0
                                                         }),
                                   .WDelay (0),   .w ('{
                                                        data: dat,
                                                        strb: '1
                                                        }),
                                   .BDelay (0),   .b (b)
                                   );
   endtask: pwm_gen_axi_write

   task pwm_gen_axi_read (
                  input logic [32-1:0]  adr,
                  output logic [32-1:0] dat
                  );
      logic [32+2-1:0]                  r;
      pwm_gen_master.ReadTransaction (
                                  .ARDelay (0),  .ar ('{
                                                        addr: adr,
                                                        prot: 0
                                                        }),
                                  .RDelay (0),   .r (r)
                                  //     .RDelay (0),   .r ('{
                                  //                          data: dat,
                                  //                          resp: rsp
                                  //                         })
                                  );
      dat = r >> 2;
   endtask: pwm_gen_axi_read

     task phase_ctrl_axi_write (
                                input logic [32-1:0] adr,
                                input logic [32-1:0] dat
                                );
      int                               b;
      phase_ctrl_master.WriteTransaction (
                                          .AWDelay (1),  .aw ('{
                                                                addr: adr,
                                                                prot: 0
                                                                }),
                                          .WDelay (0),   .w ('{
                                                               data: dat,
                                                               strb: '1
                                                               }),
                                          .BDelay (0),   .b (b)
                                          );
   endtask: phase_ctrl_axi_write

     task phase_ctrl_axi_read (
                               input logic [32-1:0]  adr,
                  output logic [32-1:0] dat
                  );
      logic [32+2-1:0]                  r;
      phase_ctrl_master.ReadTransaction (
                                  .ARDelay (0),  .ar ('{
                                                        addr: adr,
                                                        prot: 0
                                                        }),
                                  .RDelay (0),   .r (r)
                                  //     .RDelay (0),   .r ('{
                                  //                          data: dat,
                                  //                          resp: rsp
                                  //                         })
                                  );
      dat = r >> 2;
   endtask: phase_ctrl_axi_read


   ////////////////////////////////////////////////////////////////////////////////
                     // module instances
   ////////////////////////////////////////////////////////////////////////////////


   axi4_lite_if pwm_gen_top_axi (.ACLK (clk), .ARESETn (rstn));
   axi4_lite_if phase_ctrl_top_axi (.ACLK (clk), .ARESETn (rstn));
   
   axi4_lite_master pwm_gen_master (.intf (pwm_gen_top_axi));
   axi4_lite_master phase_ctrl_master (.intf (phase_ctrl_top_axi));

   pwm_ctrl_if #(.PWM_CNT(`PWM_CNT),.PWM_CNT_WIDTH(`PWM_CNT_WIDTH)) pwm_ctrl();

   assign pwm0_pad = pwm_ctrl.pwm_sig[0];
   assign pwm1_pad = pwm_ctrl.pwm_sig[1];

   pwm_gen_top #(.PWM_CNT(`PWM_CNT),.PWM_CNT_WIDTH(`PWM_CNT_WIDTH)) pwm_gen_top_i
     (
      .axi_bus    (pwm_gen_top_axi),

      .pwm_ctrl(pwm_ctrl)
      );

   phase_ctrl_top #(.PWM_CNT(`PWM_CNT),.PWM_CNT_WIDTH(`PWM_CNT_WIDTH)) phase_ctrl_top_i
     (
      .axi_bus(phase_ctrl_top_axi),
      .pwm_ctrl(pwm_ctrl)
      );

   ////////////////////////////////////////////////////////////////////////////////
   // waveforms
   ////////////////////////////////////////////////////////////////////////////////

   initial begin
      $dumpfile("pwm_gen_tb.vcd");
      $dumpvars(0, pwm_gen_tb);
   end

endmodule: pwm_gen_tb
