`timescale 1ns/1ps

module uart_tx (
           input wire sys_clk, //base clk
           input wire uart_tx_clk, //uart-tx clk
           input wire sys_rst_n,

           input wire tx_en,
           output reg tx_busy,
           output reg tx_ready,

           input wire [7: 0] tx_data,
           output reg txd
       );
localparam TX_STATE_IDLE = 4'b0001;
localparam TX_STATE_START = 4'b0010;
localparam TX_STATE_DATA = 4'b0100;
localparam TX_STATE_STOP = 4'b1000;

reg [3: 0] global_state = TX_STATE_IDLE;

reg [7: 0] temp_send_data = 8'b0;
reg [2: 0] bitpos = 3'b0;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        global_state <= TX_STATE_IDLE;
        temp_send_data <= 8'b0;
        bitpos <= 3'b0;
        tx_ready <= 1'b1;
        tx_busy <= 1'b0;
        txd <= 1'b1; //default: high
    end
    else begin
        case (global_state)
            TX_STATE_IDLE: begin
                txd <= 1'b1; //default: high
                if (tx_en) begin
                    global_state <= TX_STATE_START;
                    temp_send_data <= tx_data; //load tx data
                    bitpos <= 3'b0;
                    tx_ready <= 1'b0;
                    tx_busy <= 1'b1;
                end
            end
            TX_STATE_START: begin
                if (uart_tx_clk) begin
                    txd <= 1'b0; //pull low, trans start
                    global_state <= TX_STATE_DATA;
                end
            end
            TX_STATE_DATA: begin
                if (uart_tx_clk) begin
                    txd <= temp_send_data[bitpos[2: 0]];
                    bitpos <= bitpos + 3'h1;
                    if (bitpos == 3'h7) begin //data trans over, send stop-bit
                        global_state <= TX_STATE_STOP;
                    end
                end
            end
            TX_STATE_STOP: begin
                if (uart_tx_clk) begin
                    txd <= 1'b1; //pull high,trans stop
                    global_state <= TX_STATE_IDLE;
                    tx_ready <= 1'b1;
                    tx_busy <= 1'b0;
                end
            end
            default: begin
                txd <= 1'b1;
                temp_send_data <= 8'b0;
                tx_ready <= 1'b1;
                tx_busy <= 1'b0;
                global_state <= TX_STATE_IDLE;
            end
        endcase
    end
end

endmodule
