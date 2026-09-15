//////////////////////////////////////////////////////////////////////
//
//Modulo_principal.v
//
//Este modulo sirve como modulo principal del 8088
//
//////////////////////////////////////////////////////////////////////

`include "Reg_AX.v"
`include "Reg_BX.v"
`include "Reg_CX.v"
`include "Reg_DX.v"
`include "Reg_SP.v"
`include "Reg_BP.v"
`include "Reg_SI.v"
`include "Reg_DI.v"

module Reg_8088_16_bits (
    input wire CLK,
    input wire RST,
    input wire WRITE_EN,
    input wire [2:0] ADDR,   // Dirección del registro: 000=AX, 001=BX, etc.
    input wire [1:0] SEL,    // Para registros parciales: 00=16 bits, 01=LSB, 10=MSB
    input wire [15:0] IN,
    output wire [15:0] OUT
    );

    // Salidas internas de cada registro
    wire [15:0] AX_OUT, BX_OUT, CX_OUT, DX_OUT;
    wire [15:0] SP_OUT, BP_OUT, SI_OUT, DI_OUT;

    // Instancias de los registros
    Reg_AX u_AX (.CLK(CLK), .RST(RST), .WRITE_EN(WRITE_EN && 
                ADDR == 3'b000), .SEL(SEL), .IN(IN), .OUT(AX_OUT));

    Reg_BX u_BX (.CLK(CLK), .RST(RST), .WRITE_EN(WRITE_EN && 
                ADDR == 3'b001), .SEL(SEL), .IN(IN), .OUT(BX_OUT));

    Reg_CX u_CX (.CLK(CLK), .RST(RST), .WRITE_EN(WRITE_EN && 
                ADDR == 3'b010), .SEL(SEL), .IN(IN), .OUT(CX_OUT));

    Reg_DX u_DX (.CLK(CLK), .RST(RST), .WRITE_EN(WRITE_EN && 
                ADDR == 3'b011), .SEL(SEL), .IN(IN), .OUT(DX_OUT));

    Reg_SP u_SP (.CLK(CLK), .RST(RST), .WRITE_EN(WRITE_EN && 
                ADDR == 3'b100), .IN(IN), .OUT(SP_OUT));

    Reg_BP u_BP (.CLK(CLK), .RST(RST), .WRITE_EN(WRITE_EN && 
                ADDR == 3'b101), .IN(IN), .OUT(BP_OUT));

    Reg_SI u_SI (.CLK(CLK), .RST(RST), .WRITE_EN(WRITE_EN && 
                ADDR == 3'b110), .IN(IN), .OUT(SI_OUT));

    Reg_DI u_DI (.CLK(CLK), .RST(RST), .WRITE_EN(WRITE_EN && 
                ADDR == 3'b111), .IN(IN), .OUT(DI_OUT));

    // Multiplexor de salida
    assign OUT = (ADDR == 3'b000) ? AX_OUT : //0
                 (ADDR == 3'b001) ? BX_OUT : //1
                 (ADDR == 3'b010) ? CX_OUT : //2
                 (ADDR == 3'b011) ? DX_OUT : //3
                 (ADDR == 3'b100) ? SP_OUT : //4
                 (ADDR == 3'b101) ? BP_OUT : //5
                 (ADDR == 3'b110) ? SI_OUT : //6
                 (ADDR == 3'b111) ? DI_OUT : //7
                 16'h0000;

endmodule

//////////////////////////////////////////////////////////////////////
