class div_zero_tran extends good_tran;
  
	constraint div_0{
		rd_wr == 0;
		enable == 1;
    	(addr == 1) -> wr_data == 0;
    	(addr == 2) -> wr_data == 4;
    	(addr == 3) -> wr_data == 1;
	};

endclass