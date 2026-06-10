class test;
  

	virtual alu_mem_if.tb_mp intf;

	environment env;
  
	function new(virtual alu_mem_if.tb_mp intf);
		this.intf = intf;
	endfunction
  

	task run();
		env = new(intf);
		env.gen.count = 20000;
		env.run();
	endtask




endclass