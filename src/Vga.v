`include "VgaTiming.v"

`define IS_VISIBLE(x, y) x <= `H_VISIBLE_AREA && y <= `V_VISIBLE_AREA

module Vga(
  input  i_Clk,
  input  i_Video,

  output o_HSync,
  output o_VSync,

  output o_HBlank,
  output o_VBlank,

  output o_HReset,
  output o_VReset,

  output o_Video);

  // Initial position of the H/V counters (useful for testing)
  parameter p_HPOS = 1;
  parameter p_VPOS = 1;

  reg [9:0] x  = p_HPOS;
  reg [9:0] y  = p_VPOS;
  reg       rx = 0;
  reg       ry = 0;
  reg       bx = 0;
  reg       by = 0;

  // Horizontal counter
  always @(posedge i_Clk) begin
    if (x == `H_MAX)
      x <= 1;
    else
      x <= x + 1;
  end

  // Horizontal reset and blank signal
  always @(negedge i_Clk) begin
    rx <= x == `H_MAX - 1;
    bx <= x >= `H_VISIBLE_AREA && x < `H_MAX;
  end

  // Vertical counter
  always @(posedge i_Clk) begin
    if (o_HReset) begin
      if (y == `V_MAX)
        y <= 1;
      else
        y <= y + 1;
    end
  end

  // Vertical reset and blank signal
  always @(negedge i_Clk) begin
    ry <= y == `V_MAX && x == `H_MAX - 1;
    by <= y > `V_VISIBLE_AREA && y <= `V_MAX;
  end

  assign o_HSync = (x < `H_PULSE_HEAD) || (x > `H_PULSE_TAIL);
  assign o_VSync = (y < `V_PULSE_HEAD) || (y > `V_PULSE_TAIL);

  assign o_HBlank = bx;
  assign o_VBlank = by;

  assign o_HReset = rx;
  assign o_VReset = ry;

  // Enable video signal only in the visible area of the screen
  assign o_Video = (`IS_VISIBLE(x, y) && i_Video);

endmodule
