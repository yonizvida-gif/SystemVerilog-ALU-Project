module alu_mem #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 2,
    parameter RES_WIDTH  = 2 * DATA_WIDTH
   )
   (
	alu_mem_if.dut_mp intf
   );
	
	logic [DATA_WIDTH-1:0] A, B;
	logic [2:0]            op;
	logic                  execute;

	

	ALU a1 ( 
		.A(A), 
		.B(B), 
		.op(op), 
		.execute(execute),
		.res_out(intf.res_out)
	);


	MEMORY m1 (
		.clk(intf.clk),
		.reset(intf.reset),
		.A(A),
		.B(B),
		.op(op),
		.execute(execute),
		.wr_data(intf.wr_data),
		.enable(intf.enable),
		.rd_wr(intf.rd_wr),
		.addr(intf.addr),
		.rd_data(intf.rd_data)
	);

endmodule
