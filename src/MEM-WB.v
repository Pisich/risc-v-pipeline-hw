module PHASE_MEMWB
#(
	parameter N=32
)
(
	input clk,
	input reset,
	input flush,
   input [N-1:0] rd_w,

   output reg [N-1:0] rd_w_o
);

always @(negedge reset or negedge flush or posedge clk)
    begin
		if (reset == 0 || flush == 0)
			begin
                rd_w_o <= 0;
			end
		else
			begin
                rd_w_o <= rd_w;
			end
	end

endmodule