package Stage4;

	`include "Constants.defines"
	import Cache::*;
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage4 #(ExMem exMem, MemWb memWb) (Empty);
		Integer payloadSize = 0;
		Integer size = `DATA_CACHE_SIZE;
		Integer payload[1];
	
		Cache cache <- mkCache(payload, payloadSize, size);
		
		rule memAcess;
			Bit#(32) rs2 = signExtend(exMem.rRs2());
			Bit#(32) aluOut = exMem.rAluOut();
			Bit#(32) memOut = 0;
			Bit#(7) opcode = exMem.rOpcode();
			Bit#(3) func3 = exMem.rFunc3();
			case (opcode)
				`LOAD: begin
					Bit#(32) val = cache.read32(aluOut);
					case (func3)
						`LB: begin
							memOut = signExtend(val[7:0]);
						end
						`LH: begin
							memOut = signExtend(val[15:0]);
						end
						`LW: begin
							memOut = val;
						end
						`LBU: begin
							memOut = zeroExtend(val[7:0]);
						end
						`LHU: begin
							memOut = zeroExtend(val[15:0]);
						end
					endcase	
				end
				`STORE: begin
					case (func3)
						`SB: begin
							 cache.write8(aluOut, rs2[7:0]);
						end
						`SH: begin
							cache.write16(aluOut, rs2[15:0]);
						end
						`SW: begin
							cache.write32(aluOut, rs2);
						end
					endcase
				end
			endcase
			
			memWb.wRdNum(exMem.rRdNum());
			memWb.wMemOut(memOut);
			memWb.wOpType(exMem.rOpType());
		endrule
	endmodule: mkStage4
endpackage
