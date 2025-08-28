//parameter ADDR_WIDTH = 4;

module sync (
  input [ADDR_WIDTH : 0] ptr,
  input					 clk,
  input					 reset,
  
  output reg [ADDR_WIDTH : 0] out_ptr
);
  
  reg [ADDR_WIDTH : 0] internal_reg;
  
  always @(posedge clk or posedge reset) begin
    
    if (!reset) begin
      internal_reg <= ptr;
      out_ptr	   <= internal_reg;
    end
    else begin
      internal_reg <= 0;
      out_ptr	   <= 0;
    end   
    
  end
  
endmodule