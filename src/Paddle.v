`include "VgaTiming.v"

`define PADDLE_WIDTH  10
`define PADDLE_HEIGHT 50

module Paddle(
  input  i_Clk,
  input  i_HReset,
  input  i_HBlank,
  input  i_VBlank,
  output o_Video);

  // Initial position relative to the top left corner
  parameter p_STARTX = 40;
  parameter p_STARTY = 200;

  reg [9:0] x = `H_VISIBLE_AREA - (`PADDLE_WIDTH - 1) - (p_STARTX - 1);
  reg [8:0] y = `V_VISIBLE_AREA - (`PADDLE_HEIGHT - 1) - (p_STARTY - 1);

  always @(posedge i_Clk) begin
    if (~i_HBlank) begin
      if (x == `H_VISIBLE_AREA)
        x <= 1;
      else
        x <= x + 1;
    end
  end

  always @(posedge i_Clk) begin
    if (~i_VBlank && i_HReset) begin
      if (y == `V_VISIBLE_AREA)
        y <= 1;
      else
        y <= y + 1;
    end
  end

  assign o_Video = x > `H_VISIBLE_AREA - `PADDLE_WIDTH
                && y > `V_VISIBLE_AREA - `PADDLE_HEIGHT;

endmodule
