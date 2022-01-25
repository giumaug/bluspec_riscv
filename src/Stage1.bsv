package Stage1;

	`include "Constants.defines"
	import Cache::*;
	import PipeRegs::*;
	
	module mkStage1 #(IfId ifId, Wire#(Bool) bTaken, Wire#(Bit#(32)) bPc, Wire#(Bool) stall) (Empty);
		Integer payloadSize =  `PAYLOAD_SIZE;
		Integer size = `INST_CACHE_SIZE;
		Integer payload[payloadSize];
        //Expand payload here
        `PAYLOAD
	
		Cache cache <- mkCache(payload, payloadSize, size, `INST_CACHE_OFFSET);
		Reg#(Bit#(32)) pc <- mkReg(`BOOT_ADDRESS);
		//Only debug
		Reg#(Bit#(32)) instrNum <- mkReg(0);
		
		rule fetch; //rimettere condizione
			$display("---begin fetch---");
			Bit#(32) instr = 0;
			
			if (stall == False) begin
				instr = cache.read32(pc);
				instrNum <= instrNum + 1;
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
			end
			else begin
				ifId.wPc(pc);
				ifId.wInstr(0);
			end
			$display("stall is %d ", stall);
			$display("instr is %0h ", instr);
			$display("pc is %0h ", pc);
			$display("instrNum is %0d ", instrNum);
			$display("---end fetch---");
		endrule
	endmodule: mkStage1
endpackage
