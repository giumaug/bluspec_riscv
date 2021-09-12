package Stage1;

	`include "Soc.defines"
	import Memory::*;
	import DataTypes::*;
	
	(*synthesize*)
	module mkStage1#(IfId ifId, Wire#(Bool) bTaken, Wire#((Bit#(32)) bPc) (Empty);	
		Mem instMem <- mkMem(INST_CACHE_SIZE);
		Reg#(Bit#(32)) pc <- mkReg(BOOT_ADDRESS);
	
		rule fetch;
			Bit#(32) instr = instr.read(pc);
			if (bTaken) pc <= bPc;
			else pc <= pc + 4;
			ifId.wPc(pc);
			ifId.wInstr(instr);
		endrule
		
	endmodule: mkStage1
endpackage
