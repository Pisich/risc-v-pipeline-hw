module PHASE_IFID
(
	input clk,
	input reset,
	input flush,
	input [31:0] instruction_w,
	input [31:0] sig_pc_w,

	output reg [31:0] instruction_w_o,
	output reg [31:0] sig_pc_w_o
);


always @(negedge reset or posedge clk)
	begin
		if (reset == 0 or flush == 0)
			begin
				instruction_w_o <= 0;
				sig_pc_w_o <= 0;
			end
		else
			begin
				instruction_w_o <= instruction_w;
				sig_pc_w_o <= sig_pc_w;
			end
	end

endmodule