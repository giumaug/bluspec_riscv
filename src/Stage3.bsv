package Stage3;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage3 #(IdEx idEx, ExMem exMem) (Empty);
	
		rule execute;
		
			case (opcode)
			
				`OP-IMM: begin
					Int#(32) rs1 = unpack(signExtend(idEx.rRs1()));
					Int#(32) imm = unpack(signExtend(idEx.rImm()));
					Unt#(32) uRs1 = unpack(zeroExtend(idEx.rRs1()));
					Unt#(32) uRs2 = unpack(zeroExtend(idEx.rRs2()));
					UInt#(32) uImm = unpack(zeroExtend(idEx.rImm()));
					Int#(32) aluOut;
					case (func)
					 
						`ADDI: begin
							aluOut = rs1 + imm;
						end
						
						`SLTI: begin
							if (rs1 < imm) aluOut = 1;
							else aluOut = 0;
						end
						
						`SLTIU: begin
							if (uRs1 < uImm) aluOut = 1;
							else aluOut = 0; 
						end
						
						`ANDI: begin
							aluOut = rs1 & imm;
						end
						
						`ORI: begin
							aluOut = rs1 | imm;
						end
						
						`XORI: begin
							aluOut = rs1 ^ imm;
						end
						
						`SLLI: begin
							aluOut = rs1 << imm[4:0];
						end
						
						`SRLI: begin
							aluOut = rs1 >> imm[4:0];
						end
						
						`SRAI: begin
							aluOut = (rs1 >> imm[4:0]) | (rs1[31:31] << 31);
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
					Bit#(32) tmp = signExtend(idEx.rImm());
					if (tmp[31] == 0) aluOut = unpack(tmp << 12);
					else 
					aluOut = unpack(tmp);
				end
				
				`AUIPC: begin
					Bit#(32) tmp = signExtend(idEx.rImm());
					aluOut = idEx.rPc()
				end
				
				
				
				`AUIPC: begin
				end
			endcase
		endrule
		
	endmodule: mkStage3
endpackage
