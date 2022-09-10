`timescale 1ns / 1ps

module leapyear(
           input [3: 0] y3,
           input [3: 0] y2,
           input [3: 0] y1,
           input [3: 0] y0,
           output reg is_leap_year
       );
//day BCD mn:
//when m=odd n=2/6
//when m=even n=0/4/8
always @( * ) begin
    if ((y3[0] == 1) && ((y2 == 2) || (y2 == 6)) && ({y1, y0} == 0))
        is_leap_year = 1'b1;
    else if ((y3[0] == 0) && ((y2 == 0) || (y2 == 4) || (y2 == 8)) && ({y1, y0} == 0))
        is_leap_year = 1'b1;
    else if ((y1[0] == 1) && ((y0 == 2) || (y0 == 6)))
        is_leap_year = 1'b1;
    else if ((y1[0] == 0) && ((y0 == 0) || (y0 == 4) || (y0 == 8)) && ({y1, y0} != 0))
        is_leap_year = 1'b1;
    else
        is_leap_year = 1'b0;
end
endmodule
