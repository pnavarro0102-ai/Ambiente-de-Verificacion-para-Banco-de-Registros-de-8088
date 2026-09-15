//////////////////////////////////////////////////////////////////////
//
//Reg_SP.v
//
//Este modulo sirve como registro SP
//
//////////////////////////////////////////////////////////////////////

module Reg_SP (
    input wire CLK,
    input wire RST,
    input wire WRITE_EN,
    input wire [15:0] IN,
    output reg [15:0] OUT
    );

    reg [15:0] SP;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            SP = 16'h0000;  
        end else if (WRITE_EN) begin
            SP = IN;
        end
    end

    always @(*) begin
        OUT = SP;
    end

endmodule

//////////////////////////////////////////////////////////////////////