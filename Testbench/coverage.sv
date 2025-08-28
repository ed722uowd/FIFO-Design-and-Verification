
class fifo_coverage;

  // Signals to track
  logic w_inc, w_full;
  logic r_inc, r_empty;
  logic w_reset, r_reset;
  
  virtual w_intf w_vif;
  virtual r_intf r_vif;
  
  function new(virtual w_intf w_vif, virtual r_intf r_vif);
    
    
    this.w_vif = w_vif;
    this.r_vif = r_vif;
    
    w_cg = new();
    r_cg = new();
  endfunction
  
  task start();
    
    forever begin
          if (test_done == 1) begin
            break;
          end
      fork
        begin
          @(posedge w_vif.w_clk);
          w_inc = w_vif.w_inc;
          w_full = w_vif.w_full;
          w_reset = w_vif.w_reset;
        end
        
        begin
          @(posedge r_vif.r_clk);
          r_inc = r_vif.r_inc;
          r_empty = r_vif.r_empty;
          r_reset = r_vif.r_reset;
        end
    
      join_any
    end
  endtask
  
  covergroup r_cg @(posedge r_vif.r_clk); 
    r_inc_cp   : coverpoint r_inc;
    r_empty_cp : coverpoint r_empty;
    r_reset_cp : coverpoint r_reset;
  endgroup
  
  covergroup w_cg @(posedge w_vif.w_clk); 
    w_inc_cp  : coverpoint w_inc;
    w_full_cp : coverpoint w_full;
    w_reset_cp : coverpoint w_reset;
  endgroup
  
endclass
