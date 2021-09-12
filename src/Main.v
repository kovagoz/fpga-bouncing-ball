`include "Vga.v"
`include "Ball.v"
`include "HitDetector.v"
`include "Paddle.v"
`include "PaddleControl.v"

module Main(
  input i_Clk,
  input i_Switch_1,
  input i_Switch_2,

  output o_VGA_HSync,
  output o_VGA_VSync,

  output o_VGA_Red_0,
  output o_VGA_Red_1,
  output o_VGA_Red_2,

  output o_VGA_Grn_0,
  output o_VGA_Grn_1,
  output o_VGA_Grn_2,

  output o_VGA_Blu_0,
  output o_VGA_Blu_1,
  output o_VGA_Blu_2);

  wire w_HBlank, w_VBlank;
  wire w_HReset, w_VReset;
  wire w_Video, w_Video_Ball, w_Video_Paddle0;
  wire w_XDir;
  wire w_Ctrl0;

  Vga vga(
    .i_Clk(i_Clk),
    .i_Video(w_Video_Ball | w_Video_Paddle0),
    .o_HSync(o_VGA_HSync),
    .o_VSync(o_VGA_VSync),
    .o_HBlank(w_HBlank),
    .o_VBlank(w_VBlank),
    .o_HReset(w_HReset),
    .o_VReset(w_VReset),
    .o_Video(w_Video)
  );

  Ball ball(
    .i_Clk(i_Clk),
    .i_HBlank(w_HBlank),
    .i_VBlank(w_VBlank),
    .i_HReset(w_HReset),
    .i_VReset(w_VReset),
    .i_XDir(w_XDir),
    .o_Video(w_Video_Ball)
  );

  HitDetector hit(
    .i_Clk(i_Clk),
    .i_HReset(w_HReset),
    .i_HBlank(w_HBlank),
    .i_Ball(w_Video_Ball),
    .i_Paddle0(w_Video_Paddle0),
    .o_XDir(w_XDir)
  );

  Paddle paddle0(
    .i_Clk(i_Clk),
    .i_HReset(w_HReset),
    .i_VReset(w_VReset),
    .i_HBlank(w_HBlank),
    .i_VBlank(w_VBlank),
    .i_Enabled(w_Ctrl0),
    .o_Video(w_Video_Paddle0)
  );

  PaddleControl ctrl0(
    .i_Clk(i_Clk),
    .i_Button_Up(i_Switch_1),
    .i_Button_Down(i_Switch_2),
    .i_VBlank(w_VBlank),
    .i_HReset(w_HReset),
    .i_VReset(w_VReset),
    .o_Enabled(w_Ctrl0)
  );

  assign o_VGA_Red_0 = w_Video;
  assign o_VGA_Red_1 = w_Video;
  assign o_VGA_Red_2 = w_Video;

  assign o_VGA_Grn_0 = w_Video;
  assign o_VGA_Grn_1 = w_Video;
  assign o_VGA_Grn_2 = w_Video;

  assign o_VGA_Blu_0 = w_Video;
  assign o_VGA_Blu_1 = w_Video;
  assign o_VGA_Blu_2 = w_Video;

endmodule
