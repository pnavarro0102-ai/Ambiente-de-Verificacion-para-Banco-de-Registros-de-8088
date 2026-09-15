//////////////////////////////////////////////////////////////////////
//
//Modulo_principal_tb.sv
//
//Este modulo sirve como testbench del banco de registros del
//procesador Intel 8088
//
//////////////////////////////////////////////////////////////////////

`include "Modulo_principal.v"

module Modulo_principal_tb;

    bit CLK, RST, WRITE_EN;
    bit  [2:0]  ADDR;
    bit  [1:0]  SEL;
    bit  [15:0] IN;
    wire [15:0] OUT;

    //Instancia del modulo principal
    Reg_8088_16_bits DUT (CLK, RST, WRITE_EN, ADDR, SEL, IN, OUT);

    bit [15:0] registros_esperados [7:0];
    bit [15:0] valor_esperado;

    //TESTER
        //Declaratoria inicial de reloj
        initial begin
            CLK = 0;
            forever 
                #10 CLK = ~CLK; 
        end

        initial begin
            $dumpfile("Wavetb.vcd"); // Nombre del archivo VCD
            $dumpvars(0, Modulo_principal_tb);   // 'testbench' debe ser el nombre del módulo de prueba
        end

        //Escoger registro de manera aleatoria
        function  bit [2:0] reg_random();

            bit [2:0] selec_reg;
            selec_reg = $urandom_range(0, 7); // Valores válidos: 000 (AX) a 111 (DI)
            return selec_reg;

        endfunction : reg_random

        //Genera un dato random
        function bit [15:0] dato_random();

            bit [15:0] dato;
            dato = $urandom;
            return dato;

        endfunction : dato_random

        //Escoge si usar parte alta o baja del reg
        function bit [1:0] sel_random();

            bit [1:0] sel_HL;
            sel_HL = $urandom;
            return sel_HL;

        endfunction : sel_random


        //Cuerpo del tester
        initial begin : tester

            RST = 1;
            @(posedge CLK);
            @(posedge CLK);         //Esperar 1 ciclo
            RST = 0;
            @(posedge CLK);
            @(posedge CLK);

            repeat (1000) begin
            
                RST = 0;
                SEL = sel_random();
                ADDR = reg_random();
                IN = dato_random();
                
                WRITE_EN = 1;

                @(posedge CLK);
                WRITE_EN = 0;
                @(posedge CLK);

            end

            #20 $finish;

        end : tester

    // SCOREBOARD
        always @(negedge WRITE_EN) begin

                // Calcular el valor esperado
                if (ADDR <= 3) begin

                    case (SEL)
                        2'b01: valor_esperado = {8'h00, IN[7:0]};        // LSB escrita, MSB se borra
                        2'b10: valor_esperado = {IN[15:8], 8'h00};       // MSB escrita, LSB se borra
                        2'b00,
                        2'b11: valor_esperado = IN;                      // Escritura completa
                        default: valor_esperado = 16'h0000;              // Default defensivo
                    endcase
                end else begin

                    valor_esperado = IN;

                end
                
                // Actualizar el scoreboard
                registros_esperados[ADDR] = valor_esperado;

                // Verificación (compara OUT del ciclo anterior)
                #1
                if (OUT !== valor_esperado)
                    $error("[SB] Error en Registro %0d: Esperado = %h, Leído = %h", ADDR, valor_esperado, OUT);
                else
                    $display("[SB] Correcto Registro %0d <- %h, OUT = %h, H_L <- %b", ADDR, IN, OUT, SEL);  
        end

endmodule

//////////////////////////////////////////////////////////////////////