package Stage3;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	module mkStage3 #(IdEx idEx, ExMem exMem) (Empty);
	
		rule execute;
			Bit#(32) pc = idEx.rPc();
			Int#(32) rs1 = unpack(signExtend(idEx.rRs1()));
			Int#(32) rs2 = unpack(signExtend(idEx.rRs2()));
			Int#(32) imm12 = unpack(signExtend(idEx.rImm12()));
			UInt#(32) uRs1 = unpack(zeroExtend(idEx.rRs1()));
			UInt#(32) uRs2 = unpack(zeroExtend(idEx.rRs2()));
			UInt#(32) uImm12 = unpack(zeroExtend(idEx.rImm12()));
			Bit#(7) opcode = idEx.rOpcode();
			Bit#(3) func3 = idEx.rFunc3();
			Bit#(7) func7 = idEx.rFunc7();
			Int#(32) aluOut;
			Bit#(1) opType;
			Bit#(5) shiftImm = idEx.rImm12()[4:0];
			Bit#(5) shiftReg = idEx.rRs2()[4:0];
		
			case (opcode)
				`OPIMM: begin
					opType = 0;
					case (func3)
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
							aluOut = rs1 << shiftImm;
						end
						`SRLISRAI: begin
							if (func7 == `SRLI)	aluOut = rs1 >> shiftImm;
							else if (func7 == `SRAI) aluOut = (rs1 >> shiftImm) | unpack({idEx.rRs1()[31:31], 31'b0});
						end
					endcase
				end
				`OP: begin
				    opType = 0;
					case (func3)
						`ADDSUB: begin
							if (func7 == `ADD) aluOut = rs1 + rs2;
						    else if (func7 == `SUB) aluOut = rs1 - rs2;
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
							aluOut = rs1 << shiftReg;
						end
						`SRLSRA: begin
							if (func7 == `SRL) aluOut = rs1 >> shiftReg;
							else if (func7 == `SRA) aluOut = (rs1 >> shiftReg) | unpack({idEx.rRs1()[31:31], 31'b0});
						end
					endcase
				end
				`JAL: begin
					opType = 0;
					aluOut = unpack(idEx.rPc()) + 4;
				end
				
				`JALR: begin
					opType = 0;
					aluOut = unpack(idEx.rPc()) + 4;
				end
				`LUI: begin
					opType = 0;
					aluOut = unpack(idEx.rImm20 << 12);--------------qui!!!!!
				end
				`AUIPC: begin
					opType = 0;
					aluOut = {unpack((idEx.rImm20 << 12)), 12'b0} + pc;
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
			exMem.wRdNum(idEx.rRdNum());
			exMem.wRs1(idEx.rRs1);
			exMem.wRs2(idEx.rRs2);
			exMem.wOpType(opType);
		endrule
	endmodule: mkStage3
endpackage
