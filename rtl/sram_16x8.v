module sram_16x8 (
    input clk,
    input we,
    input [3:0] adr,
    input [7:0] din,
    input [1:0] fault,
    output reg [7:0] dout
);

    reg [7:0] mem [0:15];

    always @(posedge clk) begin
        if(we) begin
            mem[adr] <= din;
        end
    end
    always @(*) begin
    	  case(fault)
    	      2'b00: dout = 8'h00;
    	      default: dout = mem[adr]; 
    	  endcase
    end
endmodule