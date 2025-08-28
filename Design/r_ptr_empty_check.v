// Code your design here
//parameter ADDR_WIDTH = 4;
module r_ptr_empty_check(
  input reg [ADDR_WIDTH:0] rq2_wptr,
  input r_inc,
  input r_clk,
  input r_reset,
  output [ADDR_WIDTH-1:0] r_addr,
  output reg [ADDR_WIDTH:0] r_ptr,
  output reg r_empty
  
);
  
  reg [ADDR_WIDTH:0] r_bin_ptr;
  wire[ADDR_WIDTH:0] r_bin_next_ptr, r_gray_next_ptr;
  wire int_r_empty;
  
  assign r_addr = r_bin_ptr[ADDR_WIDTH-1:0];
  assign r_bin_next_ptr = r_bin_ptr + (r_inc & ~r_empty);
  assign r_gray_next_ptr = r_bin_next_ptr ^(r_bin_next_ptr >>1);
  assign int_r_empty = (r_gray_next_ptr == rq2_wptr );
  
  always @(posedge r_clk or posedge r_reset) begin
    if(!r_reset)begin
      r_empty <= int_r_empty;
      r_bin_ptr <= r_bin_next_ptr;
      r_ptr <= r_gray_next_ptr;
      end
    
    else begin
      r_empty <=1;
      r_bin_ptr <=0;
      r_ptr<=0;
    end
  end
endmodule