`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/06/22 22:46:44
// Design Name:
// Module Name: leapyear_tb
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


module leapyear_tb();

reg [3: 0] y3;
reg [3: 0] y2;
reg [3: 0] y1;
reg [3: 0] y0;
wire is_leap_year;

initial begin
    y3 = 0;
    y2 = 0;
    y1 = 0;
    y0 = 0;
    #10_000; //10us
    $stop();
end

always #10 begin
    y3 = {$random}%10;
    y2 = {$random}%10;
    y1 = {$random}%10;
    y0 = {$random}%10;
end

initial begin
    $dumpfile("leapyear_tb.vcd");
    $dumpvars();
end

leapyear leapyear_inst(
             .y3 ( y3 ),
             .y2 ( y2 ),
             .y1 ( y1 ),
             .y0 ( y0 ),
             .is_leap_year ( is_leap_year )
         );
endmodule
