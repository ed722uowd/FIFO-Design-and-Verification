import tb_4_states::*;

class monitor;
  
  
  mailbox #(w_transaction) w_mon2scb;
  mailbox #(r_transaction) r_mon2scb;
  mailbox #(w_data_f) d_mon2scb;
  
  w_transaction w_pckt;
  r_transaction r_pckt;
  w_data_f dat;
  
  
  virtual w_intf w_vif;
  virtual r_intf r_vif;
  
  function new (mailbox #(w_transaction) w_mon2scb, mailbox #(r_transaction) r_mon2scb, mailbox #(w_data_f) d_mon2scb,
                virtual w_intf w_vif, virtual r_intf r_vif);
  //function new (virtual w_intf w_vif, virtual r_intf r_vif);
    
    this.w_mon2scb = w_mon2scb;
    this.r_mon2scb = r_mon2scb;
    this.d_mon2scb = d_mon2scb;
    
    
    this.w_vif = w_vif;
    this.r_vif = r_vif;
  endfunction
  
  task write_start();
    forever begin
      if (test_done == 1) begin
        break;
      end
      @(posedge w_vif.w_clk);
      dat = new();
      dat.w_data = w_vif.w_data;
      d_mon2scb.put(dat);

      w_pckt = new();
      w_pckt.w_inc = w_vif.w_inc;
      w_pckt.w_reset = w_vif.w_reset;
      w_pckt.w_full = w_vif.w_full;
      w_mon2scb.put(w_pckt);
    end
  endtask

  task read_start();
    forever begin
      if (test_done == 1) begin
        break;
      end
      @(posedge r_vif.r_clk);
      r_pckt = new();
      r_pckt.r_inc = r_vif.r_inc;
      r_pckt.r_reset = r_vif.r_reset;
      r_pckt.r_empty = r_vif.r_empty;
      r_pckt.r_data = r_vif.r_data;
      r_mon2scb.put(r_pckt);
    end
  endtask

endclass