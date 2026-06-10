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



	property check_reset;
		@(posedge clk) reset |=> (!mem_reg[0] && !mem_reg[1] && !mem_reg[2] && !mem_reg[3] && !rd_data && !temp);
	endproperty

	assert_reset: assert property (check_reset)
	else  $error("[ASSERTION FAILURE] Memory reset failed!");


	property check_write;
		@(posedge clk) disable iff (reset) (enable && !rd_wr) |=>  (mem_reg[$past(addr)] == $past(wr_data));
	endproperty
	
	assert_write: assert property (check_write) 
    else $error("[ASSERTION FAILURE] Memory write failed!");
	
	property check_read;
		@(posedge clk) disable iff (reset) (enable && rd_wr) |=> ##1  ($past(mem_reg[addr],2) == rd_data);
	endproperty
	
	assert_read: assert property (check_read) 
    else $error("[ASSERTION FAILURE] Memory read failed!");
	
	property mem_check;
		@(posedge clk) disable iff (reset) (enable) |=> (!mem_reg[2][7:3] && !mem_reg[3][7:1]);
	endproperty
	
	assert_res_stable: assert property (mem_check) 
    else $error("[ASSERTION FAILURE] reg bank reserved bit wasn't 0!");
	
	property check_enable;
		@(posedge clk) disable iff (reset) (!enable) |=>  (mem_reg[0] == $past(mem_reg[0]) && mem_reg[1] == $past(mem_reg[1]) && 
															mem_reg[2] == $past(mem_reg[2]) && mem_reg[3] == $past(mem_reg[3]));
	endproperty
	
	assert_enable_stable: assert property (check_enable) 
    else $error("[ASSERTION FAILURE] reg bank changes without enable!");
	
	
	property op_exe_check;
		@(posedge clk) disable iff (reset) (enable) |=> (mem_reg[2][2:0] <= 3'b100 && mem_reg[3][0] <= 1'b1);
	endproperty
	
	
	assert_op_exe_valid: assert property (op_exe_check)
    else $error("[ASSERTION FAILURE] Illegal Opcode or execute detected during enable!");
 
endmodule