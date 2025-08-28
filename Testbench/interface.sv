interface w_intf #(parameter DATA_WIDTH = 4) (input logic w_clk);
  
  logic [DATA_WIDTH-1 : 0] w_data;
  logic 				   w_inc;
  logic					   w_reset;  
  logic				       w_full;
  
  clocking cb_w_intf @(posedge w_clk);

    default input #1 output #1;
    input		w_full;
    inout	w_inc, w_reset, w_data;

  endclocking
    
endinterface


interface r_intf #(parameter DATA_WIDTH = 4)  (input logic r_clk);
  
  logic [DATA_WIDTH-1 : 0] r_data; 
  logic 				   r_inc;
  logic					   r_reset;
  logic				       r_empty;
  
  clocking cb_r_intf @(posedge r_clk);
  
    default input #1 output #1;
    input		r_empty, r_data;
    inout	r_inc, r_reset;

  endclocking
    
endinterface