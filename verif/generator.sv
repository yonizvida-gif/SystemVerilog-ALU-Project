class generator;
  
	rand transaction tr;
	
	mailbox gen2driv;
  
	event ended;
	int count, num_tran = 0;

	function new(mailbox gen2driv);
		this.gen2driv = gen2driv;
	endfunction
  
  
	int num;

	task main();
		num = count;
    	while (num > 0) begin
      		int scenario = $urandom_range(1, 100);
			int current_steps = (scenario < 60) ? 4 : 1; 
        	repeat (current_steps) begin
         	    if (num > 0) begin
                	if(scenario < 10) begin
						div_zero_tran dz = new();
						tr = dz;
					end
                	else if (scenario < 20) begin
						overflow_tran of = new();
						tr = of;
					end
                	else if (scenario < 60) begin
						good_tran gt = new();
						tr = gt;
					end
                	else    
						tr = new();
							
                	if (!tr.randomize()) $fatal("Randomization failed");
   
                		gen2driv.put(tr);
                		num--;
                		tr.display("generator");
            	end
			end
    	end
    	-> ended;
	endtask
  
  
endclass