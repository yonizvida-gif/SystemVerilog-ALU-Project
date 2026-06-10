class environment ;

	generator gen;
	driver driv;
	monitor_in mon_in;
	monitor_out mon_out;
	scoreboard scor;
	alu_cover cov;
  
	virtual alu_mem_if.tb_mp vinf;
	mailbox gen2driv;
	mailbox mon_in2scb;
	mailbox mon_out2scb;
	mailbox mon_in2cov; 
	mailbox mon_out2cov; 
  

  
	function new(virtual alu_mem_if.tb_mp vinf);
        this.vinf = vinf;
	
		gen2driv    = new();
		mon_in2scb  = new();
		mon_out2scb = new();
		mon_in2cov  = new();
		mon_out2cov = new();
		
		gen     =  new(gen2driv);
		driv    = new(vinf, gen2driv);
		mon_in  = new(vinf, mon_in2scb, mon_in2cov);
        mon_out = new(vinf, mon_out2scb, mon_out2cov);
		scor    = new(mon_in2scb,mon_out2scb);
		cov     = new(mon_in2cov, mon_out2cov);
	endfunction
  
	task test();
		fork
			gen.main();
			driv.main();
			mon_in.main();
			mon_out.main();
			scor.main();
			cov.main();
		join_any
	endtask
  
	task post_test();
		wait(gen.ended.triggered);
		wait(gen.count == driv.num_tran);
		wait(gen.count == scor.num_tran);
	endtask
  
	task run();
		test();
		post_test();
        $display("***********************");
        $display("Total Error in Scoreboard: %0d", scor.error);
		$finish;
	endtask


endclass