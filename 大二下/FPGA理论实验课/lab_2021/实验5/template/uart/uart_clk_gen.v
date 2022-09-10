`timescale 1ns/1ps

module uart_clk_gen#(
    parameter CLK_FRE = 50, //clock frequency(MHz)
    parameter BAUD_RATE = 115200 //serial baud rate
)(
    input wire sys_clk,
    input wire sys_rst_n,
    output wire uart_rx_clk,
    output wire uart_tx_clk
);
localparam RX_CLK_SCALER = 16;
localparam RX_CLK_COUNT_MAX = (CLK_FRE* 1_000_000) / (BAUD_RATE * RX_CLK_SCALER); //uart oversampling clk
localparam TX_CLK_COUNT_MAX = (CLK_FRE* 1_000_000) / BAUD_RATE; //base baud rate clk

localparam RX_CNT_WIDTH = $clog2(RX_CLK_COUNT_MAX);
localparam TX_CNT_WIDTH = $clog2(TX_CLK_COUNT_MAX);
reg [RX_CNT_WIDTH - 1:0] rx_cnt = 0;
reg [TX_CNT_WIDTH - 1:0] tx_cnt = 0;

assign uart_rx_clk = (rx_cnt == 'd0);
assign uart_tx_clk = (tx_cnt == 'd0);

always @(posedge sys_clk) begin
    if(!sys_rst_n) begin
        rx_cnt <= {RX_CNT_WIDTH{1'b0}};
    end
	if (rx_cnt == RX_CLK_COUNT_MAX[RX_CNT_WIDTH - 1:0]) begin
        rx_cnt <= {RX_CNT_WIDTH{1'b0}};
    end
	else begin
        rx_cnt <= rx_cnt + 1;
    end
end

always @(posedge sys_clk) begin
    if(!sys_rst_n) begin
        tx_cnt <= {TX_CNT_WIDTH{1'b0}};
    end
	if (tx_cnt == TX_CLK_COUNT_MAX[TX_CNT_WIDTH - 1:0]) begin
        tx_cnt <= {TX_CNT_WIDTH{1'b0}};
    end
	else begin
        tx_cnt <= tx_cnt + 1;
    end
end
endmodule
