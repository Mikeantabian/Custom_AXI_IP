`timescale 1ns / 1ps


module counter(
    input logic aclk,
   input logic enable,
   input logic aresetn,
   input logic inc_dec,
   input logic [7:0] start_value,
   output logic [7:0] count_out
);
    
logic [7:0] count_next;
logic [7:0] prev_start_value;

always_ff @(posedge aclk or negedge aresetn)
   if (!aresetn) begin
       count_out <= start_value;
       prev_start_value <= start_value;
   end else begin
       if (prev_start_value != start_value) begin
           count_out <= start_value;
           prev_start_value <= start_value;
       end else if (enable) begin
           count_next = inc_dec ? count_out - 1 : count_out + 1;
           count_out <= count_next;
       end
   end

    
endmodule
