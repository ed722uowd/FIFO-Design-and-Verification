parameter ADDR_WIDTH = 4;
parameter DATA_WIDTH = 4;

`include "w_ptr_full_check.v"
`include "r_ptr_empty_check.v"
`include "synchronizer.v"
`include "fifo_mem.v"
`include "package.sv"
//`include "w_ptr_full_assert.sv"


module FIFO_top (
  input [DATA_WIDTH-1 : 0] w_data,
  input 				   w_inc,
  input					   w_clk,
  input					   w_reset,
  input 				   r_inc,
  input					   r_clk,
  input					   r_reset,
  
  output				   w_full,
  output				   r_empty,
  
  output [DATA_WIDTH-1 : 0] r_data
);
  
  wire [ADDR_WIDTH-1 : 0] w_addr;
  wire [ADDR_WIDTH : 0]   w_ptr;
  wire [ADDR_WIDTH : 0]   wq2_rptr;
  
  wire [ADDR_WIDTH-1 : 0] r_addr;
  wire [ADDR_WIDTH : 0]   r_ptr;
  wire [ADDR_WIDTH : 0]   rq2_wptr;
  
  wire w_clk_en;
  assign w_clk_en = ~w_full & w_inc;
  
  FIFO_mem fifo (
    .w_data(w_data),
    .w_clk_en(w_clk_en),
    .w_addr(w_addr),
    .w_clk(w_clk),
    .r_addr(r_addr),
    .r_data(r_data)
  );
  
  w_ptr_full_check w_ptr_check(
    .wq2_rptr(wq2_rptr),
    .w_inc(w_inc),
    .w_clk(w_clk),
    .w_reset(w_reset),
    .w_addr(w_addr),
    .w_ptr(w_ptr),
    .w_full(w_full)
  );
  
  r_ptr_empty_check r_ptr_check(
    .rq2_wptr(rq2_wptr),
    .r_inc(r_inc),
    .r_clk(r_clk),
    .r_reset(r_reset),
    .r_addr(r_addr),
    .r_ptr(r_ptr),
    .r_empty(r_empty)
  );
  
  sync r2w(
    .ptr(r_ptr),
    .clk(w_clk),
    .reset(w_reset),
    .out_ptr(wq2_rptr)
  );
  
  sync w2r(
    .ptr(w_ptr),
    .clk(r_clk),
    .reset(r_reset),
    .out_ptr(rq2_wptr)
  );
 


endmodule