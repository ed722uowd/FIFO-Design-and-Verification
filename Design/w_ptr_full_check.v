//parameter ADDR_WIDTH = 4;
module w_ptr_full_check(
  input reg [ADDR_WIDTH:0] wq2_rptr,
  input w_inc,
  input w_clk,
  input w_reset,
  output [ADDR_WIDTH-1:0] w_addr,
  output reg [ADDR_WIDTH:0] w_ptr,
  output reg w_full
  
);
  
  reg [ADDR_WIDTH:0] w_bin_ptr;
  wire[ADDR_WIDTH:0] w_bin_next_ptr, w_gray_next_ptr;
  wire int_w_full;
  
  assign w_addr = w_bin_ptr[ADDR_WIDTH-1:0];
  assign w_bin_next_ptr = w_bin_ptr + (w_inc & ~w_full);
  assign w_gray_next_ptr = w_bin_next_ptr ^(w_bin_next_ptr >>1);
  /*
  assign int_w_full = ({~w_gray_next_ptr[ADDR_WIDTH],
                        (w_gray_next_ptr[ADDR_WIDTH]^ w_gray_next_ptr[ADDR_WIDTH-1]),
                        w_gray_next_ptr[ADDR_WIDTH-2:0]} ==
                       wq2_rptr );
                       */
  assign int_w_full = ({~w_gray_next_ptr[ADDR_WIDTH],
                        (w_gray_next_ptr[ADDR_WIDTH]^ w_gray_next_ptr[ADDR_WIDTH-1]),
                        w_gray_next_ptr[ADDR_WIDTH-2:0]} ==
                       {wq2_rptr[ADDR_WIDTH],
                      (wq2_rptr[ADDR_WIDTH]^ wq2_rptr[ADDR_WIDTH-1]),
                        wq2_rptr[ADDR_WIDTH-2:0]});
  
  always @(posedge w_clk or posedge w_reset) begin
    if(!w_reset)begin
      w_full <= int_w_full;
      w_bin_ptr <= w_bin_next_ptr;
      w_ptr <= w_gray_next_ptr;
      end
    
    else begin
      w_full <=1;
      w_bin_ptr <=0;
      w_ptr<=0;
    end
  end
  
  
  
endmodule