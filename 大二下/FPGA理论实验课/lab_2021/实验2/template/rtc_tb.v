`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/06/22 23:02:00
// Design Name:
// Module Name: rtc_tb
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


module rtc_tb();
// Inputs
reg sys_clk_125M =0;
reg sys_rst_n=0;

// Outputs
wire [3: 0]	csec_h;
wire [3: 0]	csec_l;
wire [3: 0]	sec_h;
wire [3: 0]	sec_l;
wire [3: 0]	min_h;
wire [3: 0]	min_l;
wire [3: 0]	hour_h;
wire [3: 0]	hour_l;
wire [3: 0]	day_h;
wire [3: 0]	day_l;
wire [3: 0]	month_h;
wire [3: 0]	month_l;
wire [3: 0]	week;
wire [3: 0]	y3;
wire [3: 0]	y2;
wire [3: 0]	y1;
wire [3: 0]	y0;

//T=8ns
//T/2=4ns
always #4 begin
    sys_clk_125M = ~sys_clk_125M;
end

// integer stage = 0;
// always @(posedge sys_clk_125M) begin
//     case (stage)
//         0: begin
// 			sys_rst_n = 0;
//             stage = 1;
//         end
//         1: begin
// 			sys_rst_n = 1;
//             stage = 2;
//         end
//         2: begin
//             stage = 3;
//         end
//         3: begin
//             stage = 2;
//         end
//         default: begin
//             stage = 2;
//         end
//     endcase
// end

initial begin
	sys_rst_n = 0;
	#10;
	sys_rst_n = 1;
end

// Instantiate the Unit Under Test (UUT)
rtc u_rtc(
        //ports
        .sys_clk_125M ( sys_clk_125M ),
        .sys_rst_n ( sys_rst_n ),
        .csec_h ( csec_h ),
        .csec_l ( csec_l ),
        .sec_h ( sec_h ),
        .sec_l ( sec_l ),
        .min_h ( min_h ),
        .min_l ( min_l ),
        .hour_h ( hour_h ),
        .hour_l ( hour_l ),
        .day_h ( day_h ),
        .day_l ( day_l ),
        .month_h ( month_h ),
        .month_l ( month_l ),
        .week ( week ),
        .y3 ( y3 ),
        .y2 ( y2 ),
        .y1 ( y1 ),
        .y0 ( y0 )
    );

endmodule
