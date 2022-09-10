`timescale 1ns/1ps

module uart_top #(
           parameter CLK_FRE = 50,   //Mhz
           parameter BAUD_RATE = 115200
       )
       (
           input wire sys_clk,
           input wire sys_rst_n,

           //data
           input wire [7: 0] tx_data,
           output wire [7: 0] rx_data,

           //control
           input wire WR_n,   //master write signal, active low
           input wire RD_n,   //master read signal, active low

           output wire tx_ready,
           output wire tx_busy,
           output wire rx_ready,
           output wire rx_busy,

           //uart pins
           input wire rxd,
           output wire txd
       );
wire uart_rx_clk;
wire uart_tx_clk;

uart_clk_gen #(
                 .CLK_FRE ( CLK_FRE ),
                 .BAUD_RATE ( BAUD_RATE )
             )
             u_uart_clk_gen(
                 //ports
                 .sys_clk ( sys_clk ),
                 .sys_rst_n ( sys_rst_n ),
                 .uart_rx_clk ( uart_rx_clk ),
                 .uart_tx_clk ( uart_tx_clk )
             );

uart_rx u_uart_rx(
            //ports
            .sys_clk ( sys_clk ),
            .uart_rx_clk ( uart_rx_clk ),
            .sys_rst_n ( sys_rst_n ),

            .rx_en( !RD_n ),
            .rx_busy ( rx_busy ),
            .rx_ready ( rx_ready ),

            .rxd ( rxd ),
            .rx_data ( rx_data )
        );

uart_tx u_uart_tx(
            //ports
            .sys_clk ( sys_clk ),
            .uart_tx_clk ( uart_tx_clk ),
            .sys_rst_n ( sys_rst_n ),

            .tx_en ( !WR_n ),
            .tx_busy ( tx_busy ),
            .tx_ready ( tx_ready ),

            .tx_data ( tx_data ),
            .txd ( txd )
        );


endmodule

    // module uart_top #(
    //            parameter CLK_FRE = 50,  //Mhz
    //            parameter BAUD_RATE = 115200
    //        )
    //        (
    //            input wire sys_clk,
    //            input wire sys_rst_n,

    //            //data
    //            output wire [7: 0] rx_data,
    //            input wire [7: 0] tx_data,

    //            //control
    //            input wire rdy_clr,
    //            output wire rx_ready,
    //            input wire wr_en,
    //            output wire tx_busy,

    //            //uart pins
    //            input wire rxd,
    //            output wire txd
    //        );
    // wire uart_rx_clk;
    // wire uart_tx_clk;

    // uart_clk_gen #(
    //                  .CLK_FRE ( CLK_FRE ),
    //                  .BAUD_RATE ( BAUD_RATE )
    //              )
    //              u_uart_clk_gen(
    //                  //ports
    //                  .sys_clk ( sys_clk ),
    //                  .sys_rst_n ( sys_rst_n ),
    //                  .uart_rx_clk ( uart_rx_clk ),
    //                  .uart_tx_clk ( uart_tx_clk )
    //              );

    // wire [7: 0]	data;

    // uart_rx #(
    //             .RX_STATE_START ( 2'b00 ),
    //             .RX_STATE_DATA ( 2'b01 ),
    //             .RX_STATE_STOP ( 2'b10 ))
    //         u_uart_rx(
    //             //ports
    //             .rx ( rxd ),
    //             .rdy ( rx_ready ),
    //             .rdy_clr (rdy_clr ),
    //             .clk_50m ( sys_clk ),
    //             .clken ( uart_rx_clk ),
    //             .data ( rx_data )
    //         );

    // uart_tx #(
    //             .STATE_IDLE ( 2'b00 ),
    //             .STATE_START ( 2'b01 ),
    //             .STATE_DATA ( 2'b10 ),
    //             .STATE_STOP ( 2'b11 ))
    //         u_uart_tx(
    //             //ports
    //             .din ( tx_data ),
    //             .wr_en ( wr_en),
    //             .clk_50m ( sys_clk ),
    //             .clken ( uart_tx_clk ),
    //             .tx ( txd ),
    //             .tx_busy ( tx_busy )
    //         );


    // endmodule
