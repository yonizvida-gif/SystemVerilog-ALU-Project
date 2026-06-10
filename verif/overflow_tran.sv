class overflow_tran extends good_tran;
  
  constraint of{
		rd_wr == 0;
		enable == 1;
		(addr == 0) -> wr_data == 255;
    	(addr == 1) -> wr_data == 255;
    	(addr == 2) -> wr_data == 3;
    	(addr == 3) -> wr_data == 1;
	};
  


endclass