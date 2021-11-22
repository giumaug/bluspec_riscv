package Stage5;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage5 #(MemWb memWb, Wire#(Bit#(32)) rd) (Empty);
	
	rule writeBack;
		Bit#(32) rd;
		Bit#(1) opType = memWb.rOptype();
		if (opType == 0) rd <= memWb.rAluOut();
		else rd <= memWb.rMemOut();
		rd <= _rd;
	endrule
	
	endmodule: mkStage5
endpackage
