//////////////////////////////////////////////////////////////////////
//
//Reg_BP.v
//
//Este modulo sirve como registro BP
//
//////////////////////////////////////////////////////////////////////

module Reg_BP (
    input wire CLK,
    input wire RST,
    input wire WRITE_EN,
    input wire [1:0] SEL,    
    input wire [15:0] IN,
    output reg [15:0] OUT
    );

    reg [15:0] BP;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            BP = 16'h0000;
        end
        else if (WRITE_EN) begin
            BP = IN;
        end
    end

    always @(*) begin
        OUT = BP;
    end

endmodule

//////////////////////////////////////////////////////////////////////