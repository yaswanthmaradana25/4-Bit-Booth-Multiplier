`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2026 12:15:13
// Design Name: 
// Module Name: booth_multiplier
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


module booth_multiplier(
                        input clk,
                        input signed [3:0]multiplier ,
                        input signed [3:0]multiplicand ,
                        input reset , start ,
                        output reg [7:0]product,
                        output reg ready);
     
     
    reg signed [3:0] Q , M;
    reg signed [4:0] A;
    reg signed Q_1;
    reg [1:0] present_state ;
    reg [1:0] next_state;
    reg [2:0]count;
                  
    parameter IDLE = 2'b00 , 
              CHECK = 2'b01 ,
              SHIFT = 2'b10 ,
              FINISH = 2'b11 ;
              
    always @(posedge clk) begin
        if(reset) begin
            present_state <= IDLE;
        end
        else begin
            present_state <= next_state;
        end    
    end  
    
    //next state logic
    always @(*) begin
        case(present_state) 
            IDLE: begin
                if(start) begin
                    next_state = CHECK;
                end
            end
            
            CHECK : begin
                next_state = SHIFT;
            end
            
            SHIFT : begin
                if(count==1) begin
                    next_state = FINISH;
                end
                else begin
                    next_state = CHECK;
                end
            end
            
            FINISH : begin
                next_state =IDLE;
            end
            default : begin
                next_state = IDLE;
            end
        endcase
    end
    
    
    always @(posedge clk) begin
        if(reset) begin
            ready <= 0;
            product <=0;
        end
        else begin
            case(present_state)
                IDLE : begin
                    if(start) begin
                        A <=5'b00000;
                        Q <= multiplier ;
                        M <= multiplicand;
                        Q_1 <=0;
                        count <=3'd4;
                        ready <=0;
                    end
                end
                CHECK : begin
                    if(Q[0] ==1 && Q_1==0) begin
                        A <= A-M;
                    end
                    else if (Q[0]==0 && Q_1==1) begin
                        A <= A+M;
                    end
                end
                SHIFT: begin
                    {A,Q,Q_1} <= {A[4] , A[4:0] ,Q[3:0]};
                    count<=count-1;     
                end
                FINISH : begin
                    product<={A[3:0],Q[3:0]};
                    ready<=1;
                end
            endcase 
        end
    end          
endmodule
