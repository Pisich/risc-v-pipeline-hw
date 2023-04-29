/******************************************************************
* Description
*	This is control unit for the RISC-V Microprocessor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction bus.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
module Control
(
	input [6:0]OP_i,
	
	output JALR_o,
	output Branch_o,
	output Mem_Read_o,
	output Mem_to_Reg_o,
	output Mem_Write_o,
	output ALU_Src_o,
	output Reg_Write_o,
	output [2:0]ALU_Op_o
);


reg [9:0] control_values;

localparam R_Type				= 7'h33;
localparam I_Type_Logic		= 7'h13;
localparam I_Type_LW			= 7'h03;
localparam I_Type_Jalr		= 7'h67;
localparam S_Type				= 7'h23;
localparam B_Type				= 7'h63;
localparam J_Type				= 7'h6F;
localparam U_Type				= 7'h37;


always@(OP_i) begin
	case(OP_i)//                          876_54_3_210
	
		R_Type:			control_values = 10'b0_001_00_0_000;
		I_Type_Logic:	control_values = 10'b0_001_00_1_001;
		I_Type_LW:		control_values = 10'b0_011_10_0_010;
		I_Type_Jalr:	control_values = 10'b1_001_00_1_011;
		S_Type:			control_values = 10'b0_000_01_1_100;
		B_Type:			control_values = 10'b0_100_00_0_101;
		J_Type:			control_values = 10'b0_101_00_1_110;
		U_Type:			control_values = 10'b0_001_00_1_111;
	


		default:
			control_values= 10'b0_000_00_000;
		endcase
end	
assign JALR_o = control_values[9];

assign Branch_o = control_values[8];

assign Mem_to_Reg_o = control_values[7];

assign Reg_Write_o = control_values[6];

assign Mem_Read_o = control_values[5];

assign Mem_Write_o = control_values[4];

assign ALU_Src_o = control_values[3];

assign ALU_Op_o = control_values[2:0];	

endmodule


