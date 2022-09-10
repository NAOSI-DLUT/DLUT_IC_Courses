`timescale 1ns / 1ps

module divider(
           input wire sys_clk_125M,
           input wire sys_rst_n,
           output wire clk_1MHz,
           output wire clk_1KHz,
           output wire clk_10ms
       );
//125 / 125 = 1MHz
//1MHz / 1000 = 1kHz
//T=10ms <=> prs=10
localparam CLK_1M_DIV = 8'd125;
localparam CLK_1K_DIV = 32'd125_000;
localparam CLK_10MS_DIV = 32'd1_250_000;

reg [7: 0] m_div_cnt;
reg [31: 0] k_div_cnt;
reg [31: 0] cnt;

reg clk_1MHz_r;
reg clk_1KHz_r;
reg clk_10ms_r;

//1MHz clk
always @(posedge sys_clk_125M or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        m_div_cnt <= 8'd0;
        clk_1MHz_r <= 1'b0;
    end
    else if (m_div_cnt == (CLK_1M_DIV / 2 - 1)) begin
        m_div_cnt <= 8'd0;
        clk_1MHz_r <= ~clk_1MHz_r;
    end
    else begin
        m_div_cnt <= m_div_cnt + 8'd1;
        clk_1MHz_r <= clk_1MHz_r;
    end
end

BUFG BUFG_inst_1M (
         .O(clk_1MHz), // Clock output
         .I(clk_1MHz_r) // Clock input
     );

//1kHz clk
always @(posedge sys_clk_125M or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        k_div_cnt <= 32'd0;
        clk_1KHz_r <= 1'b0;
    end
    else if (k_div_cnt == (CLK_1K_DIV / 2 - 1)) begin
        k_div_cnt <= 32'd0;
        clk_1KHz_r <= ~clk_1KHz_r;
    end
    else begin
        k_div_cnt <= k_div_cnt + 32'd1;
        clk_1KHz_r <= clk_1KHz_r;
    end
end

BUFG BUFG_inst_1K (
         .O(clk_1KHz), // Clock output
         .I(clk_1KHz_r) // Clock input
     );

//T=10ms clk
always @(posedge sys_clk_125M or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cnt <= 32'd0;
        clk_10ms_r <= 1'b0;
    end
    else if (cnt == (CLK_10MS_DIV / 2 - 1)) begin
        cnt <= 32'd0;
        clk_10ms_r <= ~clk_10ms_r;
    end
    else begin
        cnt <= cnt + 1;
        clk_10ms_r <= clk_10ms_r;
    end
end

BUFG BUFG_inst_10m (
         .O(clk_10ms), // Clock output
         .I(clk_10ms_r) // Clock input
     );

endmodule
