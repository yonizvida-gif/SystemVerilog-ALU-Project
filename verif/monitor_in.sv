class monitor_in;
	virtual alu_mem_if.tb_mp vinf;
	mailbox mon_in2scb; 
	mailbox mon_in2cov;
	function new(virtual alu_mem_if.tb_mp vinf, mailbox mon_in2scb, mailbox mon_in2cov);
        this.vinf = vinf;
        this.mon_in2scb = mon_in2scb;
		this.mon_in2cov = mon_in2cov;
    endfunction

	task main();
		forever begin
			transaction tr;
            @(vinf.mon_cb);    
			if(!vinf.reset) begin
				tr = new();
               	tr.enable = vinf.mon_cb.enable;
				tr.wr_data = vinf.mon_cb.wr_data;
				tr.rd_wr = vinf.mon_cb.rd_wr;
				tr.addr = vinf.mon_cb.addr;
      
				mon_in2scb.put(tr);
				tr.display("monitor in");
				mon_in2cov.put(tr);
			end
		end
	endtask
endclass