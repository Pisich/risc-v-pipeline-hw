module PHASE_MEMWB
#(
	parameter N=32
)
(
	input clk,
	input reset,
	input flush,
   input [N-1:0] rd_w,
   input [N-1:0] mux_mem_to_reg_w,

   output reg [N-1:0] rd_w_o,
   output reg [N-1:0] mux_mem_to_reg_w_o
);

always @(negedge reset or posedge clk)
    begin
		if (reset == 0 or flush == 0)
			begin
                rd_w_o <= 0;
                mux_output_mem_to_reg_w_o <= 0;
			end
		else
			begin
                rd_w_o <= rd_w;
                mux_mem_to_reg_w_o <= mux_mem_to_reg_w;
			end
	end

endmodule