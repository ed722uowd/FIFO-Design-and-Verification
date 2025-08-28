import tb_4_states::*;

class w_data_f;
  rand	logic [DATA_WIDTH-1 : 0] w_data;
endclass

class w_transaction;
  
  rand logic	 				   w_inc;
  logic					   w_reset;
  
  logic					   w_full;
  
  function void display ( string name);
    
    $display("__________ %s _________", name);
    $display("w_inc = %0b, w_reset = %0b,  w_full = %0b",w_inc,w_reset,w_full);
    $display(".......................");
    
  endfunction

endclass


class r_transaction;
  
  rand logic	 				   r_inc;
  logic					   r_reset;
  logic					   r_empty;
  logic [DATA_WIDTH-1 : 0] r_data;  
  
  
  function void display ( string name);
    
    $display("__________ %s _________", name);
    $display("r_data = %0b, r_inc = %0b, r_reset = %0b,  r_empty = %0b", r_data,r_inc,r_reset,r_empty);
    $display(".......................");
    
  endfunction

endclass