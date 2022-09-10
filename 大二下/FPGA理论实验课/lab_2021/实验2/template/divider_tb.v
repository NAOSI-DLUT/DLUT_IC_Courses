`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/06/22 22:22:04
// Design Name:
// Module Name: divider_tb
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


module divider_tb();
reg sysclk;
reg sys_rst_n;

wire clk_1MHz;
wire clk_1KHz;
wire clk_10ms;

//T=8ns
//T/2=4ns
always #4 begin
    sysclk = ~sysclk;
end

initial begin
    sysclk = 0;
    sys_rst_n = 0;
    #20;
    sys_rst_n = 1;
    repeat(20_000) begin //20ms
        #1_000; //1us
    end
    // #1000;
    // $finish();
    $stop();
end

integer i = 0;
always @(posedge sysclk) begin
    if (clk_1MHz) begin
        i = i + 1;
    end

    if (i == 125) begin
        i = 0;
    end
end

initial begin
    $dumpfile("divider_tb.vcd");
    $dumpvars();
end

divider divider_inst(
            .sys_clk_125M ( sysclk ),
            .sys_rst_n ( sys_rst_n ),
            .clk_1MHz ( clk_1MHz ),
            .clk_1KHz ( clk_1KHz ),
            .clk_10ms ( clk_10ms )
        );
endmodule
