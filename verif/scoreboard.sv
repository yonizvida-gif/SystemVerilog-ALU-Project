class scoreboard;
    localparam DATA_WIDTH = 8;
    localparam RES_WIDTH = 2*DATA_WIDTH;
    localparam ADDR_WIDTH = 2;


    mailbox mon_in2scb,mon_out2scb;



    int num_tran = 0;
    int error = 0;
    bit flag = 0;

    logic [DATA_WIDTH-1:0] temp_a = 0;
    logic [DATA_WIDTH-1:0] temp_b = 0;
    logic [DATA_WIDTH-1:0] temp_op = 0;
    logic [DATA_WIDTH-1:0] temp_execute = 0;
    logic [RES_WIDTH-1:0] prev_res = 0, expected_res = 0;
	
    logic [DATA_WIDTH-1:0] next_rd_val;
	
    logic [DATA_WIDTH-1:0] expected_reg[$];





    function new(mailbox mon_in2scb,mon_out2scb);
        this.mon_in2scb = mon_in2scb;
        this.mon_out2scb = mon_out2scb;
	expected_reg.push_back(0);

    endfunction


    task main();
            
	fork
		in();
		out();
	join
    endtask
          
		  
    task in();
		forever begin
			transaction tr_in;
			mon_in2scb.get(tr_in);
	    
			if(tr_in.enable) begin

				if(!tr_in.rd_wr && tr_in.addr == 3 && tr_in.wr_data)
					flag = 1;
				
				if(!tr_in.rd_wr) begin //Write = 0
					case(tr_in.addr)
						2'b00:  temp_a = tr_in.wr_data;
						2'b01:  temp_b = tr_in.wr_data;
						2'b10:  temp_op = tr_in.wr_data [2:0];
						2'b11:  temp_execute = tr_in.wr_data [0];
						default: $display("[Scoreboard] Write to Addr: %0d", tr_in.addr);
					endcase
			    	
					if(temp_execute[0])
						check_result(); 
					else
						expected_res = prev_res;

				end			
				else begin //if(tr_in.rd_wr) begin //read = 1
					case(tr_in.addr)
						2'b00:  next_rd_val = temp_a;
						2'b01:  next_rd_val = temp_b;
						2'b10:  next_rd_val = temp_op[2:0];
						2'b11:  next_rd_val = temp_execute[0];
						default: $display("[Scoreboard] Write to Addr: %0d", tr_in.addr);
					endcase	
                			
				end	  
					
						
			end	
			expected_reg.push_back(next_rd_val);
			tr_in.scor_display("scoreboard",1);
			prev_res = expected_res;
			num_tran++;
		end	
    endtask
	
	task out();
	    forever begin
	        transaction tr_out;
			mon_out2scb.get(tr_out);
			if(flag) begin
				if(tr_out.res_out != expected_res) begin
					$display("[Scoreboard] Error! res_out Get: %0d || Expected: %0d *********************", tr_out.res_out, expected_res);
					error++;
				end
				if(tr_out.res_out > 65025 && temp_op[2:0] != 2 && temp_execute[0]) begin
					$display("[Scoreboard] Error! overflow res_out Get: %0d || Expected: %0d *********************", tr_out.res_out, expected_res);
					error++;
				end 
			end
		
 			
			if (expected_reg.size() > 0) begin
                logic [DATA_WIDTH-1:0] exp_reg;
               	exp_reg = expected_reg.pop_front();

                if (tr_out.rd_data != exp_reg) begin
                    $display("********************* [Scoreboard] Error! rd_data Get: %0d || Expected: %0d", tr_out.rd_data, exp_reg);
                    error++;
                end

            end	
			tr_out.scor_display("scoreboard",0);	
	    end
	endtask

    function void check_result();
        case(temp_op[2:0])
            3'b000: expected_res = 0;
            3'b001: expected_res = temp_a + temp_b;
            3'b010: expected_res = temp_a - temp_b;
            3'b011: expected_res = temp_a * temp_b;
            3'b100: expected_res = (temp_b == 0)? RES_WIDTH'('hDEAD) : (temp_a / temp_b);
            default: $display("[Scoreboard] Unknown op: %h", temp_op);
        endcase
    endfunction


endclass