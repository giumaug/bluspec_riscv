package DataHazardUnit;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	interface DataHazardUnit;
		method Bool doStall(Bit#(7) opcode, Bit#(5) rs1, Bit#(5) rs2);
	endinterface: DataHazardUnit
	
	module mkDataHazardUnit #(IdEx idEx, ExMem exMem, MemWb memWb) (DataHazardUnit);
	
		function Bool checkHazard(Bit#(5) regNum);
			return (regNum == idEx.rRdNum() || regNum == exMem.rRdNum() || regNum == memWb.rRdNum());
		endfunction
	
		method Bool doStall(Bit#(7) opcode, Bit#(5) rs1, Bit#(5) rs2);
			Bool stall;
			case (opcode)
			   	`JALR: begin
			     	stall = checkHazard(rs1);
			    end
				`BRANCH: begin
			     	stall = checkHazard(rs1) && checkHazard(rs2);
				end
				`OPIMM: begin
					stall = checkHazard(rs1);
				end
				`OP: begin
					stall = checkHazard(rs1) && checkHazard(rs2);
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
endmodule: mkDataHazardUnit
endpackage
