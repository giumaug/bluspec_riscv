package Stage5;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage5 #(MemWb memWb, Wire#(Bit#(32)) rd, Wire#(Bit#(5)) rdNum) (Empty);
	
		rule writeBack;
			`DISPLAY("---begin writeBack---")
			Bit#(32) _rd = 0;
			Bit#(1) opType = memWb.rOpType();
			if (opType == 0) _rd = memWb.rAluOut();
			else _rd = memWb.rMemOut();
			rd <= _rd;
			rdNum <= memWb.rRdNum();
		
			//Only debug
			`DISPLAY_VAR("instr is %0h ", memWb.rInstr())
			`DISPLAY_VAR("rd is %d", _rd)
			`DISPLAY_VAR("rdNum is %d", memWb.rRdNum())
			`DISPLAY("---end writeBack---")
		endrule
	endmodule: mkStage5
endpackage
