package Stage3;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage3 #(IfId ifId, IdEx idEx) (Empty);
	
		rule execute;
		
			case (opcode)
			
				`OP-IMM: begin
					Int#(32) rs1 = unpack(signExtend(idEx.rRs1()));
					Int#(32) imm = unpack(signExtend(idEx.rImm()));
					Unt#(32) uRs1 = unpack(zeroExtend(idEx.rRs1()));
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
							aluOut = (rs1 >> imm[4:0]) & (rs1[31:31] << 31);
						end
				endcase
				
			endcase
		
		endrule
		
	endmodule: mkStage3
endpackage
