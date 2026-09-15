//////////////////////////////////////////////////////////////////////
//
//Reg_DI.v
//
//Este modulo sirve como registro DI
//
//////////////////////////////////////////////////////////////////////

module Reg_DI (
    input wire CLK,
    input wire RST,
    input wire WRITE_EN,
    input wire [1:0] SEL,     // Solo válido 00
    input wire [15:0] IN,
    output reg [15:0] OUT
    );

    reg [15:0] DI;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            DI = 16'h0000;
        end else if (WRITE_EN) begin
            DI = IN;
        end
    end

    always @(*) begin
        OUT = DI ;
    end
endmodule

//////////////////////////////////////////////////////////////////////