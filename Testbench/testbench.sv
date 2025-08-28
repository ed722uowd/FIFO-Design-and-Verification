`include "interface.sv"
`include "test.sv"
//`include "coverage.sv"

module fifo_top_tb();
  
  logic w_clk, r_clk;
  
  w_intf intf_w (w_clk);
  r_intf intf_r (r_clk);
  
  FIFO_top dut(
    .w_data		(intf_w.w_data),
    .w_inc		(intf_w.w_inc),
    .w_clk		(w_clk),
    .w_reset	(intf_w.w_reset),
    .r_inc		(intf_r.r_inc),
    .r_clk		(r_clk),
    .r_reset	(intf_r.r_reset),
    .w_full		(intf_w.w_full),
    .r_empty	(intf_r.r_empty),
    .r_data		(intf_r.r_data)
  );
  
  test tst;
  //fifo_coverage cov;
  
  initial begin
    w_clk = 0;
    forever #5 w_clk = ~w_clk;
  end
  
  initial begin
    r_clk = 0;
    forever #10 r_clk = ~r_clk;
  end
  
  initial begin
    $dumpfile("dump.vcd"); // to get waveform
    $dumpvars;
    
    tst = new(intf_w, intf_r);
    tst.start();
        
    #300
    $display("Write Coverage = %.2f %%", tst.env.cov.w_cg.get_coverage());
    $display("Read  Coverage = %.2f %%", tst.env.cov.r_cg.get_coverage());
    $finish;
    
  end
    


endmodule