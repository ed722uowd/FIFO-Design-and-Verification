import tb_4_states::*;

class w_generator;
  
  mailbox #(w_transaction) w_gen2drv;
  
  virtual w_intf w_vif;
  
  function new(mailbox #(w_transaction) w_gen2drv, virtual w_intf w_vif);
    this.w_gen2drv = w_gen2drv;
    this.w_vif = w_vif;
  endfunction
  
  task start();
    
    forever begin     
      
      if (test_done == 1) begin
        break;
      end
      else begin
        w_transaction w_p2 = new();
        if (!w_p2.randomize())
        $fatal("Randomization failed for w_transaction");
        w_gen2drv.put(w_p2);
        @(w_vif.cb_w_intf);
      end
        
    end
    
  endtask
  
endclass

class r_generator;
  
  mailbox #(r_transaction) r_gen2drv;
  
  virtual r_intf r_vif;
  
  function new(mailbox #(r_transaction) r_gen2drv, virtual r_intf r_vif);
    this.r_gen2drv = r_gen2drv;
    this.r_vif = r_vif;
  endfunction
  
  task start();
    
    forever begin     
      
      if (test_done == 1) begin
        break;
      end
      else begin

        r_transaction r_p2 = new();
        if (!r_p2.randomize())
          $fatal("Randomization failed for r_transaction");
        r_gen2drv.put(r_p2);
        @(r_vif.cb_r_intf);
      end
        
    end
    
  endtask
  
endclass

class w_data_generator;
  
  mailbox #(w_data_f) d_gen2drv;
  
  virtual w_intf w_vif;
  
  function new(mailbox #(w_data_f) d_gen2drv, virtual w_intf w_vif);
    this.d_gen2drv = d_gen2drv;
    this.w_vif = w_vif;
  endfunction
  
  task start();
    
    forever begin     
      
      if (test_done == 1) begin
        break;
      end
      else begin
        w_data_f d_p2 =new();
        if (!d_p2.randomize())
          $fatal("Randomization failed for w_data");
        d_gen2drv.put (d_p2);
        @(w_vif.cb_w_intf);
      end
        
    end
    
  endtask
  
endclass