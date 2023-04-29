/******************************************************************
* Description
*	This is the control unit for the ALU. It receves a signal called 
*	ALUOp from the control unit and signals called funct7 and funct3  from
*	the instruction bus.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
module ALU_Control
(
	input funct7_i,
	input funct7_1,
	input [2:0] ALU_Op_i,
	input [2:0] funct3_i,
	

	output [3:0] ALU_Operation_o

);

//R TYPE
localparam R_Type_ADD			= 8'b00_000_000;
localparam R_Type_SUB			= 8'b01_000_000;
localparam R_Type_XOR			= 8'b00_000_100;
localparam R_Type_OR				= 8'b00_000_110;
localparam R_Type_AND			= 8'b00_000_111;
localparam R_Type_SLL			= 8'b00_000_001;
localparam R_Type_SRL			= 8'b00_000_101;
localparam R_Type_MUL			= 8'b10_000_000;

//I TYPE
localparam I_Type_ADDI			= 8'bxx_001_000;
localparam I_Type_XORI			= 8'bxx_001_100;
localparam I_Type_ORI			= 8'bxx_001_110;
localparam I_Type_ANDI			= 8'bxx_001_111;
localparam I_Type_SLLI			= 8'b00_001_001;
localparam I_Type_SRLI			= 8'b00_001_101;

localparam I_Type_LW				= 8'bxx_010_010;
localparam I_Type_JALR			= 8'bxx_011_000;

//S TYPE
localparam S_Type_SW				= 8'bxx_100_010;

//B TYPE
localparam B_Type_BEQ			= 8'bxx_101_000;
localparam B_Type_BNE			= 8'bxx_101_001;
localparam B_Type_BLT			= 8'bxx_101_100;
localparam B_Type_BGE			= 8'bxx_101_101;

//J TYPE
localparam J_Type_JAL			= 8'bxx_110_xxx;

//U TYPE
localparam U_Type_LUI			= 8'bxx_111_xxx;

reg [3:0] alu_control_values;
wire [7:0] selector;

assign selector = {funct7_1, funct7_i, ALU_Op_i, funct3_i};

always@(selector)begin
	casex(selector)
		
		R_Type_ADD: 		alu_control_values = 4'b00_00;
		R_Type_SUB:			alu_control_values = 4'b00_01;
		R_Type_XOR:			alu_control_values = 4'b00_10;
		R_Type_OR:			alu_control_values = 4'b00_11;
		R_Type_AND:			alu_control_values = 4'b01_00;
		R_Type_SLL:			alu_control_values = 4'b01_01;
		R_Type_SRL:			alu_control_values = 4'b01_10;
		//MUL EXTRA
		R_Type_MUL: 		alu_control_values = 4'b11_10;
		
		I_Type_ADDI:		alu_control_values = 4'b00_00;
		I_Type_XORI:		alu_control_values = 4'b00_10;
		I_Type_ORI:			alu_control_values = 4'b00_11;
		I_Type_ANDI:		alu_control_values = 4'b01_00;
		I_Type_SLLI:		alu_control_values = 4'b01_01;
		I_Type_SRLI:		alu_control_values = 4'b01_10;
		I_Type_LW:			alu_control_values = 4'b00_00;
		I_Type_JALR:		alu_control_values = 4'b00_00;
		
		S_Type_SW:			alu_control_values = 4'b00_00;
		
		B_Type_BEQ:			alu_control_values = 4'b10_00;
		B_Type_BNE:			alu_control_values = 4'b10_01;
		B_Type_BLT:			alu_control_values = 4'b10_10;
		B_Type_BGE:			alu_control_values = 4'b10_11;
		
		J_Type_JAL:			alu_control_values = 4'b11_00;
		
		U_Type_LUI:			alu_control_values = 4'b11_01;

		default: alu_control_values = 4'b00_00;
	endcase
end


assign ALU_Operation_o = alu_control_values;



endmodule
