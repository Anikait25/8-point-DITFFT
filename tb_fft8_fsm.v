`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2026 22:02:34
// Design Name: 
// Module Name: tb_fft8_fsm
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


module tb_fft8_fsm;

//////////////////////////////////////////////////////
// DUT Signals
//////////////////////////////////////////////////////

reg clk;
reg rst;
reg start;

reg signed [15:0] data_in_real;
reg signed [15:0] data_in_imag;
reg valid_in;

wire signed [15:0] data_out_real;
wire signed [15:0] data_out_imag;
wire valid_out;
wire done;

//////////////////////////////////////////////////////
// Instantiate DUT
//////////////////////////////////////////////////////

FFT_FSM dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in_real(data_in_real),
    .data_in_imag(data_in_imag),
    .valid_in(valid_in),
    .data_out_real(data_out_real),
    .data_out_imag(data_out_imag),
    .valid_out(valid_out),
    .done(done)
);

  
  always@(posedge clk)
begin
  $display("STATE=%0d start=%0d count=%0d out=%0d valid_out=%b",
              dut.state, dut.start, dut.count, dut.out_cnt, valid_out);
end

always@(posedge clk)
begin
if(valid_out) begin
$display("OUT[%0d] = %d + j%d", dut.out_cnt, data_out_real, data_out_imag);
end
end
//////////////////////////////////////////////////////
// Clock Generation (10ns period)
//////////////////////////////////////////////////////
initial
clk = 0;
always #5 clk = ~clk;
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0,tb_fft8_fsm);
end

initial begin
    rst = 1;
    #30;
    rst = 0;
  	@(posedge clk)
    start = 1;
  	//@(posedge clk)
  	//start = 0;
    @(posedge clk)
    data_in_real = 1; data_in_imag = 0; valid_in = 1;
    #10;//@(posedge clk)
    valid_in = 0;
    //@(posedge clk)
    #20;
    data_in_real = 1; data_in_imag = 0; valid_in = 1;
    #10;//@(posedge clk)
    valid_in = 0; 
    //@(posedge clk)
    #20;
    data_in_real = 1; data_in_imag = 0; valid_in = 1;
    #10;//@(posedge clk)
    valid_in = 0; 
    //@(posedge clk)
    #20;
    data_in_real = 1; data_in_imag = 0; valid_in = 1;
    #10;//@(posedge clk)
    valid_in = 0; 
    #20;//@(posedge clk)
    data_in_real = 1; data_in_imag = 0; valid_in = 1;
    #10;//@(posedge clk)
    valid_in = 0; 
    #20;//@(posedge clk)
    data_in_real = 1; data_in_imag = 0; valid_in = 1;
    #10;//@(posedge clk)
    valid_in = 0; 
    #20;//@(posedge clk)
    data_in_real = 1; data_in_imag = 0; valid_in = 1;
    #10;//@(posedge clk)
    valid_in = 0; 
    #20;//@(posedge clk)
    data_in_real = 1; data_in_imag = 0; valid_in = 1;
    #10;//@(posedge clk)
    valid_in = 0; 
    #20;
  wait(done);
    #50;
    $finish;
end
endmodule

