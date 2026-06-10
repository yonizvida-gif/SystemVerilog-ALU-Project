class monitor_out;

    virtual alu_mem_if.tb_mp vinf;
    mailbox mon_out2scb;
	mailbox mon_out2cov;
  
    function new(virtual alu_mem_if.tb_mp vinf, mailbox mon_out2scb, mailbox mon_out2cov);
        this.vinf = vinf;
        this.mon_out2scb = mon_out2scb;
		this.mon_out2cov = mon_out2cov;
    endfunction
  
    task main();
        forever begin
            transaction tr;
            tr = new();
            @(vinf.mon_cb);    

			if (!vinf.reset) begin
				tr.res_out = vinf.mon_cb.res_out;
               	tr.rd_data = vinf.mon_cb.rd_data;
		
				mon_out2scb.put(tr);
				tr.display("monitor out");
				mon_out2cov.put(tr);
			end		
        end
    endtask

endclass