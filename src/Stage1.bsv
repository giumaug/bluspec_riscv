package Stage1;

	`include "Constants.defines"
	import Cache::*;
	import PipeRegs::*;
	
	module mkStage1 #(IfId ifId, Bool bTaken, Bit#(32) bPc) (Empty);
		Integer payloadSize =  `PAYLOAD_SIZE;
		Integer size = `INST_CACHE_SIZE;
		Integer payload[payloadSize];
        //Expand payload here
        `PAYLOAD
	
		Cache cache <- mkCache(payload, payloadSize, size);
		Reg#(Bit#(32)) pc <- mkReg(`BOOT_ADDRESS);
		
		rule fetch;
			Bit#(32) instr = cache.read(pc);
			if (bTaken) pc <= bPc;
			else pc <= pc + 1;
			ifId.wPc(pc);
			ifId.wInstr(instr);
		endrule
		
	endmodule: mkStage1
endpackage
