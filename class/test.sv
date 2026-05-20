class test;
  

	virtual alu_mem_if.tb_mp intf;

	envaironment env;
  
	function new(virtual alu_mem_if.tb_mp intf);
		this.intf = intf;
	endfunction
  

	task run();
		env = new(intf);
		env.gen.count = 10000;
		env.gen.type_tran = "tran";
		env.run();
	endtask




endclass
