import tb_4_states::*;

class w_driver;
  
  virtual w_intf vif;
  mailbox #(w_transaction) w_gen2drv;
  mailbox #(w_data_f) d_gen2drv;
  w_transaction pckt;
  w_data_f dat;  
  
  //tb_states tb_state;
  
  extern task set_w_reset();
  extern task Rd_Wr();
  extern task Rand_Rd_Wr();
  extern task Reset_one();
  
    function new(virtual w_intf vif, mailbox #(w_transaction) w_gen2drv,
                 mailbox #(w_data_f) d_gen2drv);
    
    this.vif = vif;
    this.w_gen2drv = w_gen2drv;
    this.d_gen2drv= d_gen2drv;
    tb_state = RESET; 
    
  endfunction
  
  task start();
    
    
    fork
      begin
        forever
          begin
            if (test_done) break;
            d_gen2drv.get(dat);
            @(vif.cb_w_intf);
            vif.cb_w_intf.w_data <= dat.w_data;
          end
      end
      
      begin
        
        forever begin
          //$display("write state:  %s", tb_state);
          if (r_rand && w_rand) begin
            tb_state = Reset;
          end
          w_gen2drv.get(pckt);
          case (tb_state)
            RESET:		set_w_reset();
            R_W:		Rd_Wr();
            Rand_R_W:	Rand_Rd_Wr();
            Reset:		
              begin
                Reset_one();
                if (test_done == 1) begin
                  //$display("write break");
                  break;
                end
              end
          endcase

        end
      end
      
    join_any
    disable fork;
    
  endtask  
  
endclass


task w_driver::set_w_reset();
  
  
  
  if (w_reset_done == 0 ) begin
    //$display("Write reset state");
    vif.cb_w_intf.w_inc <= 0;
    vif.cb_w_intf.w_reset <= 0;
    @(vif.cb_w_intf);
    vif.cb_w_intf.w_reset <= 1;
    repeat (1) @(vif.cb_w_intf);
    vif.cb_w_intf.w_reset <= 0;
  end
  
  w_reset_done = 1;
  
endtask

task w_driver::Rd_Wr(); 
  
  //$display("Write read followed by write state, %d", w_fill_done);
  
  @(vif.cb_w_intf);
  if (vif.cb_w_intf.w_full) begin
    repeat (5) @(vif.cb_w_intf);
    vif.cb_w_intf.w_inc <= 0;
    w_fill_done = 1;
    //$display("filled ", w_fill_done);
  end
  else begin
    if (!w_fill_done) begin
    	vif.cb_w_intf.w_inc <= 1;
    end
    else
      begin
        vif.cb_w_intf.w_inc <= 0;
      end
  end 
  
endtask

task w_driver::Rand_Rd_Wr();
  
  //vif.cb_w_intf.w_data <= pckt.w_data;
  if (w_rand == 0) begin
    repeat(50) begin
      w_gen2drv.get(pckt);
      @(vif.cb_w_intf);
      vif.cb_w_intf.w_inc <= pckt.w_inc;
      vif.cb_w_intf.w_reset <= 0;
    end
    w_rand = 1;
  end
  
endtask

task w_driver::Reset_one();
  
  @(vif.cb_w_intf);
  if (w_reset) begin
    vif.cb_w_intf.w_inc <= pckt.w_inc;
    vif.cb_w_intf.w_reset <= 1;
    repeat (20) @(vif.cb_w_intf);
    vif.cb_w_intf.w_reset <= 0;
    w_reset_tst_done = 1;
  end
  else begin
    vif.cb_w_intf.w_inc <= pckt.w_inc;
    vif.cb_w_intf.w_reset <= 0;
    wait (r_reset_tst_done == 1);
    vif.cb_w_intf.w_inc <= pckt.w_inc;
    vif.cb_w_intf.w_reset <= 1;
    test_done = 1;
  end
  
  //$display("Write test_done: %d", test_done);
  
endtask












class r_driver;
  
  virtual r_intf vif;
  mailbox #(r_transaction) r_gen2drv;
  r_transaction pckt;
  
  //tb_states tb_state;
  
  extern task set_r_reset();
  extern task r_Rd_Wr();
  extern task r_Rand_Rd_Wr();
  extern task r_Reset_one();
  
  
    function new(virtual r_intf vif, mailbox #(r_transaction) r_gen2drv);
    
    this.vif = vif;
    this.r_gen2drv = r_gen2drv;
    tb_state = RESET;
    
  endfunction
    
  task start();
    
    
    
    forever begin
      
      //$display("read state:  %s", tb_state);
      if (r_rand && w_rand) begin
        tb_state = Reset;
      end
      r_gen2drv.get(pckt);
         
      case (tb_state)
        RESET:		set_r_reset();
        R_W:		r_Rd_Wr();
        Rand_R_W:	r_Rand_Rd_Wr();
        Reset:		
          begin
            //$display("write state:  %s", tb_state);
            r_Reset_one();
            if (test_done == 1) begin
              break;
            end
          end
      endcase
    
    end    
    
  endtask  
  
endclass

task r_driver::set_r_reset();
  
  //$display("w_reset_done  %d", w_reset_done);
    
  wait (w_reset_done == 1);
  //$display("w_reset_done  %d", w_reset_done);
  //$display("Read reset state");
  
  vif.cb_r_intf.r_inc <= 0;
  vif.cb_r_intf.r_reset <= 0;
  @(vif.cb_r_intf);
  vif.cb_r_intf.r_reset <= 1;
  @(vif.cb_r_intf);
  vif.cb_r_intf.r_reset <= 0;
  
  tb_state = R_W;
  
  //$display("state:  %s", tb_state);
  
endtask

task r_driver::r_Rd_Wr();
  
  
  wait(w_fill_done == 1);
  //$display("w_fill_done  %d", w_fill_done);
  
  @(vif.cb_r_intf);
  if (vif.cb_r_intf.r_empty) begin
    repeat (5) @(vif.cb_r_intf);
    vif.cb_r_intf.r_inc <= 0;
    //
    //$display("empty  %d", w_fill_done);
    if (w_fill_done == 1 && r_read_done == 0) begin
      w_fill_done = 0;
      r_read_done = 1;
    end
    //
    else if (r_read_done) begin
      tb_state = Rand_R_W;
    end
    //
    
    // /tb_state = Rand_R_W;
  end
  else begin
    //$display("incrementing read counter  %d", w_fill_done);
    vif.cb_r_intf.r_inc <= 1;
  end 
  
endtask
  
  
  
task r_driver::r_Rand_Rd_Wr();
  
  if (r_rand == 0) begin 
    repeat(50) begin
      r_gen2drv.get(pckt);
      @(vif.cb_r_intf);
      vif.cb_r_intf.r_inc <= pckt.r_inc;
      vif.cb_r_intf.r_reset <= 0;
    end
    r_rand = 1;
  end
  
endtask
  
  
  
  
task r_driver:: r_Reset_one();
  
  //$display("read reset entered");
  @(vif.cb_r_intf);
  if (!w_reset) begin
    vif.cb_r_intf.r_inc <= pckt.r_inc;
    vif.cb_r_intf.r_reset <= 1;
    repeat (20) @(vif.cb_r_intf);
    vif.cb_r_intf.r_reset <= 0;
    r_reset_tst_done = 1;
  end
  else begin
    vif.cb_r_intf.r_inc <= pckt.r_inc;
    vif.cb_r_intf.r_reset <= 0;
    wait (w_reset_tst_done == 1);
    vif.cb_r_intf.r_inc <= pckt.r_inc;
    vif.cb_r_intf.r_reset <= 1;
    test_done = 1;
  end
  
endtask