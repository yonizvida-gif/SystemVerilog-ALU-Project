class monitor_out;

    virtual alu_mem_if.tb_mp vinf;
    mailbox mon_out2scb;
  
    function new(virtual alu_mem_if.tb_mp vinf, mailbox mon_out2scb);
        this.vinf = vinf;
        this.mon_out2scb = mon_out2scb;
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
			end		
        end
    endtask

endclass
