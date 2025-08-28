
class scoreboard;
  
  mailbox #(w_transaction) w_mon2scb;
  mailbox #(r_transaction) r_mon2scb;
  mailbox #(w_data_f) d_mon2scb;
  
  w_transaction w_pckt;
  r_transaction r_pckt;
  w_data_f     d_pckt;
  
  virtual w_intf w_vif;
  virtual r_intf r_vif;
  
  function new (mailbox #(w_transaction) w_mon2scb, mailbox #(r_transaction) r_mon2scb, mailbox #(w_data_f) d_mon2scb,
               virtual w_intf w_vif, virtual r_intf r_vif);
    this.w_mon2scb = w_mon2scb;
    this.r_mon2scb = r_mon2scb;
    this.d_mon2scb = d_mon2scb;
    
    this.w_vif = w_vif;
    this.r_vif = r_vif;
  endfunction
  
  logic [DATA_WIDTH - 1:0] read_data_q [$];
  logic [DATA_WIDTH - 1:0] written_data_q [$];
  logic [DATA_WIDTH - 1:0] write_data_q [$];
  
  extern task check_full_addr();
  extern task check_empty_addr();
  extern task data_written_fifo();
  extern task data_read_fifo();
  extern task print_state();
    
  tb_states current_state, previous_state;
   bit mismatch_found = 0;
  
  task start();
   
    
    forever begin
      @(posedge w_vif.w_clk); 

      print_state();

      if (test_done == 1)
        break;

      
      if (!w_mon2scb.try_get(w_pckt))
        continue;

      if (!d_mon2scb.try_get(d_pckt)) begin
        w_mon2scb.put(w_pckt); 
        continue;
      end

      data_written_fifo();
      check_full_addr();
      

      
      if (r_mon2scb.try_get(r_pckt)) begin
        data_read_fifo();
        check_empty_addr();
        
      end
    end

    
  endtask
   
endclass

task scoreboard::check_full_addr();
  if (w_pckt.w_full) begin
    $display("Fifo is full");
  end
endtask

task scoreboard::data_written_fifo();
  if (w_pckt.w_inc && !w_pckt.w_full) begin
    written_data_q.push_back(d_pckt.w_data);
  end
  else begin
    write_data_q.push_back(d_pckt.w_data);
  end
    
endtask

task scoreboard::data_read_fifo();
  if (r_pckt.r_inc && !r_pckt.r_empty) begin
    read_data_q.push_back(r_pckt.r_data);
  end
endtask

task scoreboard::check_empty_addr();
  if (r_pckt.r_empty) begin
    $display("Fifo is empty at time %0t", $time);

    if (read_data_q.size() == written_data_q.size()) begin
      mismatch_found = 0;

      for (int i = 0; i < read_data_q.size(); i++) begin
        if (read_data_q[i] !== written_data_q[i]) begin
          $display("Mismatch at index %0d: expected = %0h, actual = %0h",
                   i, written_data_q[i], read_data_q[i]);
          mismatch_found = 1;
        end else begin
          $display("Match at index %0d: value = %0h", i, read_data_q[i]);
        end
      end

      if (!mismatch_found)
        $display("All data matched at time %0t", $time);
      else
        $display("Mismatch detected at time %0t", $time);

      
      read_data_q.delete();
      written_data_q.delete();
    end else begin
      $display("Warning: Mismatch in read/write queue sizes at time %0t", $time);
      $display("Written: %0d, Read: %0d", written_data_q.size(), read_data_q.size());
    end
  end
endtask


task scoreboard::print_state();
  
  
  current_state = tb_state;
  //$display("Current state %s\n", previous_state);
  //$display("Current state %d\n", current_state != previous_state);
  
  if (current_state !== previous_state) begin
    $display("Current state %s", current_state);
    $display("time is %0t\n",$time); 
    current_state = previous_state;
  end
    
endtask