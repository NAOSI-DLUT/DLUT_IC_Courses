`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/06/23 00:10:22
// Design Name:
// Module Name: key
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


module key #(
           parameter DELAY_TIME = 20'd1_000_000
       )
       (
           input wire sys_clk_i,
           input wire sys_rst_n_i,

           input wire key_button_i,

           output reg key_value_o, //key value after debounce
           output reg is_change_o, //pulse: key status changed trigger by IS_POS_TRIG's setting
           output wire key_posedge_sig_o,
           output wire key_negedge_sig_o
       );
reg [19: 0] cnt;
reg key_reg;

reg key_edge_reg_d0;
reg key_edge_reg_d1;

//Debounce Counter
always @(posedge sys_clk_i or negedge sys_rst_n_i) begin
    if (!sys_rst_n_i) begin
        cnt <= 20'd0;
        key_reg <= 1'b0;
    end
    else begin
        key_reg <= key_button_i; //delay 1 clk
        if (key_reg != key_button_i) begin //start delay
            cnt <= DELAY_TIME;
        end
        else begin
            if (cnt > 20'd0)
                cnt <= cnt - 1'b1;
            else
                cnt <= 20'd0;
        end
    end
end

//Output
always @(posedge sys_clk_i or negedge sys_rst_n_i) begin
    if (!sys_rst_n_i) begin
        key_value_o <= 1'b0; //default value : LOW=0
        is_change_o <= 1'b0; //default : no press
    end
    else if (cnt == 20'd1) begin
        key_value_o <= key_button_i;
        is_change_o <= 1'b1;
    end
    else begin
        key_value_o <= key_value_o;
        is_change_o <= 1'b0;
    end
end

//get edge signal of button
assign key_negedge_sig_o = (~key_edge_reg_d0) & key_edge_reg_d1;
assign key_posedge_sig_o = key_edge_reg_d0 & (~key_edge_reg_d1);

always @(posedge sys_clk_i or negedge sys_rst_n_i) begin
    if (!sys_rst_n_i) begin
        key_edge_reg_d0 <= 1'b0;
        key_edge_reg_d1 <= 1'b0;
    end
    else begin
        key_edge_reg_d0 <= key_value_o;
        key_edge_reg_d1 <= key_edge_reg_d0;
    end
end
endmodule
