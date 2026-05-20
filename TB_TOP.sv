`include "interface.sv"     
`include "transaction.sv"    
`include "good_tran.sv"     
`include "generator.sv"
`include "driver.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "scoreboard.sv"
`include "envaironment.sv"
`include "test.sv"
module tb_top;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 2;
    parameter RES_WIDTH  = 2 * DATA_WIDTH;

    bit clk;
    bit reset;

	event rst_en,rst_done;
	
    alu_mem_if #(
        .DATA_WIDTH(DATA_WIDTH),
        .RES_WIDTH(RES_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) intf (
        .clk(clk),
        .reset(reset)
    );
	

    
    alu_mem dut (.intf(intf.dut_mp) );
	
	


	initial begin
        clk = 0;
        forever 
			#10 clk = ~clk;
    end
    
    initial begin
		test tb = new(intf.tb_mp);
		
		@(negedge clk);
		-> rst_en;
		@(rst_done);
		tb.run();
	
    end
	
	always begin //reset
		@(rst_en);
		@(negedge clk);
		reset = 1;
		$display("[driver]----- reset started -----");
		intf.wr_data = 0;
        intf.rd_wr   = 0;
        intf.addr    = 0;
        intf.enable  = 0;
		@(negedge clk);
		reset = 0;
		$display("[driver]----- reset ended -----");
		-> rst_done; 
	end 
	


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_top);
    end

endmodule







