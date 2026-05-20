module ALU #(
    parameter DATA_WIDTH = 8,
    parameter RES_WIDTH  = 2 * DATA_WIDTH
	)
	(
	input logic [DATA_WIDTH-1:0]  A, B,
	input logic [2:0]                  op,
	input logic                        execute,
	output logic [RES_WIDTH-1:0] res_out
	);
  
	always @(*) begin
		if(execute) begin
			case(op)
				3'b000: res_out = 0;
				3'b001: res_out = A + B;
				3'b010: res_out = A - B;
				3'b011: res_out = A * B;
				3'b100: begin if(B == 0) 
							res_out = RES_WIDTH'('hDEAD);
						else 
							res_out = A / B;
						end 
			endcase
		end
		else 
			res_out = res_out;
	end
  
endmodule




