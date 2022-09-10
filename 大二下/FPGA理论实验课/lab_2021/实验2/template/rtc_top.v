`timescale 1ns / 1ps

module rtc_top(
           input wire sysclk,
           input wire sys_rst,

           input wire [1: 0] show_mode,
           input wire button_up,
           input wire button_down,

           output wire [3: 0] led
       );
parameter DELAY_TIME = 20'd1_000_000;

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

rtc rtc_inst(
        //ports
        .sys_clk_125M ( sysclk ),
        .sys_rst_n ( ~sys_rst ),

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

wire mode_sel_u;
wire mode_sel_d;

key #(
        .DELAY_TIME ( DELAY_TIME )
    )
    key_up(
        //ports
        .sys_clk_i ( sysclk ),
        .sys_rst_n_i ( ~sys_rst ),

        .key_button_i ( button_up ),
        .key_value_o ( ),
        .is_change_o ( ),
        .key_posedge_sig_o ( ),
        .key_negedge_sig_o ( mode_sel_u )
    );

key #(
        .DELAY_TIME ( DELAY_TIME )
    )
    key_down(
        //ports
        .sys_clk_i ( sysclk ),
        .sys_rst_n_i ( ~sys_rst ),

        .key_button_i ( button_down ),
        .key_value_o ( ),
        .is_change_o ( ),
        .key_posedge_sig_o ( ),
        .key_negedge_sig_o ( mode_sel_d )
    );

display display_inst(
            //ports
            .sys_clk_125M ( sysclk ),
            .sys_rst_n ( ~sys_rst ),

            .mode_sel_u ( mode_sel_u ),
            .mode_sel_d ( mode_sel_d ),
            .show_mode ( show_mode[1: 0] ),

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
            .y0 ( y0 ),

            .led ( led )
        );

endmodule
