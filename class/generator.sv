class generator;
  
	rand transaction tr;
	
	mailbox gen2driv;
  
	event ended;
	int count, num_tran = 0;
  
	string type_tran;

	function new(mailbox gen2driv);
		this.gen2driv = gen2driv;
		type_tran = "tran";
	endfunction
  
  
	task main();
		repeat(count) begin
        	if(type_tran == "good") begin
				good_tran gt = new();
				tr = gt;
			end
			else	
				tr = new();
		
			if(!tr.randomize())
				$fatal("gen:: tr randomization failed");
			else
				tr.display("generator");

    
			gen2driv.put(tr);
		end
		-> ended;
	endtask
  
  
endclass
