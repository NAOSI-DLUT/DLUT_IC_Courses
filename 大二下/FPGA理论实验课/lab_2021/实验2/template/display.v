`timescale 1ns / 1ps

module display(
           input wire sys_clk_125M,
           input wire sys_rst_n,

           input wire mode_sel_u,
           input wire mode_sel_d,
           input wire [1: 0] show_mode,

           input wire [3: 0] csec_h,
           input wire [3: 0] csec_l,
           input wire [3: 0] sec_h,
           input wire [3: 0] sec_l,
           input wire [3: 0] min_h,
           input wire [3: 0] min_l,
           input wire [3: 0] hour_h,
           input wire [3: 0] hour_l,
           input wire [3: 0] day_h,
           input wire [3: 0] day_l,
           input wire [3: 0] month_h,
           input wire [3: 0] month_l,
           input wire [3: 0] week,
           input wire [3: 0] y3,
           input wire [3: 0] y2,
           input wire [3: 0] y1,
           input wire [3: 0] y0,

           output reg [3: 0] led
       );
localparam SHOW_LOW_Y0 = 2'b00;
localparam SHOW_HIGH_Y1 = 2'b01;
localparam SHOW_Y2 = 2'b10;
localparam SHOW_Y3 = 2'b11;

localparam MODE_CSEC = 8'b0000_0001;
localparam MODE_SEC = 8'b0000_0010;
localparam MODE_MIN = 8'b0000_0100;
localparam MODE_HOUR = 8'b0000_1000;
localparam MODE_DAY = 8'b0001_0000;
localparam MODE_MONTH = 8'b0010_0000;
localparam MODE_WEEK = 8'b0100_0000;
localparam MODE_YEAR = 8'b1000_0000;

//MODE FSM
reg [7: 0] mode_current_state;
reg [7: 0] mode_next_state;

//state roll
always @(posedge sys_clk_125M or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        mode_current_state <= MODE_CSEC; //default: show csec
    end
    else begin
        mode_current_state <= mode_next_state;
    end
end

//condition change
always @( * ) begin
    case (mode_current_state)
        MODE_CSEC: begin
            if ({mode_sel_u, mode_sel_d} == 2'b10) begin
                mode_next_state = MODE_SEC;
            end
            else if ({mode_sel_u, mode_sel_d} == 2'b01) begin
                mode_next_state = MODE_YEAR;
            end
            else begin
                mode_next_state = MODE_CSEC;
            end
        end
        MODE_SEC: begin
            if ({mode_sel_u, mode_sel_d} == 2'b10) begin
                mode_next_state = MODE_MIN;
            end
            else if ({mode_sel_u, mode_sel_d} == 2'b01) begin
                mode_next_state = MODE_CSEC;
            end
            else begin
                mode_next_state = MODE_SEC;
            end
        end
        MODE_MIN: begin
            if ({mode_sel_u, mode_sel_d} == 2'b10) begin
                mode_next_state = MODE_HOUR;
            end
            else if ({mode_sel_u, mode_sel_d} == 2'b01) begin
                mode_next_state = MODE_SEC;
            end
            else begin
                mode_next_state = MODE_MIN;
            end
        end
        MODE_HOUR: begin
            if ({mode_sel_u, mode_sel_d} == 2'b10) begin
                mode_next_state = MODE_DAY;
            end
            else if ({mode_sel_u, mode_sel_d} == 2'b01) begin
                mode_next_state = MODE_MIN;
            end
            else begin
                mode_next_state = MODE_HOUR;
            end
        end
        MODE_DAY: begin
            if ({mode_sel_u, mode_sel_d} == 2'b10) begin
                mode_next_state = MODE_MONTH;
            end
            else if ({mode_sel_u, mode_sel_d} == 2'b01) begin
                mode_next_state = MODE_HOUR;
            end
            else begin
                mode_next_state = MODE_DAY;
            end
        end
        MODE_MONTH: begin
            if ({mode_sel_u, mode_sel_d} == 2'b10) begin
                mode_next_state = MODE_WEEK;
            end
            else if ({mode_sel_u, mode_sel_d} == 2'b01) begin
                mode_next_state = MODE_DAY;
            end
            else begin
                mode_next_state = MODE_MONTH;
            end
        end
        MODE_WEEK: begin
            if ({mode_sel_u, mode_sel_d} == 2'b10) begin
                mode_next_state = MODE_YEAR;
            end
            else if ({mode_sel_u, mode_sel_d} == 2'b01) begin
                mode_next_state = MODE_MONTH;
            end
            else begin
                mode_next_state = MODE_WEEK;
            end
        end
        MODE_YEAR: begin
            if ({mode_sel_u, mode_sel_d} == 2'b10) begin
                mode_next_state = MODE_CSEC;
            end
            else if ({mode_sel_u, mode_sel_d} == 2'b01) begin
                mode_next_state = MODE_WEEK;
            end
            else begin
                mode_next_state = MODE_YEAR;
            end
        end
        default: begin
            mode_next_state = MODE_CSEC;
        end
    endcase
end

always @(posedge sys_clk_125M or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        led <= 4'b0;
    end
    else begin
        case (show_mode)
            SHOW_LOW_Y0: begin
                case (mode_current_state)
                    MODE_CSEC: begin
                        led <= csec_l;
                    end
                    MODE_SEC: begin
                        led <= sec_l;
                    end
                    MODE_MIN: begin
                        led <= min_l;
                    end
                    MODE_HOUR: begin
                        led <= hour_l;
                    end
                    MODE_DAY: begin
                        led <= day_l;
                    end
                    MODE_MONTH: begin
                        led <= month_l;
                    end
                    MODE_WEEK: begin
                        led <= week;
                    end
                    MODE_YEAR: begin
                        led <= y0;
                    end
                    default: begin
                        led <= 4'b0;
                    end
                endcase
            end
            SHOW_HIGH_Y1: begin
                case (mode_current_state)
                    MODE_CSEC: begin
                        led <= csec_h;
                    end
                    MODE_SEC: begin
                        led <= sec_h;
                    end
                    MODE_MIN: begin
                        led <= min_h;
                    end
                    MODE_HOUR: begin
                        led <= hour_h;
                    end
                    MODE_DAY: begin
                        led <= day_h;
                    end
                    MODE_MONTH: begin
                        led <= month_h;
                    end
                    MODE_WEEK: begin
                        led <= week;
                    end
                    MODE_YEAR: begin
                        led <= y1;
                    end
                    default: begin
                        led <= 4'b0;
                    end
                endcase
            end
            SHOW_Y2: begin
                case (mode_current_state)
                    MODE_CSEC: begin
                        led <= csec_h;
                    end
                    MODE_SEC: begin
                        led <= sec_h;
                    end
                    MODE_MIN: begin
                        led <= min_h;
                    end
                    MODE_HOUR: begin
                        led <= hour_h;
                    end
                    MODE_DAY: begin
                        led <= day_h;
                    end
                    MODE_MONTH: begin
                        led <= month_h;
                    end
                    MODE_WEEK: begin
                        led <= week;
                    end
                    MODE_YEAR: begin
                        led <= y2;
                    end
                    default: begin
                        led <= 4'b0;
                    end
                endcase
            end
            SHOW_Y3: begin
                case (mode_current_state)
                    MODE_CSEC: begin
                        led <= csec_h;
                    end
                    MODE_SEC: begin
                        led <= sec_h;
                    end
                    MODE_MIN: begin
                        led <= min_h;
                    end
                    MODE_HOUR: begin
                        led <= hour_h;
                    end
                    MODE_DAY: begin
                        led <= day_h;
                    end
                    MODE_MONTH: begin
                        led <= month_h;
                    end
                    MODE_WEEK: begin
                        led <= week;
                    end
                    MODE_YEAR: begin
                        led <= y3;
                    end
                    default: begin
                        led <= 4'b0;
                    end
                endcase
            end
            default: begin
                led <= 4'b0;
            end
        endcase
    end
end

endmodule
