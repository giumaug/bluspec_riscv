package Stage1;

	`include "Constants.defines"
	import Cache::*;
	import PipeRegs::*;
	import MemoryController::*;
	
	module mkStage1 #(IfId ifId, Wire#(Bool) bTaken, Wire#(Bit#(32)) bPc, MemoryController memoryController,Wire#(Bool) stall) (Empty);
		Reg#(Bit#(32)) pc <- mkReg(`BOOT_ADDRESS);
		//Only debug
		Reg#(Bit#(32)) instrNum <- mkReg(0);
		
		rule fetch;
			`DISPLAY("---begin fetch---")
			Bit#(32) instr = 0;
			
			if (stall == False) begin
				instr = memoryController.read32(pc, 1);
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
			`DISPLAY_VAR("stall is %d ", stall)
			`DISPLAY_VAR("instr is %0h ", instr)
			`DISPLAY_VAR("pc is %0h ", pc)
			`DISPLAY_VAR("instrNum is %0d ", instrNum)
			`DISPLAY("---end fetch---")
		endrule
	endmodule: mkStage1
endpackage
