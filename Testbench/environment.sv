`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"

import tb_4_states::*;

class environment;  
  
  virtual w_intf w_vif;
  virtual r_intf r_vif;
  
  w_generator w_gen;
  r_generator r_gen;
  w_data_generator wd_gen;
  
  w_driver w_drv;
  r_driver r_drv;
  
  monitor mon;
  scoreboard scb;
  
  fifo_coverage cov;
  
  mailbox #(w_transaction) w_gen2drv;
  mailbox #(r_transaction) r_gen2drv;
  mailbox #(w_data_f) d_gen2drv;
  
  mailbox #(w_transaction) w_mon2scb;
  mailbox #(r_transaction) r_mon2scb;
  mailbox #(w_data_f) d_mon2scb;
  
  function new(virtual w_intf w_vif, virtual r_intf r_vif);
    
    this.w_vif = w_vif;
    this.r_vif = r_vif;
    
    w_gen2drv = new();
    r_gen2drv = new();
    d_gen2drv = new();
    
    w_mon2scb = new();
    r_mon2scb = new();
    d_mon2scb = new(); 
    
    w_gen = new(w_gen2drv, w_vif);
    r_gen = new(r_gen2drv, r_vif);
    wd_gen = new(d_gen2drv, w_vif);
    
    w_drv = new(w_vif, w_gen2drv, d_gen2drv);
    r_drv = new(r_vif, r_gen2drv);
    
    mon = new(w_mon2scb, r_mon2scb, d_mon2scb, w_vif, r_vif);
    //mon = new(w_vif, r_vif);
    scb = new(w_mon2scb, r_mon2scb, d_mon2scb, w_vif, r_vif);
    
    cov = new(w_vif, r_vif);
    
  endfunction
  
  task start();
    fork
      w_gen.start();
      r_gen.start();
      wd_gen.start();
      
      w_drv.start();
      r_drv.start();
      
      mon.write_start();
      mon.read_start();
      
      scb.start();
      
      cov.start();
    join
  endtask
  
endclass