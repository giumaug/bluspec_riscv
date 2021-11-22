package Stage3;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage3 #(IdEx idEx, ExMem exMem) (Empty);
	
		rule execute;
			Int#(32) rs1 = unpack(signExtend(idEx.rRs1()));
			Int#(32) imm12 = unpack(signExtend(idEx.rImm12()));
			Unt#(32) uRs1 = unpack(zeroExtend(idEx.rRs1()));
			Unt#(32) uRs2 = unpack(zeroExtend(idEx.rRs2()));
			UInt#(32) uImm12 = unpack(zeroExtend(idEx.rImm12()));
			Bit#(5) opcode = idEx.rOpcode();
			Bit#(3) func = idEx.rfunc(func);
			Int#(32) aluOut;
			Bit#(1) opType;
		
			case (opcode)
				`OP-IMM: begin
					opType = 0;
					case (func)
						`ADDI: begin
							aluOut = rs1 + imm12;
						end
						`SLTI: begin
							if (rs1 < imm12) aluOut = 1;
							else aluOut = 0;
						end
						`SLTIU: begin
							if (uRs1 < uImm12) aluOut = 1;
							else aluOut = 0; 
						end
						`ANDI: begin
							aluOut = rs1 & imm12;
						end
						`ORI: begin
							aluOut = rs1 | imm12;
						end
						`XORI: begin
							aluOut = rs1 ^ imm12;
						end
						`SLLI: begin
							aluOut = rs1 << imm12[4:0];
						end
						`SRLI: begin
							aluOut = rs1 >> imm12[4:0];
						end
						`SRAI: begin
							aluOut = (rs1 >> imm12[4:0]) | (rs1[31:31] << 31);
						end
					endcase
				end
				`OP: begin
				    opType = 0;
					case (func)
						`ADD: begin
							aluOut = rs1 + rs2;
						end
						`SLT: begin
							if (rs1 < rs2) aluOut = 1;
							else aluOut = 0;
						end
						`SLTU: begin
							if (uRs1 < uRs2) aluOut = 1;
							else aluOut = 0;
						end
						`AND: begin
							aluOut = rs1 & rs2;
						end
						`OR: begin
							aluOut = rs1 | rs2;
						end
						`XOR: begin
							aluOut = rs1 ^ rs2;
						end
						`SLL: begin
							aluOut = rs1 << rs2[4:0];
						end
						`SRL: begin
							aluOut = rs1 >> rs2[4:0];
						end
						`SUB: begin
							aluOut = rs1 - rs2;
						end
						`SRA: begin
							aluOut = (rs1 >> rs2[4:0]) | (rs1[31:31] << 31);
						end
					endcase
				end
				`JAL: begin
					opType = 0;
					aluOut = (ifId.rPc() + 4);
				end
				
				`JALR: begin
					opType = 0;
					aluOut = (ifId.rPc() + 4);
				end
				`LUI: begin
					opType = 0;
					aluOut = unpack(idEx.rImm20 << 12);
				end
				`AUIPC: begin
					opType = 0;
					aluOut = unpack((idEx.rImm20 << 12) + );
				end
				`LOAD: begin
					opType = 1;
					aluOut = rs1 + imm12;
				end
				`STORE: begin
					opType = 1;
					aluOut = rs1 + imm12;
				end		
			endcase
			
			exMem.wAluOut(aluOut);
			exMem.wRdNum(idEx.rRdNum()));
			exMem.wRs1(idEx.rRs1);
			exMem.wRs2(idEx.rRs2);
			exMem.wOpType(opType);
		endrule
	endmodule: mkStage3
endpackage
