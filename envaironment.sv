class envaironment;

	generator gen;
	driver driv;
	monitor_in mon_in;
	monitor_out mon_out;
	scoreboard scor;
  
	virtual alu_mem_if.tb_mp vinf;
	mailbox gen2driv, mon_in2scb, mon_out2scb;
  

  
	function new(virtual alu_mem_if.tb_mp vinf);
        this.vinf = vinf;
	
		gen2driv = new();
		mon_in2scb = new();
		mon_out2scb = new();

		gen =  new(gen2driv);
		driv = new(vinf, gen2driv);
		mon_in =  new(vinf, mon_in2scb);
        mon_out =  new(vinf, mon_out2scb);
		scor = new(mon_in2scb,mon_out2scb);
	endfunction
  
	task test();
		fork
			gen.main();
			driv.main();
			mon_in.main();
			mon_out.main();
			scor.main();
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
