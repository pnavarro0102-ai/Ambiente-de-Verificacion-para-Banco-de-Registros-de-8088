//////////////////////////////////////////////////////////////////////
//
//Reg_BX.v
//
//Este modulo sirve como registro BX
//
//////////////////////////////////////////////////////////////////////

module Reg_BX (
    input wire CLK,
    input wire RST,
    input wire WRITE_EN,
    input wire [1:0] SEL,     // 00: BX completo, 01: LSB, 10: MSB
    input wire [15:0] IN, 
    output reg [15:0] OUT
    );

    reg [15:0] BX;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            BX = 16'b0;
        end else if (WRITE_EN) begin
            case (SEL)
                2'b00,
                2'b11: BX = IN;                        // BX completo
                2'b01: BX[7:0] = IN[7:0];              // LSB
                2'b10: BX[15:8] = IN[15:8];            // MSB
            endcase
        end
    end

    always @(*) begin
        case (SEL)
            2'b00,
            2'b11: OUT = BX;               // BX completo
            2'b01: OUT = {8'b0, BX[7:0]};  // BX (completo también válido)
            2'b10: OUT = {BX[15:8], 8'b0}; // igual que arriba
            default: OUT = 16'b0;
        endcase
    end
endmodule

//////////////////////////////////////////////////////////////////////