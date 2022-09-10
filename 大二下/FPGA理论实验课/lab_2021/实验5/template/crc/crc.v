`timescale 1ns / 1ps
`include "lfsr.v"

//crc32
module lfsr_crc #
       (
           parameter BITWIDTH = 8,
           parameter LFSR_WIDTH = 32,
           parameter LFSR_POLY = 32'h04c11db7,
           parameter LFSR_INIT = {LFSR_WIDTH{1'b1}},
           parameter REVERSE = 1,
           parameter INVERT = 1
       )
       (
           input wire clk,
           input wire rst_n,
           input wire [BITWIDTH - 1: 0] data_i,
           input wire valid,
           output wire [LFSR_WIDTH - 1: 0] crc_o
       );
reg [LFSR_WIDTH - 1: 0] state_reg = LFSR_INIT;
reg [LFSR_WIDTH - 1: 0] output_reg = 0;

wire [LFSR_WIDTH - 1: 0] lfsr_state;

assign crc_o = output_reg;

lfsr #(
         .BITWIDTH ( BITWIDTH ),
         .LFSR_WIDTH ( LFSR_WIDTH ),
         .LFSR_POLY ( LFSR_POLY ),
         .LFSR_REVERSE ( REVERSE ))
     u_lfsr(
         //ports
         .data_i ( data_i ),
         .state_i ( state_reg ),
         .data_o ( ),
         .state_o ( lfsr_state )
     );

always @(posedge clk) begin
    if (!rst_n) begin
        state_reg <= LFSR_INIT;
        output_reg <= 0;
    end
    else begin
        if (valid) begin
            state_reg <= lfsr_state;
            if (INVERT) begin
                output_reg <= ~lfsr_state;
            end
            else begin
                output_reg <= lfsr_state;
            end
        end
        else begin
            state_reg <= LFSR_INIT;
        end
    end
end

endmodule
