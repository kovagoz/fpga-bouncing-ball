`include "VgaTiming.v"

module HitDetector(
  input  i_Clk,
  input  i_HReset,
  input  i_HBlank,
  input  i_Ball,
  output o_XDir);

  reg       xdir = 0;
  reg [9:0] dx   = 0; // Distance from the left edge of the screen

  always @(posedge i_Clk) begin
    if (i_HReset)
      dx <= 0;
    if (~i_HBlank)
      dx <= dx + 1;
  end

  always @(negedge i_Clk) begin
    if (i_Ball) begin
      // Hit the left edge of the screen
      if (xdir == 0 && dx == 1)
        xdir <= 1;

      // Hit the right edge of the screen
      if (xdir == 1 && dx == `H_VISIBLE_AREA)
        xdir <= 0;
    end
  end

  assign o_XDir = xdir;

endmodule
