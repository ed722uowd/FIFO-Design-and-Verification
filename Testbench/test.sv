`include "environment.sv"
class test;
  
  environment env;
  
  virtual w_intf w_vif;
  virtual r_intf r_vif;
  
  function new(virtual w_intf w_vif, virtual r_intf r_vif );
    env = new(w_vif, r_vif);
    this.w_vif = w_vif;
    this.r_vif = r_vif;
  endfunction
  
  task start();
    env.start();
  endtask
  
endclass