`ifndef PADDLE_V
`define PADDLE_V

`include "VgaTiming.v"

`define PADDLE_WIDTH  10
`define PADDLE_HEIGHT 50

module Paddle(
  input  i_Clk,
  input  i_HReset,
  input  i_VReset,
  input  i_HBlank,
  input  i_VBlank,
  input  i_Enabled,
  output o_Video);

  // Position relative to the left edge of the screen
  parameter p_XPOS = 40;

  reg [9:0] x = `H_VISIBLE_AREA - (`PADDLE_WIDTH - 1) - (p_XPOS - 1);

  // Paddle is drawn on the screen as long as this counter is running.
  reg [5:0] y = 0;

  // Generate signal for the horizontal extent
  always @(posedge i_Clk) begin
    if (~i_HBlank) begin
      if (x == `H_VISIBLE_AREA)
        x <= 1;
      else
        x <= x + 1;
    end
  end

  // Increment the counter only if the enabled signal (received from the
  // paddle control modul) is high.
  always @(posedge i_Clk) begin
    if (i_Enabled && ~i_VBlank && i_HReset && y < `PADDLE_HEIGHT) begin
      y <= y + 1;
    end

    if (i_VReset)
      y <= 0;
  end

  assign o_Video = i_Enabled
                && x > `H_VISIBLE_AREA - `PADDLE_WIDTH
                && y < `PADDLE_HEIGHT;

endmodule

`endif
