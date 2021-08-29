module HitDetector(
  input  i_Clk,
  input  i_HReset,
  input  i_HBlank,
  input  i_Ball,
  output o_XDir);

  reg xdir = 0;

  always @(negedge i_Clk) begin
    if (i_Ball) begin
      // Hit the left edge of the screen
      if (xdir == 0 && i_HReset)
        xdir <= 1;

      // Hit the right edge of the screen
      if (xdir == 1 && i_HBlank)
        xdir <= 0;
    end
  end

  assign o_XDir = xdir;

endmodule
