class alu_cover;
    localparam DATA_WIDTH = 8;
    localparam RES_WIDTH = 2*DATA_WIDTH;
    localparam ADDR_WIDTH = 2;
	
    mailbox mon_in2cov; 
    mailbox mon_out2cov; 
	
    logic flag;
    logic [ADDR_WIDTH-1:0]  addr;
    int rd_data, res_out;
    logic rd_wr;
    logic [DATA_WIDTH-1:0] temp_a = 0;
    logic [DATA_WIDTH-1:0] temp_b = 0;
    logic [2:0] temp_op = 0;
    logic temp_execute = 0;

	covergroup op_addr;
		cp_op: coverpoint temp_op{
			bins rst          = {3'b000};
			bins add          = {3'b001};
			bins sub          = {3'b010};
			bins mul          = {3'b011};
			bins div          = {3'b100};
			ignore_bins other = {[3'b101:3'b111]}; 
		}
		
		cp_op_zero: coverpoint temp_op{
			bins active = {[0:2]};
			bins low    = {[3:7]};
		}

		cp_addr: coverpoint addr{
			bins reg_a   = {2'b00};
			bins reg_b   = {2'b01};
			bins reg_op  = {2'b10};
			bins reg_exe = {2'b11};
		}
		
		cross_addr: coverpoint addr{
			bins reg_op                 = {2'b10};
			ignore_bins irrelevant_addr = {2'b00,2'b01,2'b11};
		}
		
		
		cp_exe: coverpoint temp_execute{
			bins not_exe = {1'b0};
			bins exe     = {1'b1};
		}

		cp_exe_zero: coverpoint temp_execute{
			bins active = {0};
			bins low    = {[1:7]};
		}
		
		cp_B_zero: coverpoint temp_b{
			bins zero  = { {DATA_WIDTH{1'b0}} };
			bins other = { [ {DATA_WIDTH{1'b0}} + 1'b1 :{DATA_WIDTH{1'b1}} ] };
		}
		
		cp_B: coverpoint temp_b{
			bins zero   = {0};
			bins one    = {1};
			bins max    = { {DATA_WIDTH{1'b1}} };
			bins others = default;
		}

		cp_A: coverpoint temp_a{
			bins zero   = {0};
			bins one    = {1};
			bins max    = { {DATA_WIDTH{1'b1}} };
			bins others = default;
		}
		
		cp_exe_tran: coverpoint temp_execute{
			bins b1       = (0 => 1 => 0);
			bins b2       = (1 => 0 => 1);
			bins long_exe = (1 => 1[*3]);
			bins post_rst = (0 => 1);
		}
		

		cp_rd_wr_seq: coverpoint rd_wr {
			bins read_to_write = (1 => 0); 
			bins write_to_read = (0 => 1);
			bins write_write   = (0 => 0);
			bins read_read     = (1 => 1);
			bins long_read     = (1 => 1[*5]);
			bins long_write    = (0 => 0[*5]);
		}
		
		cross_op_exe: cross cp_op,cp_exe;
	
		cross_op_addr: cross cp_op, cross_addr;
		
		/*
		cross_zero: cross cp_op, cp_B{
			bins div_zero = binsof(cp_op.div) && binsof(cp_B.zero);
		}
		*/
		
		cross_zero: cross cp_op, cp_B_zero;
	endgroup
	
	covergroup out_data;
		
		cp_res_out: coverpoint res_out iff (flag && temp_execute && temp_op != 2){
			bins good         = { [0 : ({DATA_WIDTH{1'b1}} * {DATA_WIDTH{1'b1}})] }; // 0 : 255*255
			illegal_bins bad  = { [({DATA_WIDTH{1'b1}} * {DATA_WIDTH{1'b1}}) + 1 : $ ] }; // 255*255 + 1 : $
		}
		
		cp_dead: coverpoint res_out iff (flag && temp_execute && temp_op == 4){
			bins dead    = { RES_WIDTH'('hDEAD) }; // /0 => res_out = dead
			bins others  = default; 
		}
		
		cp_rd_data: coverpoint rd_data{
			bins good             = { [0 : {DATA_WIDTH{1'b1}}] }; // 0 : 255
			illegal_bins overflow = { [256 : $] };
		}
	endgroup
	

	function new(mailbox mon_in2cov, mailbox mon_out2cov);
		this.mon_in2cov  = mon_in2cov;
		this.mon_out2cov = mon_out2cov; 
		op_addr = new();
		out_data = new();
    endfunction

	task main();
		fork
			forever begin
				transaction tr_in;
				mon_in2cov.get(tr_in);
				if(tr_in.enable) begin
					addr  = tr_in.addr;
					rd_wr = tr_in.rd_wr;
					if (!rd_wr) begin 
						case(addr)
							2'b00: temp_a       = tr_in.wr_data;
							2'b01: temp_b       = tr_in.wr_data;
							2'b10: temp_op      = tr_in.wr_data[2:0];
							2'b11: temp_execute = tr_in.wr_data[0];
						endcase
						flag = addr == 3 && tr_in.wr_data[0];
					end
					
					op_addr.sample();
				end	
			end			
			
						
			forever begin 
				transaction tr_out;			
				mon_out2cov.get(tr_out);
				
				res_out = tr_out.res_out;
				rd_data = tr_out.rd_data;


				out_data.sample();
			end
		join	
	endtask



endclass