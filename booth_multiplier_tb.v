`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2026 22:58:39
// Design Name: 
// Module Name: booth_multiplier_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module booth_multiplier_tb();
    reg clk ;
    reg signed [3:0] multiplicand , multiplier;
    reg start , reset;
    wire [7:0]product;
    wire ready;
    
    booth_multiplier dut(.clk(clk) , 
                         .reset(reset) , 
                         .start(start) , 
                         .multiplicand(multiplicand),
                         .multiplier(multiplier),
                         .product(product),
                         .ready(ready));
                         
                     
    initial begin
        clk=1'b0; reset=1'b1; start=1'b0;
        #20 reset=1'b0 ; start =1'b1;
        #10 start=1'b0;
    end
    
    initial begin
        forever #5 clk= ~clk;
    end 
    
    initial begin
        #20 multiplicand = -4'd8 ; multiplier =-4'd8;
        wait(ready==1);
        #30 $finish;
    end
endmodule
