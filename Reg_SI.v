//////////////////////////////////////////////////////////////////////
//
//Reg_SI.v
//
//Este modulo sirve como registro SI
//
//////////////////////////////////////////////////////////////////////

module Reg_SI (
    input wire CLK,
    input wire RST,
    input wire WRITE_EN,
    input wire [1:0] SEL,     // Solo válido 00
    input wire [15:0] IN,
    output reg [15:0] OUT
    );

    reg [15:0] SI;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            SI = 16'h0000;
        end else if (WRITE_EN) begin
            SI = IN;
        end
    end

    always @(*) begin
        OUT =  SI;
    end
endmodule

//////////////////////////////////////////////////////////////////////