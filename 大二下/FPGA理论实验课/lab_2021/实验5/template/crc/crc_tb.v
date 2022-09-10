`timescale  1ns / 1ps
`include "crc.v"

module crc_tb();
// crc Parameters
parameter PERIOD = 4;
parameter BITWIDTH = 8;

// parameter LFSR_WIDTH = 32;
// parameter LFSR_POLY = 32'h04C11DB7;
// parameter LFSR_INIT = {LFSR_WIDTH{1'b1}};

parameter LFSR_WIDTH = 8;
parameter LFSR_POLY = 8'h07;
parameter LFSR_INIT = {LFSR_WIDTH{1'b0}};

// parameter REVERSE = 1;
// parameter INVERT = 1;

parameter REVERSE = 0;
parameter INVERT = 0;

// crc Inputs
reg clk = 0;
reg rst_n = 0;
reg valid = 0;
reg [BITWIDTH - 1: 0] data_i = 0;

// crc Outputs
wire [LFSR_WIDTH - 1: 0] crc_o;

initial begin
    forever
        #(PERIOD / 2) clk = ~clk;
end

// wire [31: 0] res;
// assign res = crc_o ^ 32'h0000_0000;

integer stage = 0;
always @(posedge clk) begin
    case (stage)
        0: begin
            rst_n = 1'b0;
            stage = 1;
        end
        1: begin
            rst_n = 1'b1;
            data_i = 8'h22;
            valid = 1'b1;
            stage = 2;
        end
        2: begin
            valid = 1'b0;
            data_i = 8'h00;
            stage = 3; //delay 1 clk
        end
        3: begin
            // valid = 1'b0;
            $display("%h", crc_o);
            stage = 4;
        end
        4: begin
            stage = 5;
        end
        5: begin
            // if(crc_o == 32'hD56F2B94) begin
            //     data_i = 8'h00;
            //     valid = 1'b0;
            //     $display(1);
            // end
            // stage = 5;
            $stop();
            $finish();
        end
        default: begin
            stage = 0;
        end
    endcase
end

lfsr_crc #(
             .BITWIDTH ( BITWIDTH ),
             .LFSR_WIDTH ( LFSR_WIDTH ),
             .LFSR_POLY ( LFSR_POLY ),
             .LFSR_INIT ( {LFSR_WIDTH{1'b1}} ),
             .REVERSE ( REVERSE ),
             .INVERT ( INVERT ))
         u_lfsr_crc(
             //ports
             .clk ( clk ),
             .rst_n ( rst_n ),
             .data_i ( data_i ),
             .valid ( valid ),
             .crc_o ( crc_o )
         );


initial begin
    $dumpfile("tb.vcd");
    $dumpvars();
    // #1000;
    // $finish();
end

endmodule
