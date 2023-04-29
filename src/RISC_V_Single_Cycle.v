/******************************************************************
* Description
*	This is the top-level of a RISC-V Microprocessor that can execute the next set of instructions:
*		add
*		addi
* This processor is written Verilog-HDL. It is synthesizabled into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be executed. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module RISC_V_Single_Cycle
#(
	parameter PROGRAM_MEMORY_DEPTH = 64,
	parameter DATA_MEMORY_DEPTH = 256,
	parameter DATA_MEMORY_WIDTH = 32
)

(
	// Inputs
	input clk,
	input reset,
	
	output [31:0] data_out

);
//******************************************************************/
//******************************************************************/

//******************************************************************/
//******************************************************************/
/* Signals to connect modules*/

/**Control**/
wire jalr_o_w;
wire branch_o_w;
wire mem_read_w;
wire mem_to_reg_w;
wire mem_write_w;
wire alu_src_w;
wire reg_write_w;
wire [2:0] alu_op_w;

/** Program Counter**/
wire [31:0] pc_plus_4_w;
wire [31:0] pc_w;
wire [31:0] pc_plus_imm_w;
wire [31:0] pc_next_w;
wire [31:0] pc_next_final_w;


/**Register File**/
wire [31:0] read_data_1_w;
wire [31:0] read_data_2_w;
wire [31:0] write_data_i_w;

/**Inmmediate Unit**/
wire [31:0] inmmediate_data_w;

/**ALU**/
wire jalout_o_w;
wire zero_o_w;
wire [31:0] alu_result_w;
wire [31:0] alu_result_final_w;

/**Multiplexer MUX_DATA_OR_IMM_FOR_ALU**/
wire [31:0] read_data_2_or_imm_w;

/**ALU Control**/
wire [3:0] alu_operation_w;

/**Instruction Bus**/	
wire [31:0] instruction_bus_w;

/**Data memory**/	
wire [31:0] read_Data_o_w;

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
CONTROL_UNIT
(
	/****/
	.OP_i(instruction_bus_w[6:0]),
	/** outputus**/
	.JALR_o(jalr_o_w),
	.Branch_o(branch_o_w),
	.ALU_Op_o(alu_op_w),
	.ALU_Src_o(alu_src_w),
	.Reg_Write_o(reg_write_w),
	.Mem_to_Reg_o(mem_to_reg_w),
	.Mem_Read_o(mem_read_w),
	.Mem_Write_o(mem_write_w)
);

PC_Register
PROGRAM_COUNTER
(
	.clk(clk),
	.reset(reset),
	.Next_PC(pc_next_final_w),
	.PC_Value(pc_w)
);


Program_Memory
#(
	.MEMORY_DEPTH(PROGRAM_MEMORY_DEPTH)
)
PROGRAM_MEMORY
(
	.Address_i(pc_w),
	.Instruction_o(instruction_bus_w)
);


Adder_32_Bits
PC_PLUS_4
(
	.Data0(pc_w),
	.Data1(4),
	
	.Result(pc_plus_4_w)
);


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/



Register_File
REGISTER_FILE_UNIT
(
	.clk(clk),
	.reset(reset),
	.Reg_Write_i(reg_write_w),
	.Write_Register_i(instruction_bus_w[11:7]),
	.Read_Register_1_i(instruction_bus_w[19:15]),
	.Read_Register_2_i(instruction_bus_w[24:20]),
	.Write_Data_i(write_data_i_w),
	.Read_Data_1_o(read_data_1_w),
	.Read_Data_2_o(read_data_2_w)

);

Immediate_Unit
IMM_UNIT
(  .op_i(instruction_bus_w[6:0]),
   .Instruction_bus_i(instruction_bus_w),
   .Immediate_o(inmmediate_data_w)
);

Adder_32_Bits
PC_IMM
(
.Data0(pc_w),
.Data1(inmmediate_data_w),

.Result(pc_plus_imm_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_DATA_OR_IMM_FOR_ALU
(
	.Selector_i(alu_src_w),
	.Mux_Data_0_i(read_data_2_w),
	.Mux_Data_1_i(inmmediate_data_w),
	
	.Mux_Output_o(read_data_2_or_imm_w)

);



ALU_Control
ALU_CONTROL_UNIT
(
	.funct7_i(instruction_bus_w[30]),
	.ALU_Op_i(alu_op_w),
	.funct3_i(instruction_bus_w[14:12]),
	.ALU_Operation_o(alu_operation_w),
	.funct7_1(instruction_bus_w[25])

);


ALU
ALU_UNIT
(
	.ALU_Operation_i(alu_operation_w),
	.A_i(read_data_1_w),
	.B_i(read_data_2_or_imm_w),
	.ALU_Result_o(alu_result_w),
	.PC_4(pc_plus_4_w),
	
	.jalout(jalout_o_w),
	.Zero_o(zero_o_w)
);

wire PCsrc_w = branch_o_w & jalout_o_w;

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_PC_PLUS_4_PC_IMM
(
	.Selector_i(PCsrc_w),
	.Mux_Data_0_i(pc_plus_4_w),
	.Mux_Data_1_i(pc_plus_imm_w),
	
	.Mux_Output_o(pc_next_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_PC_OR_JALR
(
	.Selector_i(jalr_o_w),
	.Mux_Data_0_i(pc_next_w),
	.Mux_Data_1_i(alu_result_w),
	
	.Mux_Output_o(pc_next_final_w)

);

Data_Memory 
#(	
	.DATA_WIDTH(DATA_MEMORY_WIDTH),
	.MEMORY_DEPTH(DATA_MEMORY_DEPTH)

)
DATA_MEMORY_W
(
	.clk(clk),
	.Mem_Write_i(mem_write_w),
	.Mem_Read_i(mem_read_w),
	.Write_Data_i(read_data_2_w),
	.Address_i(alu_result_w),

	.Read_Data_o(read_Data_o_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_ALU_RESULT_OR_JALR
(
	.Selector_i(jalr_o_w),
	.Mux_Data_0_i(alu_result_w),
	.Mux_Data_1_i(pc_plus_4_w),
	
	.Mux_Output_o(alu_result_final_w)

);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_ALU_RESULT_OR_READ_DATA
(
	.Selector_i(mem_to_reg_w),
	.Mux_Data_0_i(alu_result_final_w),
	.Mux_Data_1_i(read_Data_o_w),
	
	.Mux_Output_o(write_data_i_w)

);

assign data_out = alu_result_w;



endmodule

