`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2023 04:36:45 PM
// Design Name: 
// Module Name: ID_entity
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ID_entity(
    input clk,
    input RegWrite,
    input RegDst,
    input ExtOp,
    input [15:0] Instr,
    input [15:0] WD,
    output [15:0] RD1,
    output [15:0] RD2,
    output [15:0] Ext_Imm,
    output [2:0] func,
    output sa
    );
endmodule
