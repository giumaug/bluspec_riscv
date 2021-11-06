package Stage1;

	`include "Constants.defines"
	import Cache::*;
	import PipeRegs::*;
	
	module mkStage1 #(IfId ifId, Wire#(Bool) bTaken, Wire(Bit#(32)) bPc) (Empty);
		Integer payloadSize =  `PAYLOAD_SIZE;
		Integer size = `INST_CACHE_SIZE;
		Integer payload[payloadSize];
        //Expand payload here
        `PAYLOAD
	
		Cache cache <- mkCache(payload, payloadSize, size);
		Reg#(Bit#(32)) pc <- mkReg(`BOOT_ADDRESS);
		
		rule fetch;
			Bit#(32) instr = cache.read(pc);
			if (bTaken) begin
				pc <= bPc;
				ifId.wPc(0);
				ifId.wInstr(0);
			end	
			else begin
				//Branch wants current pc.It is ok because increment applies at the next clock.
				pc <= pc + 4;
				ifId.wPc(pc);
				ifId.wInstr(instr);
			end
		endrule
	endmodule: mkStage1
endpackage
