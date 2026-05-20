class good_tran extends transaction;
	static logic [1:0] next_addr = 0;
  
	constraint addr_sequnce{
		addr == next_addr;
		//enable == 1;
		//rd_wr == 0;
	};
  

	function void post_randomize();
		next_addr++;
	endfunction


endclass
