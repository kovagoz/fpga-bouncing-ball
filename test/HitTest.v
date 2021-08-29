`include "TestBench.v"
`include "Vga.v"
`include "HitDetector.v"
`include "Ball.v"

module HitTest();

  `INIT_TEST

  integer i;

  reg clk = 1'b0;

  wire w_HBlank;
  wire w_VBlank;
  wire w_HReset;
  wire w_VReset;
  wire w_Video;
  wire w_XDir;

  Vga #(1, 1) vga(
    .i_Clk(clk),
    .o_HBlank(w_HBlank),
    .o_VBlank(w_VBlank),
    .o_HReset(w_HReset),
    .o_VReset(w_VReset)
  );

  Ball #(1, 1) ball(
    .i_Clk(clk),
    .i_HBlank(w_HBlank),
    .i_VBlank(w_VBlank),
    .i_HReset(w_HReset),
    .i_VReset(w_VReset),
    .i_XDir(w_XDir),
    .o_Video(w_Video)
  );

  HitDetector hit(
    .i_Clk(clk),
    .i_HReset(w_HReset),
    .i_HBlank(w_HBlank),
    .i_Ball(w_Video),
    .o_XDir(w_XDir)
  );

  initial begin
    for (i = 0; i < 2000; i = i + 1) begin
      #20 clk = ~clk;
    end
  end

endmodule
