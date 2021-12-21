package Stage5;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage5 #(MemWb memWb, Wire#(Bit#(32)) rd) (Empty);
	
	rule writeBack;
		Bit#(32) _rd = 0;
		Bit#(1) opType = memWb.rOpType();
		if (opType == 0) _rd = memWb.rAluOut();
		else _rd = memWb.rMemOut();
		rd <= _rd;
	endrule
	
	endmodule: mkStage5
endpackage
