interface alu_mem_if #(parameter DATA_WIDTH = 8, parameter RES_WIDTH = 2*DATA_WIDTH, parameter ADDR_WIDTH = 2)(input logic clk, input logic reset);
     
    logic [RES_WIDTH-1:0]  res_out;
    logic [DATA_WIDTH-1:0] rd_data;
    logic [DATA_WIDTH-1:0] wr_data;
    logic                  enable;
    logic                  rd_wr;
    logic [ADDR_WIDTH-1:0] addr; //4 registers
    
	
		
    	//Clocking Block 
    clocking mon_cb @(posedge clk);
      default input #0ns output #0ns;
      input res_out, rd_data, wr_data, enable, rd_wr, addr;  // before posedge
    endclocking

    clocking drv_cb @(negedge clk);
      default input #0ns output #0ns;
      output wr_data, enable, rd_wr, addr; // after  posedge
    endclocking
          
	modport dut_mp (
        input clk, reset,
        input  wr_data, enable, rd_wr, addr, //check reset/clk !!!!!!!!!!!!!!!
        output res_out, rd_data
    ); 
	
	
	modport tb_mp (
        clocking drv_cb, 
        clocking mon_cb,
        input clk, reset,
        output   wr_data, enable, rd_wr, addr, //check reset/clk !!!!!!!!!!!!!!!
        input res_out, rd_data
    ); 


	
    property check_addr_bounds;
	@(posedge clk) disable iff (reset) (enable) |=> (addr < 4);
    endproperty
	
    assert_addr_bounds: assert property (check_addr_bounds) 
    else $error("Address %d out of bounds!", addr);
	
   
	
    property control_not_x;
	@(posedge clk) disable iff (reset) (enable) |=> !$isunknown(addr) && !$isunknown(rd_wr) && !$isunknown(wr_data);
    endproperty
	
    assert_control_valid: assert property (control_not_x) 
    else $error("[INTERFACE ERROR] Unknown value on addr or rd_wr or wr_data during enable!");
	
  
endinterface