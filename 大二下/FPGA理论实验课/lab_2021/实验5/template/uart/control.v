`timescale 1ns/1ps

//accumulate
module control (
           input wire sys_clk,
           input wire sys_rst_n,

           output reg [7: 0] uart_tx_data,
           input wire [7: 0] uart_rx_data,

           input wire rx_ready,
           input wire rx_busy,
           input wire tx_ready,
           input wire tx_busy,

           output reg WR_n,
           output reg RD_n
       );
localparam STATE_RECV = 5'b00001;
localparam STATE_RECV_DONE = 5'b00010;
localparam STATE_CALCULATE = 5'b00100;
localparam STATE_SEND = 5'b01000;
localparam STATE_SEND_DONE = 5'b10000;

reg [4: 0] state;

reg [2: 0] buffer_cnt = 3'b0;
reg [7: 0] data_buffer[0: 7];
reg [15: 0] result;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        WR_n <= 1'b1;
        RD_n <= 1'b1;
        buffer_cnt <= 3'b0;
        result <= 16'b0;
    end
    else begin
        case (state)
            STATE_RECV: begin
                if (rx_ready) begin
                    state <= STATE_RECV_DONE;
                    data_buffer[buffer_cnt] <= uart_rx_data;
                    RD_n <= 1'b0; //read uart
                end
            end
            STATE_RECV_DONE: begin
                RD_n <= 1'b1; //read uart done

                if (buffer_cnt == 3'h7) begin
                    buffer_cnt <= 3'b0;
                    state <= STATE_CALCULATE;
                end
                else begin
                    buffer_cnt <= buffer_cnt + 3'b1;
                    state <= STATE_RECV;
                end
            end
            STATE_CALCULATE: begin
                result <= result + {8'b0, data_buffer[buffer_cnt]};

                if (buffer_cnt == 3'h7) begin
                    buffer_cnt <= 3'b0;
                    state <= STATE_SEND;
                end
                else begin
                    buffer_cnt <= buffer_cnt + 3'b1;
                end
            end
            STATE_SEND: begin
                if (tx_ready) begin
                    state <= STATE_SEND_DONE;
                    if (buffer_cnt == 3'h0) begin
                        uart_tx_data <= result[15: 8];
                    end
                    else if (buffer_cnt == 3'h1) begin
                        uart_tx_data <= result[7: 0];
                    end

                    WR_n <= 1'b0; //write uart
                end
            end
            STATE_SEND_DONE: begin
                WR_n <= 1'b1; //write uart done

                if (buffer_cnt == 3'h1) begin
                    buffer_cnt <= 3'b0;
                    result <= 16'b0;
                    state <= STATE_RECV;
                end
                else begin
                    buffer_cnt <= buffer_cnt + 3'b1;
                    state <= STATE_SEND;
                end
            end
            default: begin
                WR_n <= 1'b1;
                RD_n <= 1'b1;
                state <= STATE_RECV;
            end
        endcase
    end
end

endmodule

    //loopback
    // module control (
    //            input wire sys_clk,
    //            input wire sys_rst_n,

    //            output reg [7: 0] uart_tx_data,
    //            input wire [7: 0] uart_rx_data,

    //            input wire rx_ready,
    //            input wire rx_busy,
    //            input wire tx_ready,
    //            input wire tx_busy,

    //            output reg WR_n,
    //            output reg RD_n
    //        );
    // localparam STATE_IDLE = 5'b00001;
    // localparam STATE_READ = 5'b00010;
    // localparam STATE_MATP = 5'b00100;
    // localparam STATE_MATD = 5'b01000;
    // localparam STATE_SEND = 5'b10000;

    // // reg [4: 0] current_state;
    // // reg [4: 0] next_state;
    // reg [4: 0] state;

    // reg [7: 0] data_temp;
    // reg [7: 0] data_temp_1;
    // reg [7: 0] data_temp_2;

    // always @(posedge sys_clk or negedge sys_rst_n) begin
    //     if (!sys_rst_n) begin
    //         WR_n <= 1'b1;
    //         RD_n <= 1'b1;
    //         data_temp <= 8'b0;
    //         data_temp_1 <= 8'b0;
    //         state <= STATE_IDLE;
    //     end
    //     else begin
    //         case (state)
    //             STATE_IDLE: begin
    //                 if (rx_ready) begin
    //                     state <= STATE_READ;
    //                     data_temp <= uart_rx_data;
    //                     RD_n <= 1'b0; //read uart
    //                 end
    //             end
    //             STATE_READ: begin
    //                 RD_n <= 1'b1;
    //                 data_temp <= data_temp;
    //                 state <= STATE_MATP;
    //             end
    //             STATE_MATP: begin
    //                 data_temp <= data_temp;
    //                 state <= STATE_MATD;
    //             end
    //             STATE_MATD: begin
    //                 if (tx_ready) begin
    //                     uart_tx_data <= data_temp;
    //                     state <= STATE_SEND;
    //                     WR_n <= 1'b0; //write uart
    //                 end
    //             end
    //             STATE_SEND: begin
    //                 WR_n <= 1'b1;
    //                 state <= STATE_IDLE;
    //             end
    //             default: begin
    //                 WR_n <= 1'b1;
    //                 RD_n <= 1'b1;
    //                 state <= STATE_IDLE;
    //             end
    //         endcase
    //     end
    // end

    // endmodule


    //matrix
    // module control (
    //            input wire sys_clk,
    //            input wire sys_rst_n,

    //            output reg [7: 0] uart_tx_data,
    //            input wire [7: 0] uart_rx_data,

    //            input wire rx_ready,
    //            input wire rx_busy,
    //            input wire tx_ready,
    //            input wire tx_busy,

    //            output reg WR_n,
    //            output reg RD_n
    //        );
    // localparam BITWIDTH = 8;
    // localparam IS_BITWIDTH_DOUBLE_SCALE = 0;
    // localparam X_ROW = 3;
    // localparam XCOL_YROW = 3;
    // localparam Y_COL = 3;

    // localparam STATE_IDLE = 5'b00001;
    // localparam STATE_READ = 5'b00010;
    // localparam STATE_MATP = 5'b00100;
    // localparam STATE_MATD = 5'b01000;
    // localparam STATE_SEND = 5'b10000;

    // reg [4: 0] state;

    // reg [7: 0] data_temp;
    // reg [7: 0] data_temp_1;
    // reg [7: 0] data_temp_2;

    // reg [1: 0] row_cnt = 2'b00;
    // reg [1: 0] col_cnt = 2'b00;

    // reg start = 1'b1;
    // wire done;
    // reg signed [BITWIDTH * X_ROW * XCOL_YROW - 1: 0] X;
    // reg signed [BITWIDTH * XCOL_YROW * Y_COL - 1: 0] Y = 72'h010203040506070809;
    // wire signed [BITWIDTH * (IS_BITWIDTH_DOUBLE_SCALE + 1) * X_ROW * Y_COL - 1: 0] Z;

    // always @(posedge sys_clk or negedge sys_rst_n) begin
    //     if (!sys_rst_n) begin
    //         WR_n <= 1'b1;
    //         RD_n <= 1'b1;
    //         row_cnt = 2'b00;
    //         col_cnt = 2'b00;
    //         data_temp <= 8'b0;
    //         data_temp_1 <= 8'b0;
    //         X <= 72'h0;
    //         Y <= 72'h010203040506070809;
    //         state <= STATE_IDLE;
    //     end
    //     else begin
    //         case (state)
    //             STATE_IDLE: begin
    //                 if (rx_ready) begin
    //                     state <= STATE_READ;
    //                     data_temp <= uart_rx_data;
    //                     RD_n <= 1'b0; //read uart
    //                     WR_n <= 1'b1;
    //                 end
    //             end
    //             STATE_READ: begin
    //                 RD_n <= 1'b1;
    //                 X[(BITWIDTH * X_ROW * XCOL_YROW - 1) - (row_cnt * XCOL_YROW * BITWIDTH) - (col_cnt * BITWIDTH) -: BITWIDTH] <= data_temp - 8'h30; //trans ascii to hex and load data
    //                 row_cnt <= row_cnt + 2'b1;
    //                 col_cnt <= col_cnt + 2'b1;
    //                 if (row_cnt == 2'b11 && col_cnt == 2'b11) begin
    //                     row_cnt = 2'b00;
    //                     col_cnt = 2'b00;
    //                     start <= 1'b1;
    //                     state <= STATE_MATP;
    //                 end
    //             end
    //             STATE_MATP: begin
    //                 if (done) begin
    //                     X <= 72'h0;
    //                     start <= 1'b1;
    //                     state <= STATE_MATD;
    //                 end
    //             end
    //             STATE_MATD: begin
    //                 if (tx_ready) begin
    //                     uart_tx_data <= data_temp_1;
    //                     state <= STATE_SEND;
    //                     WR_n <= 1'b0; //write uart
    //                 end
    //             end
    //             STATE_SEND: begin
    //                 WR_n <= 1'b1;
    //                 if (tx_ready) begin
    //                     state <= STATE_IDLE;
    //                 end
    //             end
    //             default: begin
    //                 WR_n <= 1'b1;
    //                 RD_n <= 1'b1;
    //                 state <= STATE_IDLE;
    //             end
    //         endcase
    //     end
    // end



    // endmodule


    //repeat 8bytes
    // module control (
    //            input wire sys_clk,
    //            input wire sys_rst_n,

    //            output reg [7: 0] uart_tx_data,
    //            input wire [7: 0] uart_rx_data,

    //            input wire rx_ready,
    //            input wire rx_busy,
    //            input wire tx_ready,
    //            input wire tx_busy,

    //            output reg WR_n,
    //            output reg RD_n
    //        );
    // localparam STATE_RECV = 5'b00001;
    // localparam STATE_RECV_DONE = 5'b00010;
    // localparam STATE_CALCULATE = 5'b00100;
    // localparam STATE_SEND = 5'b01000;
    // localparam STATE_SEND_DONE = 5'b10000;

    // reg [4: 0] state;

    // reg [2: 0] buffer_cnt = 3'b0;
    // reg [7: 0] data_buffer[0: 7];
    // reg [15: 0] result;

    // always @(posedge sys_clk or negedge sys_rst_n) begin
    //     if (!sys_rst_n) begin
    //         WR_n <= 1'b1;
    //         RD_n <= 1'b1;
    //         buffer_cnt <= 3'b0;
    //         result <= 16'b0;
    //     end
    //     else begin
    //         case (state)
    //             STATE_RECV: begin
    //                 if (rx_ready) begin
    //                     state <= STATE_RECV_DONE;
    //                     data_buffer[buffer_cnt] <= uart_rx_data;
    //                     RD_n <= 1'b0; //read uart
    //                 end
    //             end
    //             STATE_RECV_DONE: begin
    //                 RD_n <= 1'b1; //read uart done

    //                 if (buffer_cnt == 3'h7) begin
    //                     buffer_cnt <= 3'b0;
    //                     state <= STATE_CALCULATE;
    //                 end
    //                 else begin
    //                     buffer_cnt <= buffer_cnt + 3'b1;
    //                     state <= STATE_RECV;
    //                 end
    //             end
    //             STATE_CALCULATE: begin
    //                 state <= STATE_SEND;
    //             end
    //             STATE_SEND: begin
    //                 if (tx_ready) begin
    //                     state <= STATE_SEND_DONE;
    //                     uart_tx_data <= data_buffer[buffer_cnt];
    //                     WR_n <= 1'b0; //write uart
    //                 end
    //             end
    //             STATE_SEND_DONE: begin
    //                 WR_n <= 1'b1; //write uart done

    //                 if (buffer_cnt == 3'h7) begin
    //                     buffer_cnt <= 3'b0;
    //                     state <= STATE_RECV;
    //                 end
    //                 else begin
    //                     buffer_cnt <= buffer_cnt + 3'b1;
    //                     state <= STATE_SEND;
    //                 end
    //             end
    //             default: begin
    //                 WR_n <= 1'b1;
    //                 RD_n <= 1'b1;
    //                 state <= STATE_RECV;
    //             end
    //         endcase
    //     end
    // end

    // endmodule


    //CRC
    // module control (
    //            input wire sys_clk,
    //            input wire sys_rst_n,

    //            output reg [7: 0] uart_tx_data,
    //            input wire [7: 0] uart_rx_data,

    //            input wire rx_ready,
    //            input wire rx_busy,
    //            input wire tx_ready,
    //            input wire tx_busy,

    //            output reg WR_n,
    //            output reg RD_n
    //        );
    // localparam BITWIDTH = 8;
    // localparam LFSR_WIDTH = 32;
    // localparam LFSR_POLY = 32'h04C11DB7;
    // localparam LFSR_INIT = {LFSR_WIDTH{1'b1}};
    // localparam REVERSE = 1;
    // localparam INVERT = 1;

    // localparam STATE_RECV = 5'b00001;
    // localparam STATE_RECV_DONE = 5'b00010;
    // localparam STATE_CALCULATE = 5'b00100;
    // localparam STATE_SEND = 5'b01000;
    // localparam STATE_SEND_DONE = 5'b10000;

    // reg [4: 0] state;

    // reg valid = 1'b0;
    // reg [7: 0] data_i = 8'b0;
    // wire [LFSR_WIDTH - 1: 0] crc_o;

    // reg [2: 0] buffer_cnt = 3'b0;
    // reg [7: 0] data_buffer[0: 7];
    // reg [LFSR_WIDTH - 1: 0] result;

    // always @(posedge sys_clk or negedge sys_rst_n) begin
    //     if (!sys_rst_n) begin
    //         WR_n <= 1'b1;
    //         RD_n <= 1'b1;
    //         buffer_cnt <= 3'b0;
    //         result <= {LFSR_WIDTH{1'b0}};
    //     end
    //     else begin
    //         case (state)
    //             STATE_RECV: begin
    //                 if (rx_ready) begin
    //                     state <= STATE_RECV_DONE;
    //                     valid <= 1'b1; //start CRC32 check
    //                     data_i <= uart_rx_data;
    //                     RD_n <= 1'b0; //read uart
    //                 end
    //             end
    //             STATE_RECV_DONE: begin
    //                 RD_n <= 1'b1; //read uart done

    //                 if (buffer_cnt == 3'h7) begin //accumulate 8bits
    //                     buffer_cnt <= 3'b0;
    //                     data_i <= 8'b0;
    //                     valid <= 1'b0;
    //                     state <= STATE_CALCULATE;
    //                 end
    //                 else begin
    //                     buffer_cnt <= buffer_cnt + 3'b1;
    //                     state <= STATE_RECV;
    //                 end
    //             end
    //             STATE_CALCULATE: begin
    //                 result <= crc_o;
    //                 state <= STATE_SEND;
    //             end
    //             STATE_SEND: begin
    //                 if (tx_ready) begin
    //                     state <= STATE_SEND_DONE;
    //                     case (buffer_cnt)
    //                         0: begin
    //                             uart_tx_data <= result[31: 24];
    //                         end
    //                         1: begin
    //                             uart_tx_data <= result[23: 16];
    //                         end
    //                         2: begin
    //                             uart_tx_data <= result[15: 8];
    //                         end
    //                         3: begin
    //                             uart_tx_data <= result[7: 0];
    //                         end
    //                         default: begin
    //                             uart_tx_data <= 8'b0;
    //                         end
    //                     endcase

    //                     WR_n <= 1'b0; //write uart
    //                 end
    //             end
    //             STATE_SEND_DONE: begin
    //                 WR_n <= 1'b1; //write uart done

    //                 if (buffer_cnt == 3'h3) begin
    //                     buffer_cnt <= 3'b0;
    //                     state <= STATE_RECV;
    //                 end
    //                 else begin
    //                     buffer_cnt <= buffer_cnt + 3'b1;
    //                     state <= STATE_SEND;
    //                 end
    //             end
    //             default: begin
    //                 WR_n <= 1'b1;
    //                 RD_n <= 1'b1;
    //                 state <= STATE_RECV;
    //             end
    //         endcase
    //     end
    // end


    // //CRC32 Validation
    // // lfsr_crc #(
    // //              .BITWIDTH ( BITWIDTH ),
    // //              .LFSR_WIDTH ( LFSR_WIDTH ),
    // //              .LFSR_POLY ( LFSR_POLY ),
    // //              .LFSR_INIT ( {LFSR_WIDTH{1'b1}} ),
    // //              .REVERSE ( REVERSE ),
    // //              .INVERT ( INVERT )
    // //          )
    // //          u_lfsr_crc32(
    // //              //ports
    // //              .clk ( sys_clk ),
    // //              .rst_n ( sys_rst_n ),
    // //              .data_i ( data_i ),
    // //              .valid ( valid ),
    // //              .crc_o ( crc_o )
    // //          );


    // endmodule



