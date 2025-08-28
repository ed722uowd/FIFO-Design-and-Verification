//parameter DATA_WIDTH = 4;
//parameter ADDR_WIDTH = 4;

module FIFO_mem (
  input [DATA_WIDTH -1:0] w_data,
  input w_clk_en,
  input [ADDR_WIDTH-1:0] w_addr,
  input w_clk,
  input [ADDR_WIDTH-1:0] r_addr,
  output reg[DATA_WIDTH-1:0] r_data
);
  
  reg[DATA_WIDTH-1:0] fifo_mem [(1<<ADDR_WIDTH)-1:0];
  
  assign r_data = fifo_mem[r_addr];
  
  always @(posedge w_clk) begin
    if(w_clk_en) begin
      fifo_mem[w_addr] <=w_data;
    end
    /*
    else begin
      fifo_mem[w_addr] <= 0;
    end
    */
  end  
endmodule
  
