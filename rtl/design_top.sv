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

	property check_execute;
		@(posedge intf.clk) disable iff (intf.reset) 
		(execute && !$isunknown({op, A, B})) |=> (intf.res_out == (
        op == 3'b000 ? RES_WIDTH'('h0000) :                // NOP / Zero
        op == 3'b001 ? (A + B) :                 // ADD
        op == 3'b010 ? (A - B) :                 // SUB
        op == 3'b011 ? (A * B) :                 // MUL
        (op == 3'b100 ? (B == 0 ? RES_WIDTH'('hDEAD) : A / B) : // DIV / DIV_ZERO check
        $past(intf.res_out))                     // DEFAULT: res_out stays same
    ));
	endproperty

	assert_execute: assert property (check_execute)
    else $error("[ASSERTION FAILURE] execute failed at time %0t! Expected output mismatch.", $time);

	
	

	property res_out_stable;
		@(posedge intf.clk) disable iff (intf.reset) (!(execute) && !$isunknown($past(intf.res_out))) |-> (intf.res_out == $past(intf.res_out));
	endproperty

	assert_res_stable: assert property (res_out_stable) 
    	$display("[SUCCESS] Time: %0t | res_out is stable", $time);
	else 
    	$error("[FAILURE] Time: %0t | res_out changed! Past: %h, Current: %h, Execute: %b, Reset: %b", $time, $past(intf.res_out), intf.res_out, execute, intf.reset);
	
	
	property div_zero;
		@(posedge intf.clk) disable iff (intf.reset) (execute && op == 3'b100 && B == 0) |-> (intf.res_out == RES_WIDTH'('hDEAD));
	endproperty
	
	assert_div_zero: assert property (div_zero) 
    else $error("[ASSERTION FAILURE] res_out != dead while div 0");


endmodule