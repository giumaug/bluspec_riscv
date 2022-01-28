package Stage4;

	`include "Constants.defines"
	import Cache::*;
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage4 #(ExMem exMem, MemWb memWb) (Empty);
		Integer payloadSize =  `DATA_PAYLOAD_SIZE;
		Integer size = `DATA_CACHE_SIZE;
		Integer payload[payloadSize];
        //Expand payload here
        `DATA_PAYLOAD
	
		Cache cache <- mkCache(payload, payloadSize, size, `DATA_CACHE_OFFSET);
		
		rule memAcess;
			$display("---begin memAccess---");
			Bit#(32) rs2 = signExtend(exMem.rRs2());
			Bit#(32) aluOut = exMem.rAluOut();
			Bit#(32) memOut = 0;
			Bit#(7) opcode = exMem.rOpcode();
			Bit#(3) func3 = exMem.rFunc3();
			
			$display("opcode %d", opcode);
			$display("func3 %d", func3);
			
			case (opcode)
				`LOAD: begin
					Bit#(32) val = cache.read32(aluOut);
					case (func3)
						`LB: begin
							$display("instruction LB");
							memOut = signExtend(val[7:0]);
						end
						`LH: begin
							$display("instruction LH");
							memOut = signExtend(val[15:0]);
						end
						`LW: begin
							$display("instruction LW");
							memOut = val;
						end
						`LBU: begin
							$display("instruction LBU");
							memOut = zeroExtend(val[7:0]);
						end
						`LHU: begin
							$display("instruction LHU");
							memOut = zeroExtend(val[15:0]);
						end
					endcase	
				end
				`STORE: begin
					case (func3)
						`SB: begin
							$display("instruction SB");
							 cache.write8(aluOut, rs2[7:0]);
						end
						`SH: begin
							$display("instruction SH");
							cache.write16(aluOut, rs2[15:0]);
						end
						`SW: begin
							$display("instruction SW");
							cache.write32(aluOut, rs2);
						end
					endcase
				end
			endcase
			
			$display("memOut %d", memOut);
			$display("aluOut %d", aluOut);
			$display("rs2 is %d", rs2);
			memWb.wRdNum(exMem.rRdNum());
			memWb.wMemOut(memOut);
			memWb.wOpType(exMem.rOpType());
			memWb.wAluOut(exMem.rAluOut());
			//Only debug
			memWb.wInstr(exMem.rInstr());
			$display("instr is %0h ", exMem.rInstr());
			if (exMem.rInstr() == 'h6f) cache.dumpMem();
			$display("---end memAccess---");
		endrule
	endmodule: mkStage4
endpackage
