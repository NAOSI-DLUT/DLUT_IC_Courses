`timescale 1ns/1ps

module uart_rx (
           input wire sys_clk, //base clk
           input wire uart_rx_clk, //oversampling clk
           input wire sys_rst_n,

           input wire rx_en,
           output reg rx_busy,
           output reg rx_ready,

           output reg [7: 0] rx_data,
           input wire rxd
       );
localparam RX_STATE_START = 3'b001;
localparam RX_STATE_DATA = 3'b010;
localparam RX_STATE_STOP = 3'b100;

reg [2: 0] global_state = RX_STATE_START;

reg [3: 0] sample_cnt = 4'b0; //sample counter
reg [2: 0] sample_bit = 3'b0; //data sample
reg [3: 0] bitpos = 4'b0; //add 1 bit to suit sampling done condition
reg [7: 0] rx_data_temp = 8'b0;

//mealy FSM
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        global_state <= RX_STATE_START;
        sample_cnt <= 4'b0;
        sample_bit <= 3'b0;
        rx_data <= 8'b0;
        rx_data_temp <= 8'b0;
        bitpos <= 4'b0;
        rx_busy <= 1'b0;
        rx_ready <= 1'b0;
    end
    else if (rx_en) begin //rx data send out
        rx_ready <= 1'b0;
    end
    else if (uart_rx_clk) begin
        case (global_state)
            RX_STATE_START: begin
                if (!rxd || sample_cnt != 0) begin //got UART start-bit then sample started
                    sample_cnt <= sample_cnt + 4'b1;
                    rx_busy <= 1'b1;
                end

                if (sample_cnt == 15) begin //start recv data-bits
                    global_state <= RX_STATE_DATA;
                    sample_cnt <= 4'b0; //clear sample counter
                    sample_bit <= 3'b0;
                    rx_data_temp <= 8'b0;
                    bitpos <= 4'b0;
                end
            end
            RX_STATE_DATA: begin //recv data bits
                sample_cnt <= sample_cnt + 4'b1;

                // if (sample_cnt == 4'h7) begin //data sampling 1
                //     sample_bit[0] <= rxd;
                //     sample_bit[1] <= sample_bit[1];
                //     sample_bit[2] <= sample_bit[2];
                // end
                // else if (sample_cnt == 4'h8) begin //data sampling 2
                //     sample_bit[0] <= sample_bit[0];
                //     sample_bit[1] <= rxd;
                //     sample_bit[2] <= sample_bit[2];
                // end
                // else if (sample_cnt == 4'h9) begin //data sampling 3
                //     sample_bit[0] <= sample_bit[0];
                //     sample_bit[1] <= sample_bit[1];
                //     sample_bit[2] <= rxd;
                // end
                // else if (sample_cnt == 4'hE) begin //get sampling result
                //     // if (sample_bit[0] == sample_bit[1]) begin
                //     //     rx_data[bitpos[2: 0]] <= sample_bit[0];
                //     // end
                //     // else if (sample_bit[0] & sample_bit[2]) begin
                //     //     rx_data[bitpos[2: 0]] <= sample_bit[0];
                //     // end
                //     // else if (sample_bit[1] & sample_bit[2]) begin
                //     //     rx_data[bitpos[2: 0]] <= sample_bit[1];
                //     // end
                //     rx_data[bitpos[2: 0]] <= ((sample_bit[0] & sample_bit[1]) | ((sample_bit[0] & sample_bit[2])) | (sample_bit[1] & sample_bit[2])); //majority judgement
                //     bitpos <= bitpos + 4'b1;
                // end
                // else begin
                //     sample_bit <= sample_bit;
                // end
                if (sample_cnt == 4'h8) begin
                    rx_data_temp[bitpos[2: 0]] <= rxd; //get middle position value
                    bitpos <= bitpos + 4'b1;
                end

                if (bitpos == 8 && sample_cnt == 15) begin //data sampling done, stop recv
                    global_state <= RX_STATE_STOP;
                end
            end
            RX_STATE_STOP: begin
                if (sample_cnt == 15 || (sample_cnt >= 8 && !rxd)) begin //recv done
                    global_state <= RX_STATE_START;
                    rx_data <= rx_data_temp;
                    sample_cnt <= 4'b0;
                    rx_ready <= 1'b1;
                    rx_busy <= 1'b0;
                end
                else begin
                    sample_cnt <= sample_cnt + 4'b1;
                end
            end
            default: begin
                global_state <= RX_STATE_START;
            end
        endcase
    end
end

endmodule
