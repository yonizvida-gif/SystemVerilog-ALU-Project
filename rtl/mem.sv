module MEMORY #(parameter DATA_WIDTH = 8, parameter RES_WIDTH = 2*DATA_WIDTH, parameter ADDR_WIDTH = 2)
   (
	input  logic                  clk,reset,
	input  logic                  enable,
	input  logic                  rd_wr,
	input  logic [DATA_WIDTH-1:0] wr_data,
	input  logic [ADDR_WIDTH-1:0] addr,
	output logic [DATA_WIDTH-1:0] rd_data,
    output logic [DATA_WIDTH-1:0] A,B,
    output logic [2:0]            op,
    output logic                  execute
   );
  
	localparam num_reg = 4; 
	logic [DATA_WIDTH-1:0] mem_reg [num_reg-1:0];
	logic [DATA_WIDTH-1:0] temp;
	
	assign A = mem_reg[0]; 
	assign B = mem_reg[1]; 
	assign op =  mem_reg[2][2:0]; 
	assign execute =  mem_reg[3][0]; 
  
	always @(posedge clk) begin
		if(reset) begin
			rd_data <= 0;
			temp <= 0;
			foreach(mem_reg[i])
				mem_reg[i] <= DATA_WIDTH'('b0);
		end
		else if(enable) begin
			case(rd_wr)
				0: mem_reg[addr] <= wr_data;
				1: temp <= mem_reg[addr];
				default: temp <= temp;
			endcase
		end
	end

	always @(posedge clk) begin
		rd_data <= temp;
	end
 
endmodule
