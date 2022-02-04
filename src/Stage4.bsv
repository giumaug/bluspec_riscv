package Stage4;

	`include "Constants.defines"
	import Cache::*;
	import Utils::*;
	import PipeRegs::*;
	import MemoryController::*;
	
	module mkStage4 #(ExMem exMem, MemWb memWb, MemoryController memoryController) (Empty);
		
		rule memAcess;
			`DISPLAY("---begin memAccess---")
			Bit#(32) rs2 = signExtend(exMem.rRs2());
			Bit#(32) aluOut = exMem.rAluOut();
			Bit#(32) memOut = 0;
			Bit#(7) opcode = exMem.rOpcode();
			Bit#(3) func3 = exMem.rFunc3();
			
			`DISPLAY_VAR("opcode %d", opcode)
			`DISPLAY_VAR("func3 %d", func3)
			
			case (opcode)
				`LOAD: begin
					Bit#(32) val = memoryController.read32(aluOut, 0);
					case (func3)
						`LB: begin
							`DISPLAY("instruction LB")
							memOut = signExtend(val[7:0]);
						end
						`LH: begin
							`DISPLAY("instruction LH")
							memOut = signExtend(val[15:0]);
						end
						`LW: begin
							`DISPLAY("instruction LW")
							memOut = val;
						end
						`LBU: begin
							`DISPLAY("instruction LBU")
							memOut = zeroExtend(val[7:0]);
						end
						`LHU: begin
							`DISPLAY("instruction LHU")
							memOut = zeroExtend(val[15:0]);
						end
					endcase	
				end
				`STORE: begin
					case (func3)
						`SB: begin
							`DISPLAY("instruction SB")
							 memoryController.write8(aluOut, rs2[7:0], 0);
						end
						`SH: begin
							`DISPLAY("instruction SH")
							memoryController.write16(aluOut, rs2[15:0], 0);
						end
						`SW: begin
							`DISPLAY("instruction SW")
							memoryController.write32(aluOut, rs2, 0);
						end
					endcase
				end
			endcase
			
			`DISPLAY_VAR("memOut %d", memOut)
			`DISPLAY_VAR("aluOut %d", aluOut)
			`DISPLAY_VAR("rs2 is %d", rs2)
			memWb.wRdNum(exMem.rRdNum());
			memWb.wMemOut(memOut);
			memWb.wOpType(exMem.rOpType());
			memWb.wAluOut(exMem.rAluOut());
			//Only debug
			memWb.wInstr(exMem.rInstr());
			`DISPLAY_VAR("instr is %0h ", exMem.rInstr())
			if (exMem.rInstr() == 'h6f) memoryController.dumpMem(0);
			`DISPLAY("---end memAccess---")
		endrule
	endmodule: mkStage4
endpackage
