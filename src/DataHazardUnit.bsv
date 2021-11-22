package DataHazardUnit;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	module mkDataHazardUnit #(IdEx idEx, ExMem exMem, MedWb memWb) (Empty);
	
		method Bool doStall(Bit#(5) opcode) begin
			Bool stall;
			case (opcode)
			   	`JALR: begin
			     	stall = checkHazard(rs1);
			    end
				`BRANCH: begin
			     	stall = checkHazard(rs1) & checkHazard(rs2);
				end
				`OP-IMM: begin
					stall = checkHazard(rs1);
				end
				`OP: begin
					stall = checkHazard(rs1) & checkHazard(rs2);
				end
				`LOAD: begin
					stall = checkHazard(rs1);
				end
				`STORE: begin
					stall = checkHazard(rs1);
				end
			endcase
			return stall;
		endmethod
		 
		function Bool checkHazard(Bit#(5) regNum);
			return (regNum == idEx.rRdNum() || regNum == exMem.rRdNum() || regNum == memWeb.rRdNum())
		endfunction
endmodule: mkDataHazardUnit
endpackage
