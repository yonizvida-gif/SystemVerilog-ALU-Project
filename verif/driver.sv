class driver;
  
	mailbox gen2driv;
	
	int num_tran;
  
  
	virtual alu_mem_if.tb_mp vinf;
  
	function new(virtual alu_mem_if.tb_mp vinf,mailbox gen2driv);
		this.vinf = vinf;
		this.gen2driv = gen2driv;
	endfunction
  

	task main();
		forever begin
			transaction tr;
			gen2driv.get(tr);
			@(vinf.drv_cb);
			vinf.drv_cb.enable <= tr.enable;
			vinf.drv_cb.wr_data <= tr.wr_data;
			vinf.drv_cb.rd_wr <= tr.rd_wr;
			vinf.drv_cb.addr <= tr.addr;
			tr.display("driver");
			num_tran++;
		end
	endtask
  
  
endclass
