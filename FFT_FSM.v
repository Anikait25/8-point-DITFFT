`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2026 13:29:07
// Design Name: 
// Module Name: FFT_FSM
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


module FFT_FSM(
    input clk,
    input rst,
    input start,
    
    input signed [15:0] data_in_real,
    input signed [15:0] data_in_imag,
    input valid_in,
    
    output reg signed [15:0] data_out_real,
    output reg signed [15:0] data_out_imag,
    output reg valid_out,
    output reg done
    );
    
    //Internal Memory
    reg signed [15:0] xr [0:7];
    reg signed [15:0] xi [0:7];
    
    //States
    reg [2:0] state;
    localparam IDLE = 0,
              LOAD = 1,
              STAGE1 = 2,
              STAGE2 = 3,
              STAGE3 = 4,
              OUTPUT = 5,
              DONE = 6;
              
    //Counters
    reg [2:0] count;
    reg [2:0] out_cnt;
    
    //pipeline control
    reg [1:0] pipe_state;
    
    //temp register
    reg signed [15:0] temp_real, temp_imag;
    reg signed [15:0] xr_i_old, xi_i_old;
    
    //Mult pipeline regs
    reg signed [15:0] a,b;
    reg signed [31:0] p1,p2,p3,p4;
    
    //Twiddle factors
    localparam signed [15:0] W0R = 16'sd32767, W0I = 16'sd0;
    localparam signed [15:0] W1R = 16'sd23170, W1I = -16'sd23170;
    localparam signed [15:0] W2R = 16'sd0, W2I = -16'sd32767;
    localparam signed [15:0] W3R = -16'sd23170, W3I = -16'sd23170;
    
    reg signed [15:0] Wr, Wi;
    
    integer i;
    
    //FSM
    always@(posedge clk or posedge rst)
    begin
    if(rst) begin
            state<=IDLE; count<=0; out_cnt<=0; pipe_state<=0;
            valid_out<=0; done<=0;
            for(i=0;i<8;i=i+1) begin xr[i]<=0; xi[i]<=0; end
        end else begin
    
        case(state)
    
        IDLE: begin done<=0; if(start) state<=LOAD; end
    
        LOAD: begin
            if(valid_in) begin
                xr[count]<=data_in_real;
                xi[count]<=data_in_imag;
                if(count==7) begin count<=0; pipe_state<=0; state<=STAGE1; end
                else count<=count+1;
            end
        end
        
       STAGE1: begin
                case(pipe_state)
                0: begin
                    xr_i_old<=xr[count]; xi_i_old<=xi[count];
                    a<=xr[count+1]; b<=xi[count+1];
                    pipe_state<=3; // skip mult pipeline
                end
                3: begin
                    temp_real<=a; temp_imag<=b;
                    xr[count]   <= xr_i_old + temp_real;
                    xi[count]   <= xi_i_old + temp_imag;
                    xr[count+1] <= xr_i_old - temp_real;
                    xi[count+1] <= xi_i_old - temp_imag;
                    pipe_state<=0;
                    if(count==6) begin count<=0; state<=STAGE2; end
                    else count<=count+2;
                end
                default: pipe_state<=0;
                endcase
            end
        
            // -------- STAGE2 --------
            STAGE2: begin
                case(pipe_state)
                0: begin
                    xr_i_old<=xr[count]; xi_i_old<=xi[count];
                    a<=xr[count+2]; b<=xi[count+2];
                    if(count[0]==0) begin Wr<=W0R; Wi<=W0I; end
                    else begin Wr<=W2R; Wi<=W2I; end
                    pipe_state<=1;
                end
                1: begin
                    p1<=a*Wr; p2<=b*Wi; p3<=a*Wi; p4<=b*Wr;
                    pipe_state<=2;
                end
                2: begin
                    temp_real <= (p1 - p2) >>> 15;
                    temp_imag <= (p3 + p4) >>> 15;
                    pipe_state<=3;
                end
                3: begin
                    xr[count]   <= xr_i_old + temp_real;
                    xi[count]   <= xi_i_old + temp_imag;
                    xr[count+2] <= xr_i_old - temp_real;
                    xi[count+2] <= xi_i_old - temp_imag;
                    pipe_state<=0;
                    if(count==5) begin count<=0; state<=STAGE3; end
                    else count<=count+1;
                end
                endcase
            end
            STAGE3: begin
                    case(pipe_state)
                    0: begin
                        xr_i_old<=xr[count]; xi_i_old<=xi[count];
                        a<=xr[count+4]; b<=xi[count+4];
                        case(count)
                            0: begin Wr<=W0R; Wi<=W0I; end
                            1: begin Wr<=W1R; Wi<=W1I; end
                            2: begin Wr<=W2R; Wi<=W2I; end
                            3: begin Wr<=W3R; Wi<=W3I; end
                        endcase
                        pipe_state<=1;
                    end
                    1: begin
                        p1<=a*Wr; p2<=b*Wi; p3<=a*Wi; p4<=b*Wr;
                        pipe_state<=2;
                    end
                    2: begin
                        temp_real <= (p1 - p2) >>> 15;
                        temp_imag <= (p3 + p4) >>> 15;
                        pipe_state<=3;
                    end
                    3: begin
                        xr[count]   <= xr_i_old + temp_real;
                        xi[count]   <= xi_i_old + temp_imag;
                        xr[count+4] <= xr_i_old - temp_real;
                        xi[count+4] <= xi_i_old - temp_imag;
                        pipe_state<=0;
                        if(count==3) begin count<=0; out_cnt<=0; state<=OUTPUT; end
                        else count<=count+1;
                    end
                    endcase
                end
            
                OUTPUT: begin
                    data_out_real<=xr[out_cnt];
                    data_out_imag<=xi[out_cnt];
                    valid_out<=1;
                    if(out_cnt==7) state<=DONE;
                    else out_cnt<=out_cnt+1;
                end
            
                DONE: begin
                    valid_out<=0; done<=1; state<=IDLE;
                end
            
                default: state<=IDLE;
                endcase
            
                end
            end
endmodule
