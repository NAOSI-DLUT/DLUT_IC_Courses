
`timescale 1ns/100ps
module tb();
  reg [15:0] ix,iy;
  wire [15:0] oz;
  reg a_en;
  wire ost;
  reg clk;
  
  floatadd  tb(.ix(ix), .iy(iy), .clk(clk), .a_en(a_en), .ost(ost),.oz(oz));
  
  always 
  #1 clk = ~clk;
  initial 
  begin 
    clk=0;
    a_en=1;
    ix=32'b1000100010001000;
    iy=32'b1000100010001000;
  end
endmodule