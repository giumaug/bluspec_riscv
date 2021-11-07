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
		
			case (opcode)
			
				`OP-IMM: begin
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
				
				`LUI: begin
					aluOut = unpack(idEx.rImm20 << 12);
				end
				
				`AUIPC: begin
					aluOut = unpack((idEx.rImm20 << 12) + );
				end
				
				`LOAD: begin
					aluOut = rs1 + imm12;
				end
				
				`STORE: begin
					aluOut = rs1 + imm12;
				end		
			endcase
			
			exMem.wAluOut(aluOut);
			exMem.wRdNum(idEx.rdNum()));
			exMem.wRs1(idEx.rRs1);
			exMem.wRs2(idEx.rRs2);
		endrule
	endmodule: mkStage3
endpackage
