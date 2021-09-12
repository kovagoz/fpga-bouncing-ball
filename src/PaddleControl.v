`include "Paddle.v"
`include "VgaTiming.v"

`define PADDLE_SPEED 5 // Pixels per frame

// Mimic the signal produced by the original analogue controller,
// so it will be easier to replace this code with the final one.
module PaddleControl(
  input  i_Clk,
  input  i_Button_Up,
  input  i_Button_Down,
  input  i_VBlank,
  input  i_HReset,
  input  i_VReset,
  output o_Enabled);

  reg [8:0] c   = 1;
  reg       out = 1;

  always @(posedge i_Clk) begin
    // Counter steps one at the end of each visible line
    if (~i_VBlank && i_HReset) begin
      if (c == `V_VISIBLE_AREA)
        c <= 1;
      else
        c <= c + 1;
    end

    // Move paddle at the end of the frame
    if (i_VReset) begin
      out <= (c == 1);

      // Move up
      if (i_Button_Up) begin
        if (c > `V_VISIBLE_AREA - `PADDLE_SPEED || c == 1)
          c <= 1;
        else
          c <= c + `PADDLE_SPEED;
      end

      // Move down
      if (i_Button_Down) begin
        if (c > `PADDLE_HEIGHT + `PADDLE_SPEED + 1)
          c <= c - `PADDLE_SPEED;
        // Paddle is exactly at the bottom edge of the screen,
        // counter turns from 480 to 1.
        else if (c == 1)
          c <= `V_VISIBLE_AREA - `PADDLE_SPEED + 1;
        else
          c <= `PADDLE_HEIGHT + 1;
      end
    end

    if (c == 1)
      out <= 1;
  end

  assign o_Enabled = out;

endmodule
