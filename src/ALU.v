/******************************************************************
* Description
*	This is an 32-bit arithetic logic unit that can execute the next set of operations:
*		add

* This ALU is written by using behavioral description.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module ALU 
(
	input [3:0] ALU_Operation_i,
	input signed [31:0] A_i,
	input signed [31:0] B_i,
	input [31:0] PC_4, 
	
	output reg Zero_o,
	output reg jalout,
	output reg [31:0] ALU_Result_o
);

		localparam ADD 		= 4'b00_00;
		localparam SUB 		= 4'b00_01;
		localparam XOR 		= 4'b00_10;
		localparam OR 			= 4'b00_11;
		localparam AND 		= 4'b01_00;
		localparam SLL 		= 4'b01_01;
		localparam SRL 		= 4'b01_10;
		
		localparam JALR 		= 4'b01_11;
		
		localparam BEQ			= 4'b10_00;
		localparam BNE			= 4'b10_01;
		localparam BLT			= 4'b10_10;
		localparam BGE			= 4'b10_11;
		
		localparam JAL			= 4'b11_00;
		
		localparam LUI			= 4'b11_01;
		//MUL
		localparam MUL 		= 4'b11_10;
   
   always @ (A_i or B_i or ALU_Operation_i)
     begin
		case (ALU_Operation_i)
		ADD: // ADD, ADDI, LW, SW, JALR
			ALU_Result_o = A_i + B_i;
		SUB: // SUB
			ALU_Result_o = A_i - B_i;
		XOR: //XOR, XORI
			ALU_Result_o = A_i ^ B_i;
		OR: // OR, ORI
			ALU_Result_o = A_i | B_i;
		AND: // AND, ANDI
			ALU_Result_o = A_i & B_i;
		SLL: // SLL, SLLI
			ALU_Result_o = A_i << (B_i & 5'b1_1111);
		SRL: // SRL, SRLI 
			ALU_Result_o = A_i >> (B_i & 5'b1_1111);
		LUI: // LUI
			ALU_Result_o = B_i << 12;

		BEQ: // BEQ
			if (A_i == B_i) ALU_Result_o = 1'b1;
			else ALU_Result_o = 1'b0;
		BNE: // BNE
			if (A_i != B_i) ALU_Result_o = 1'b1;
			else ALU_Result_o = 1'b0;
		BLT: // BLT
			if (A_i < B_i) ALU_Result_o = 1'b1;
			else ALU_Result_o = 1'b0;
		BGE: // BGE
			if (A_i >= B_i) ALU_Result_o = 1'b1;
			else ALU_Result_o = 1'b0;
	
		JAL: //JAL
			ALU_Result_o = PC_4;
			
		MUL: //MUL
			ALU_Result_o = A_i * B_i;
	
		default:
			ALU_Result_o = 0;
		endcase // case(control)
		
		Zero_o = (ALU_Result_o == 0) ? 1'b1 : 1'b0;
		jalout = (ALU_Result_o == 1 || ALU_Operation_i == 4'b11_00) ? 1'b1 : 1'b0;
		
     end // always @ (A or B or control)
endmodule // ALU