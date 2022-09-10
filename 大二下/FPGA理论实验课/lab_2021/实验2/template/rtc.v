`timescale 1ns / 1ps

module rtc(
           input sys_clk_125M,
           input sys_rst_n,

           output reg [3: 0] csec_h,
           output reg [3: 0] csec_l,

           output reg [3: 0] sec_h,
           output reg [3: 0] sec_l,

           output reg [3: 0] min_h,
           output reg [3: 0] min_l,

           output reg [3: 0] hour_h,
           output reg [3: 0] hour_l,

           output reg [3: 0] day_h,
           output reg [3: 0] day_l,

           output reg [3: 0] month_h,
           output reg [3: 0] month_l,

           output reg [3: 0] week,

           output reg [3: 0] y3,
           output reg [3: 0] y2,
           output reg [3: 0] y1,
           output reg [3: 0] y0

           //    output reg [7: 0] csec,
           //    output reg [7: 0] sec,
           //    output reg [7: 0] min,
           //    output reg [7: 0] hour,
           //    output reg [7: 0] day,
           //    output reg [7: 0] week,
           //    output reg [7: 0] month,
           //    output reg [15: 0] year
       );
wire clk_10ms;
wire is_leap_year;

// assign csec = {csec_h, csec_l};
// assign sec = {sec_h, sec_l};
// assign min = {min_h, min_l};
// assign hour = {hour_h, hour_l};
// assign day = {day_h, day_l};
// assign month = {month_h, month_l};
// assign year = {y3, y2, y1, y0};

divider u_divider(
            .sys_clk_125M ( sys_clk_125M ),
            .sys_rst_n ( sys_rst_n ),
            .clk_1MHz ( ),
            .clk_1KHz ( ),
            .clk_10ms ( clk_10ms )
        );

reg clk_10ms_d0;
reg clk_10ms_d1;
wire clk_10ms_pos;
assign clk_10ms_pos = (~clk_10ms_d0) & (clk_10ms_d1);
always @(posedge sys_clk_125M or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        clk_10ms_d0 <= 1'b0;
        clk_10ms_d1 <= 1'b0;
    end
    else begin
        clk_10ms_d0 <= clk_10ms;
        clk_10ms_d1 <= clk_10ms_d0;
    end
end

leapyear u_leapyear(
             .y3 ( y3 ),
             .y2 ( y2 ),
             .y1 ( y1 ),
             .y0 ( y0 ),
             .is_leap_year ( is_leap_year )
         );

//behavior description
always @(posedge sys_clk_125M or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        {y3, y2, y1, y0} <= 16'h2_0_2_2;
        {month_h, month_l} <= 8'h01;
        week <= 4'h01;
        {day_h, day_l} <= 8'h01;
        {hour_h, hour_l} <= 8'h00;
        {min_h, min_l} <= 8'h00;
        {sec_h, sec_l} <= 8'h00;
        {csec_h, csec_l} <= 8'h00;
    end
    else if (clk_10ms_pos) begin //1csec change once
        csec_l <= csec_l + 1;
        if (csec_l == 9) begin
            csec_l <= 0;
            csec_h <= csec_h + 1;
            if ({csec_h, csec_l} >= 8'h99) begin
                {csec_h, csec_l} <= 8'h00;
                sec_l <= sec_l + 1;
                if (sec_l == 9) begin
                    sec_l <= 0;
                    sec_h <= sec_h + 1;
                    if ({sec_h, sec_l} >= 8'h59) begin
                        {sec_h, sec_l} <= 8'h00;
                        min_l <= min_l + 1;
                        if (min_l == 9) begin
                            min_l <= 0;
                            min_h <= min_h + 1;
                            if ({min_h, min_l} >= 8'h59) begin
                                {min_h, min_l} <= 8'h00;
                                hour_l <= hour_l + 1;
                                //hour count carry
                                //09 + 1 = 10
                                //19 + 1 = 20
                                //23 + 1 = 00
                                //no 29 or 39 or ...
                                if ((hour_l == 9) && ((hour_h == 0) || (hour_h == 1))) begin
                                    hour_l <= 0;
                                    hour_h <= hour_h + 1;
                                    if ({hour_h, hour_l} >= 8'h23) begin
                                        {hour_h, hour_l} <= 8'h00;
                                        week <= week + 1;
                                        day_l <= day_l + 1;

                                        //week carry
                                        if (week >= 7) begin
                                            week <= 4'h1;
                                        end
                                        //one day carry
                                        if (day_l == 9) begin
                                            day_l <= 0;
                                            day_h <= day_h + 1;
                                        end

                                        //month carry
                                        if (((({month_h, month_l} == 1) || ({month_h, month_l} == 3) || ({month_h, month_l} == 5) || ({month_h, month_l} == 7) || ({month_h, month_l} == 8) || ({month_h, month_l} == 8'h10) || ({month_h, month_l} == 8'h12)) && ({day_h, day_l} >= 8'h31))
                                                ||     //1,3,5,7,8,10,12 : 31 days
                                                ((({month_h, month_l} == 4) || ({month_h, month_l} == 6) || ({month_h, month_l} == 9) || ({month_h, month_l} == 8'h11) ) && ({day_h, day_l} >= 8'h30)) ||     //4,6,9,11 : 30 days
                                                (({month_h, month_l} == 2) && (is_leap_year) && ({day_h, day_l} >= 8'h29)) ||     //2 : leapyear, 30 days
                                                (({month_h, month_l} == 2) && (!is_leap_year) && ({day_h, day_l} >= 8'h28))) //2 : not leapyear, 29 days
                                        begin
                                            {day_h, day_l} <= 8'h01;
                                            month_l <= month_l + 1;
                                            //month carry
                                            if (month_l == 9) begin
                                                month_l <= 0;
                                                month_h <= month_h + 1;
                                                if ({month_h, month_l} >= 12) begin
                                                    {month_h, month_l} <= 8'h01;
                                                    y0 <= y0 + 1;
                                                    //year caarry
                                                    if (y0 >= 9) begin
                                                        y0 <= 4'h0;
                                                        y1 <= y1 + 1;
                                                        if (y1 >= 9) begin
                                                            y1 <= 4'h0;
                                                            y2 <= y2 + 1;
                                                            if (y2 >= 9) begin
                                                                y2 <= 4'h0;
                                                                y3 <= y3 + 1;
                                                                if (y3 >= 9) begin
                                                                    y3 <= 4'h0;
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

endmodule
