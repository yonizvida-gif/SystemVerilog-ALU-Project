class good_tran extends transaction;
  static logic [1:0] next_addr = 0;
  
  constraint addr_sequnce{
	addr == next_addr;
  };
  

  function void post_randomize();
    next_addr++;
  endfunction


endclass