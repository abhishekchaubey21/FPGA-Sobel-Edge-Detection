`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2026 09:46:51 AM
// Design Name: 
// Module Name: top_imagep
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


module top_imagep #
(
  IMAGE_WIDTH = 512,
  IW_BIT_NUM = 9
)
(
    input clk,
    input reset_n,
    input [7:0] s_data,
    input s_data_valid,
    output s_data_ready,
    
    output [7:0] m_data,
    output m_data_valid,
    input m_data_ready,
    
    output row_req_intr
    );
    
 wire [71:0] data_box; 
 wire data_box_valid; 
 control_block #
(
  IMAGE_WIDTH,
  IW_BIT_NUM
)
cd
(
    .clk(clk),
    .reset(!reset_n),
    .data_in_pixel(s_data),
    .data_in_valid(s_data_valid),
    .data_out_box(data_box),
    .data_out_box_valid(data_box_valid),
    .row_req_intr(row_req_intr)
    );
 wire [7:0] mult_acm_data;
 wire mult_acm_valid;
 mult_acm_sobel ma(
    .clk(clk),
    .reset(!reset_n),
    .data_in_box(data_box),
    .data_in_valid(data_box_valid),
    .data_out_pixel(mult_acm_data),
    .data_out_valid(mult_acm_valid)
    );
   
   wire axis_prog_full;
   fifo_generator_0 ff (
  .wr_rst_busy(),        // output wire wr_rst_busy
  .rd_rst_busy(),        // output wire rd_rst_busy
  .s_aclk(clk),                  // input wire s_aclk
  .s_aresetn(reset_n),            // input wire s_aresetn
  .s_axis_tvalid(mult_acm_valid),    // input wire s_axis_tvalid
  .s_axis_tready(),    // output wire s_axis_tready
  .s_axis_tdata(mult_acm_data),      // input wire [7 : 0] s_axis_tdata
  .m_axis_tvalid(m_data_valid),    // output wire m_axis_tvalid
  .m_axis_tready(m_data_ready),    // input wire m_axis_tready
  .m_axis_tdata(m_data),      // output wire [7 : 0] m_axis_tdata
  .axis_prog_full(axis_prog_full)  // output wire axis_prog_full
);

assign s_data_ready = !axis_prog_full;
    
endmodule