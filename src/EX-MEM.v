module PHASE_EXMEM
#(
	parameter N=32
)
(
	input clk,
	input reset,
	input flush,
	input [N-1:0] alu_result_w,
	input write_w,
	input [4:0] write_register_w,

	output reg [N-1:0] alu_result_w_o,
	output reg write_o,
	output reg [4:0] write_register_w_o

);

always @(negedge reset or posedge clk)
	begin
		if (reset == 0 or flush == 0)
			begin
				alu_result_w_o <= 0;
				write_o <= 0;
				write_register_w_o <= 0;
			end
		else
			begin
				alu_result_w_o <= alu_result_w;
				write_o <= write_w;
				write_register_w_o <= write_register_w;
			end
	end

endmodule