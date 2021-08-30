`include "VgaTiming.v"

`define BALL_SIZE 10

module Ball(
  input  i_Clk,
  input  i_HBlank,
  input  i_VBlank,
  input  i_HReset,
  input  i_VReset,
  input  i_XDir,
  output o_Video);

  // Initial position of the ball (top left corner is 1,1)
  parameter p_STARTX = `H_VISIBLE_AREA / 2 - `BALL_SIZE / 2 + 1;
  parameter p_STARTY = `V_VISIBLE_AREA / 2 - `BALL_SIZE / 2 + 1;

  reg [9:0] x = `H_VISIBLE_AREA - (`BALL_SIZE - 1) - (p_STARTX - 1);
  reg [8:0] y = `V_VISIBLE_AREA - (`BALL_SIZE - 1) - (p_STARTY - 1);

  reg ydir = 1;

  // Moving ball horizontally
  always @(posedge i_Clk) begin
    if (~i_HBlank || i_VReset) begin
      if (i_VReset && i_XDir) begin
        if (x == 1)
          x <= `H_VISIBLE_AREA;
        else
          x <= x - 1;
      end else if (x == `H_VISIBLE_AREA)
        x <= 1;
      else
        x <= x + 1;
    end
  end

  // Moving ball vertically
  always @(posedge i_Clk) begin
    if (~i_VBlank && i_HReset || i_VReset) begin
      if (i_VReset && ydir) begin
        if (y == 1)
          y <= `V_VISIBLE_AREA;
        else
          y <= y - 1;
      end else if (y == `V_VISIBLE_AREA)
        y <= 1;
      else
        y <= y + 1;
    end
  end

  // Vertical bouncing
  always @(posedge i_Clk) begin
    if (i_VBlank) begin
      // Bottom edge of the screen
      if (ydir == 1 && y == 1)
        ydir <= 0;

      // Top edge of the screen
      if (ydir == 0 && y == `V_VISIBLE_AREA - `BALL_SIZE + 1)
        ydir <= 1;
    end
  end

  assign o_Video = x <= `H_VISIBLE_AREA && x > `H_VISIBLE_AREA - `BALL_SIZE
                && y <= `V_VISIBLE_AREA && y > `V_VISIBLE_AREA - `BALL_SIZE;

endmodule
