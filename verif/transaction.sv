class transaction;
  localparam DATA_WIDTH = 8;
  localparam RES_WIDTH = 2*DATA_WIDTH;
  localparam ADDR_WIDTH = 2;
  
  logic [RES_WIDTH-1:0]        res_out;
  logic [DATA_WIDTH-1:0]       rd_data;
  rand logic [DATA_WIDTH-1:0]  wr_data;
  rand logic                   enable;
  rand logic                   rd_wr;
  rand logic [ADDR_WIDTH-1:0]  addr;



  constraint wr_data_const {
    (addr == 2) -> wr_data inside {[0:4]};
    (addr == 3) -> wr_data inside {[0:1]};
    solve addr before wr_data; // without: large value 
  }
  
  constraint addr_const {
    addr inside {[0:3]};
  }
  
  constraint enable_dist {   
    enable dist {1 := 80, 0 := 20}; // enable: 80% on || 20% off
    rd_wr dist {1 := 30, 0 := 70};
    //enable == 1;
  }
  
  function void display(string name);
    
      $display("----------------------");
      $display(" %0s - %0t", name, $time);
      $display("----------------------");
      $display("wr_data - %0d, addr - %0d, rd_wr - %0d",wr_data,addr,rd_wr);
      $display("res_out - %0d, rd_data - %0d",res_out,rd_data);
      $display("----------------------");
    
  endfunction


    function void scor_display(string name, bit in_out);
    
      $display("----------------------");
      $display(" %0s - %0t", name, $time);
      $display("----------------------");

      if(in_out) //monitor in = 1
      	$display("wr_data - %0d, addr - %0d, rd_wr - %0d",wr_data,addr,rd_wr);
      else // monitor out = 0
      	$display("res_out - %0d, rd_data - %0d",res_out,rd_data); 
     
      $display("----------------------");
    
  endfunction
  
  
endclass