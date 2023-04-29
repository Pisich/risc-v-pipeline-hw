module PHASE_IDEX
#(
	parameter N=32
)
(
	input clk,
	input reset,
	input flush,
	input [N-1:0] immediate_data_w,
	input [N-1:0] rd1_w,
	input [N-1:0] rd2_w,
	input [3:0] alu_operation_w,
	input write_w,
	input [4:0] write_register_w,

	output reg [N-1:0] immediate_data_w_o,
	output reg [N-1:0] rd_1_w_o,
	output reg [N-1:0] rd_2_w_o,
	output reg [3:0] alu_operation_w_o,
	output reg write_w_o,
	output reg [4:0] write_register_w_o
);

always @(negedge reset or posedge clk)
	begin
		if (reset == 0 or flush == 0)
			begin
				immediate_data_w_o <= 0;
				rd_1_w_o <= 0;
				rd_2_w_o <= 0;
				alu_operation_w_o <= 0;
				write_w_o <= 0;
				write_register_w_o <= 0;
			end
		else
			begin
				immediate_data_w_o <= immediate_data_w;
				rd1_w_o <= rd1_w;
				rd2_w_o <= rd2_w;
				alu_operation_w_o <= alu_operation_w;
				write_w_o <= write_w;
				write_register_w_o <= write_register_w;
			end
	end

endmodule