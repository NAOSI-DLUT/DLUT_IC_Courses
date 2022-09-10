`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/08/09 16:52:00
// Design Name:
// Module Name: display_tb
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


module display_tb();
// display Parameters
parameter DELAY_TIME = 20'd1_000_000;

// display Inputs
reg sys_clk_125M = 0;
reg sys_rst_n = 0;

reg mode_sel_u = 0;
reg mode_sel_d = 0;
reg [1: 0] show_mode = 0;

reg [3: 0] csec_h = 4'b0001;
reg [3: 0] csec_l = 4'b0010;
reg [3: 0] sec_h = 4'b0100;
reg [3: 0] sec_l = 4'b1000;
reg [3: 0] min_h = 4'b0001;
reg [3: 0] min_l = 4'b0011;
reg [3: 0] hour_h = 4'b0111;
reg [3: 0] hour_l = 4'b1111;
reg [3: 0] day_h = 4'b0101;
reg [3: 0] day_l = 4'b1010;
reg [3: 0] month_h = 4'b1001;
reg [3: 0] month_l = 4'b0110;
reg [3: 0] week = 4'b0100;
reg [3: 0] y3 = 4'b0001;
reg [3: 0] y2 = 4'b0010;
reg [3: 0] y1 = 4'b0100;
reg [3: 0] y0 = 4'b1000;

// display Outputs
wire [3: 0] led;

initial begin
    forever
        #4 sys_clk_125M = ~sys_clk_125M;
end

integer stage = 0;
integer i = 0;
always @(posedge sys_clk_125M) begin
    case (stage)
        0: begin
            sys_rst_n = 1'b0;
            stage = 1;
        end
        1: begin
            sys_rst_n = 1'b1;
            stage = 2;
        end
        2: begin
            mode_sel_u = {$random} % 2;
            mode_sel_d = {$random} % 2;
            show_mode = {$random} % 4;
            stage = 3;
        end
        3: begin
            stage = 2;
            $display("%b", led);
            if (i == 5) begin
                stage = 4;
            end
            i = i + 1;
        end
        4: begin
            stage = 4;
        end
        default: begin
            stage = 4;
        end
    endcase
end

initial begin
    $dumpfile("tb.vcd");
    $dumpvars();
    #1000;
    $stop();
end

display #(
            .DELAY_TIME ( DELAY_TIME ))
        u_display_inst (
            .sys_clk_125M ( sys_clk_125M ),
            .sys_rst_n ( sys_rst_n ),
            .mode_sel_u ( mode_sel_u ),
            .mode_sel_d ( mode_sel_d ),
            .show_mode ( show_mode [1: 0] ),
            .csec_h ( csec_h [3: 0] ),
            .csec_l ( csec_l [3: 0] ),
            .sec_h ( sec_h [3: 0] ),
            .sec_l ( sec_l [3: 0] ),
            .min_h ( min_h [3: 0] ),
            .min_l ( min_l [3: 0] ),
            .hour_h ( hour_h [3: 0] ),
            .hour_l ( hour_l [3: 0] ),
            .day_h ( day_h [3: 0] ),
            .day_l ( day_l [3: 0] ),
            .month_h ( month_h [3: 0] ),
            .month_l ( month_l [3: 0] ),
            .week ( week [3: 0] ),
            .y3 ( y3 [3: 0] ),
            .y2 ( y2 [3: 0] ),
            .y1 ( y1 [3: 0] ),
            .y0 ( y0 [3: 0] ),

            .led ( led [3: 0] )
        );

endmodule
