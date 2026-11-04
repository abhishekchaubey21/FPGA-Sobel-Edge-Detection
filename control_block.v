`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2026 12:19:30 PM
// Design Name: 
// Module Name: control_block
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


module control_block #
(
  IMAGE_WIDTH = 512,
  IW_BIT_NUM = 9
)
(
    input clk,
    input reset,
    input [7:0] data_in_pixel,
    input data_in_valid,
    output reg [71:0] data_out_box,
    output data_out_box_valid,
    output reg row_req_intr
    );
 

reg [3:0] buffer_in_valid, buffer_out_read;
wire [23:0] data_out_3pixel_1, data_out_3pixel_2, data_out_3pixel_3,data_out_3pixel_4;



//Write operation
reg [IW_BIT_NUM-1:0] write_data_reg, write_data_next;
    always@(posedge clk)
    begin
        if (reset)
            write_data_reg <= 0;
        else
            write_data_reg <= write_data_next;
    end
    always@(*)
    begin
        write_data_next = write_data_reg;
        if(data_in_valid)
            write_data_next = write_data_reg + 9'd1;
    end
   
   reg [1:0] wr_buffer_reg, wr_buffer_next;
   always@(posedge clk)
   begin
       if(reset)
         wr_buffer_reg <= 0;
       else 
        wr_buffer_reg <= wr_buffer_next;
   end 
   always@(*)
   begin
        wr_buffer_next = wr_buffer_reg;
        if((write_data_reg == IMAGE_WIDTH-1) & data_in_valid )
          wr_buffer_next = wr_buffer_reg+1;  
   end
    
  always@(*)
  begin
    buffer_in_valid = 0;
    buffer_in_valid[wr_buffer_reg] = data_in_valid;
  end  
  
  
 // Read Operation from Buffer
 reg rd_data_buffer =0; // Needs to be generated later
 reg [IW_BIT_NUM-1:0] read_data_reg, read_data_next;
    always@(posedge clk)
    begin
        if (reset)
            read_data_reg <= 0;
        else
            read_data_reg <= read_data_next;
    end
    always@(*)
    begin
        read_data_next = read_data_reg;
        if(rd_data_buffer)
            read_data_next = read_data_reg + 9'd1;
    end
   
   reg [1:0] rd_buffer_reg, rd_buffer_next;
   always@(posedge clk)
   begin
       if(reset)
         rd_buffer_reg <= 0;
       else 
        rd_buffer_reg <= rd_buffer_next;
   end 
   always@(*)
   begin
        rd_buffer_next = rd_buffer_reg;
        if((read_data_reg == IMAGE_WIDTH-1) & rd_data_buffer)
          rd_buffer_next = rd_buffer_reg+1;  
   end
 
 always@(*)
 begin 
    if(rd_buffer_reg == 0)
        buffer_out_read = {1'b0,rd_data_buffer,rd_data_buffer,rd_data_buffer};
    else if (rd_buffer_reg == 1)
        buffer_out_read = {rd_data_buffer,rd_data_buffer,rd_data_buffer,1'b0};
    else if (rd_buffer_reg == 2)
        buffer_out_read = {rd_data_buffer,rd_data_buffer,1'b0,rd_data_buffer};
    else
        buffer_out_read = {rd_data_buffer,1'b0,rd_data_buffer,rd_data_buffer};
 end
 
 always@(*)
 begin
    if(rd_buffer_reg ==0)
        data_out_box = {data_out_3pixel_3,data_out_3pixel_2,data_out_3pixel_1};
    else if(rd_buffer_reg ==1)
        data_out_box = {data_out_3pixel_4,data_out_3pixel_3,data_out_3pixel_2};
    else if(rd_buffer_reg ==2)
        data_out_box = {data_out_3pixel_1,data_out_3pixel_4,data_out_3pixel_3};
    else
        data_out_box = {data_out_3pixel_2,data_out_3pixel_1,data_out_3pixel_4};
 end
 
 // FSM logic to generate rd_data_buffer flag
 reg [IW_BIT_NUM-1+3:0] buffer_data_count_reg, buffer_data_count_next;
 always@(posedge clk)
 begin
    if(reset)
        buffer_data_count_reg <= 0;
    else
        buffer_data_count_reg <= buffer_data_count_next;
 end
 
 always@(*)
 begin
    buffer_data_count_next = buffer_data_count_reg;
    if(data_in_valid & !rd_data_buffer)
        buffer_data_count_next = buffer_data_count_reg +1;
    else if (!data_in_valid & rd_data_buffer)
        buffer_data_count_next = buffer_data_count_reg - 1;
 end
 
 reg present_state, next_state;
 localparam IDLE = 1'b0, RD_DATA = 1'b1;
 always@(posedge clk)
 begin
    if(reset)
        present_state <= IDLE;
    else
        present_state <= next_state;
 end
 
 always@(*)
 begin
    next_state = present_state;
    if(present_state == IDLE)
        if (buffer_data_count_reg >= (IMAGE_WIDTH*3))
            next_state = RD_DATA;
        else
            next_state = IDLE;
    else
        if(read_data_reg == (IMAGE_WIDTH-1))
            next_state = IDLE;
        else
            next_state = RD_DATA;
 end
 

 always@(*)
 begin
    if(present_state == IDLE)
        if (buffer_data_count_reg >= IMAGE_WIDTH*3)
            rd_data_buffer = 1'b1;
        else
            rd_data_buffer = 1'b0;
    else
         if(read_data_reg == IMAGE_WIDTH - 1)
            rd_data_buffer = 1'b0;
         else
            rd_data_buffer = 1'b1;
 end
 
    
 always@(*)
 begin
    row_req_intr = 0;
    if (present_state == RD_DATA)
         if(read_data_reg == IMAGE_WIDTH - 1)
            row_req_intr = 1;
 end  
 

 
 assign data_out_box_valid = rd_data_buffer;
 
data_buffer #
(
  IMAGE_WIDTH,
  IW_BIT_NUM
)
DB1
(
    .clk(clk),
    .reset(reset),
    .data_in_pixel(data_in_pixel),
    .data_in_valid(buffer_in_valid[0]),
    .data_out_3pixel(data_out_3pixel_1),
    .data_out_read(buffer_out_read[0])
    );
  
 data_buffer #
(
  IMAGE_WIDTH,
  IW_BIT_NUM
)
DB2
(
    .clk(clk),
    .reset(reset),
    .data_in_pixel(data_in_pixel),
    .data_in_valid(buffer_in_valid[1]),
    .data_out_3pixel(data_out_3pixel_2),
    .data_out_read(buffer_out_read[1])
    );     
    
 data_buffer #
(
  IMAGE_WIDTH,
  IW_BIT_NUM
)
DB3
(
    .clk(clk),
    .reset(reset),
    .data_in_pixel(data_in_pixel),
    .data_in_valid(buffer_in_valid[2]),
    .data_out_3pixel(data_out_3pixel_3),
    .data_out_read(buffer_out_read[2])
    ); 
       
 data_buffer #
(
  IMAGE_WIDTH,
  IW_BIT_NUM
)
DB4
(
    .clk(clk),
    .reset(reset),
    .data_in_pixel(data_in_pixel),
    .data_in_valid(buffer_in_valid[3]),
    .data_out_3pixel(data_out_3pixel_4),
    .data_out_read(buffer_out_read[3])
    ); 
endmodule
