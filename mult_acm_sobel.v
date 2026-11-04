`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2026 03:43:37 PM
// Design Name: 
// Module Name: mult_acm_sobel
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


module mult_acm_sobel(
    input clk,
    input reset,
    input [71:0] data_in_box,
    input data_in_valid,
    output reg [7:0] data_out_pixel,
    output reg data_out_valid
    );
    
    reg [7:0] filt_coeff_1 [8:0];
    initial 
    begin
        filt_coeff_1[0] = 1;
        filt_coeff_1[1] = 0;
        filt_coeff_1[2] = -1;
        filt_coeff_1[3] = 2;
        filt_coeff_1[4] = 0;
        filt_coeff_1[5] = -2;
        filt_coeff_1[6] = 1;
        filt_coeff_1[7] = 0;
        filt_coeff_1[8] = -1;   
    end
    
    reg [7:0] filt_coeff_2 [8:0];
    initial 
    begin
        filt_coeff_2[0] = 1;
        filt_coeff_2[1] = 2;
        filt_coeff_2[2] = 1;
        filt_coeff_2[3] = 0;
        filt_coeff_2[4] = 0;
        filt_coeff_2[5] = 0;
        filt_coeff_2[6] = -1;
        filt_coeff_2[7] = -2;
        filt_coeff_2[8] = -1;   
    end
    
    reg [15:0] mult_data_reg_1 [8:0];
    reg [15:0] mult_data_next_1 [8:0];
    reg [15:0] mult_data_reg_2 [8:0];
    reg [15:0] mult_data_next_2 [8:0];
    reg mult_data_valid;
    
    always@(posedge clk)
    begin
        mult_data_reg_1[0] <= mult_data_next_1[0];
        mult_data_reg_1[1] <= mult_data_next_1[1];
        mult_data_reg_1[2] <= mult_data_next_1[2];
        mult_data_reg_1[3] <= mult_data_next_1[3];
        mult_data_reg_1[4] <= mult_data_next_1[4];
        mult_data_reg_1[5] <= mult_data_next_1[5];
        mult_data_reg_1[6] <= mult_data_next_1[6];
        mult_data_reg_1[7] <= mult_data_next_1[7];
        mult_data_reg_1[8] <= mult_data_next_1[8];
    end
     always@(posedge clk)
    begin
        mult_data_reg_2[0] <= mult_data_next_2[0];
        mult_data_reg_2[1] <= mult_data_next_2[1];
        mult_data_reg_2[2] <= mult_data_next_2[2];
        mult_data_reg_2[3] <= mult_data_next_2[3];
        mult_data_reg_2[4] <= mult_data_next_2[4];
        mult_data_reg_2[5] <= mult_data_next_2[5];
        mult_data_reg_2[6] <= mult_data_next_2[6];
        mult_data_reg_2[7] <= mult_data_next_2[7];
        mult_data_reg_2[8] <= mult_data_next_2[8];
    end
    
    always@(*)
    begin
        mult_data_next_1[0] = $signed(filt_coeff_1[0])*$signed(data_in_box[7:0]);
        mult_data_next_1[1] = $signed(filt_coeff_1[1])*$signed(data_in_box[15:8]);
        mult_data_next_1[2] = $signed(filt_coeff_1[2])*$signed(data_in_box[23:16]);
        mult_data_next_1[3] = $signed(filt_coeff_1[3])*$signed(data_in_box[31:24]);
        mult_data_next_1[4] = $signed(filt_coeff_1[4])*$signed(data_in_box[39:32]);
        mult_data_next_1[5] = $signed(filt_coeff_1[5])*$signed(data_in_box[47:40]);
        mult_data_next_1[6] = $signed(filt_coeff_1[6])*$signed(data_in_box[55:48]);
        mult_data_next_1[7] = $signed(filt_coeff_1[7])*$signed(data_in_box[63:56]);
        mult_data_next_1[8] = $signed(filt_coeff_1[8])*$signed(data_in_box[71:64]);
    end
    always@(*)
    begin
        mult_data_next_2[0] = $signed(filt_coeff_2[0])*$signed(data_in_box[7:0]);
        mult_data_next_2[1] = $signed(filt_coeff_2[1])*$signed(data_in_box[15:8]);
        mult_data_next_2[2] = $signed(filt_coeff_2[2])*$signed(data_in_box[23:16]);
        mult_data_next_2[3] = $signed(filt_coeff_2[3])*$signed(data_in_box[31:24]);
        mult_data_next_2[4] = $signed(filt_coeff_2[4])*$signed(data_in_box[39:32]);
        mult_data_next_2[5] = $signed(filt_coeff_2[5])*$signed(data_in_box[47:40]);
        mult_data_next_2[6] = $signed(filt_coeff_2[6])*$signed(data_in_box[55:48]);
        mult_data_next_2[7] = $signed(filt_coeff_2[7])*$signed(data_in_box[63:56]);
        mult_data_next_2[8] = $signed(filt_coeff_2[8])*$signed(data_in_box[71:64]);
    end
    always@(posedge clk)
        mult_data_valid <= data_in_valid;
        
    
    reg [15:0] aggr_data_reg1, aggr_data_next1,aggr_data_reg2,aggr_data_next2;
    reg aggr_data_valid;
    always@(posedge clk)
    begin
        aggr_data_reg1 <= aggr_data_next1;
        aggr_data_reg2 <= aggr_data_next2;
    end
    
    always@(*)
        aggr_data_next1 = $signed(mult_data_reg_1[0]) + $signed(mult_data_reg_1[1])+ 
                         $signed(mult_data_reg_1[2]) + $signed(mult_data_reg_1[3])+
                         $signed(mult_data_reg_1[4]) +$signed(mult_data_reg_1[5])+
                         $signed(mult_data_reg_1[6]) + $signed(mult_data_reg_1[7])+
                         $signed(mult_data_reg_1[8]);
                         
     always@(*)
        aggr_data_next2 = $signed(mult_data_reg_2[0]) + $signed(mult_data_reg_2[1])+ 
                         $signed(mult_data_reg_2[2]) + $signed(mult_data_reg_2[3])+
                         $signed(mult_data_reg_2[4]) +$signed(mult_data_reg_2[5])+
                         $signed(mult_data_reg_2[6]) + $signed(mult_data_reg_2[7])+
                         $signed(mult_data_reg_2[8]);
    always@(posedge clk)
        aggr_data_valid <= mult_data_valid;
     
    reg [15:0] sqr_data_reg_1, sqr_data_reg_2, sqr_data_next_1, sqr_data_next_2;
    reg sq_data_valid;
    always@(posedge clk)
    begin
        sqr_data_reg_1 <= sqr_data_next_1;
        sqr_data_reg_2 <= sqr_data_next_2;
    end   
    
    always@(*)
    begin
        sqr_data_next_1 = $signed(aggr_data_reg1)*$signed(aggr_data_reg1);
    end
    always@(*)
    begin
        sqr_data_next_2 = $signed(aggr_data_reg2)*$signed(aggr_data_reg2);
    end
    always@(posedge clk)
        sq_data_valid <= aggr_data_valid;
        
    reg [7:0] data_out_pixel_next;
    always@(posedge clk)
        data_out_pixel <= data_out_pixel_next;
        
    always@(*)
        data_out_pixel_next = $signed(sqr_data_reg_1)+$signed(sqr_data_reg_2) > 'd4000 ? 8'hFF : 8'h00;
       
    always@(posedge clk)
         data_out_valid <= sq_data_valid;
endmodule
