module Mul_32_Bits
(
  input [31:0] Data0,
  input [31:0] Data1,

  output reg [31:0] Result
);

  always @ (Data0 or Data1)
  begin
    Result = Data0 * Data1;
  end

endmodule