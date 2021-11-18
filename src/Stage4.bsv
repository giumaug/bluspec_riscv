package Stage4;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage4 #(ExMem exMem, MemWb memWb) (Empty);
		Integer payloadSize = 0;
		Integer size = `DATA_CACHE_SIZE;
		Integer payload[1];
	
		Cache cache <- mkCache(payload, payloadSize, size);
		
		rule memAcess;
			Bit#(32) aluOut = pack(exMem.rAluOut(aluOut));
			Bit#(32) memOut;
			case (opcode)
				`LOAD: begin
					Bit#(32) val = cache.read32(aluOut);
					case (opcode)
						`LB: begin
							memOut <= signExtend(val[7:0]);
						end
						`LH: begin
							memOut <= signExtend(val[15:0]);
						end
						`LW: begin
							memOut <= val;
						end
						`LBU: begin
							memOut <= zeroExtend(val[7:0]);
						end
						`LHU: begin
							memOut <= zeroExtend(val[15:0]);
						end	
				end
				`STORE: begin
					case (opcode)
						`SB: begin
							 cache.write8(aluOut, rs2[7:0]);
						end
						`SH: begin
							cache.write16(aluOut, rs2[15:0]);
						end
						`SW: begin
							cache.write32(aluOut, rs2);
						end
				end
			endcase
			
			memWb.wRdNum(memEx.rRdNum());
			memWb.wMemOut(memOut);
			memWOpType(memEx.rOpType());-----------------partire da pipe registri
		endrule
	endmodule: mkStage4
endpackage
