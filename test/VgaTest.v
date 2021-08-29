`include "TestBench.v"
`include "Vga.v"

module VgaTest();

  `INIT_TEST

  integer i;

  reg clk = 1'b0;

  wire w_HBlank;
  wire w_HReset;

  Vga uut(
    .i_Clk(clk),
    .o_HBlank(w_HBlank),
    .o_HReset(w_HReset)
  );

  initial begin
    for (i = 0; i < 2000; i = i + 1) begin
      #20 clk = ~clk;
    end
  end

endmodule
