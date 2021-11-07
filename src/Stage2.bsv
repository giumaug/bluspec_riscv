package Stage2;

	`include "Constants.defines"
	import Cache::*;
	import PipeRegs::*;
	import Utils::*;
	
	module mkStage2 #(IfId ifId, IdEx idEx, Wire#(Bool) bTaken,Wire#(Bit#(32)) bPc) (Empty);
	
		RegFile regFile <- mkRegFile();
		
		rule decode;
			Bit#(32) word = ifId.rInstr();
			Bit#(5) opcode = word[6:0]; 
			Bit#(3) func = word[14:12];
			Int#(5) rs1Num = word[19:15]; 
			Int#(5) rs2Num = word[24:20];
			Int#(5) rdNum = word[11:7];
			Int#(32) rs1 = regFile.read1(rs1Num);
			Int#(32) rs2 = regFile.read2(rs2Num);
			Int#(11) instr = {func, opcode};
			Bit#(12) imm12 = imm12(word);
			Bit#(20) imm20 = imm20(word);
			
			//JAL AND JALR: https://stackoverflow.com/questions/59150608/offset-address-for-jal-and-jalr-instrctions-in-risc-v
			case (opcode)
			
				`JAL: begin
					//Note: if imm is two complement negative number, the positive value is zeroExtend( ~ (imm - 1))
					Bit#(21) imm21 = imm20 << 1;
					if (imm21[21] == 0) bPc <= ifId.rPc() + extend(imm21);
					else bPc <= ifId.rPc() - zeroExtend( ~ (imm21 - 1));
				 	bTaken <= True;
				 	regFile.write(rdNum, (ifId.rPc() + 4));
			    end
			     
			   	`JALR: begin
			     	if (imm[12] == 0) bPc <= (rs1 + extend(imm12)) & 4094;
			     	else bPc <= (rs1 - zeroExtend( ~ (imm12 - 1))) & 4094;
			        bTaken <= True;
			        regFile.write(rdNum, (ifId.rPc() + 4));
			    end
			     
				`BRANCH: begin
			     	bPc <= ifId.rPc() + signExtend(imm12 << 1);
					case (func) 
						`BEQ: begin
							if (rs1 == rs2) bTaken <= True;
							else bTaken = False;
						end
						
						`BNE: begin
							if (rs1 != rs2) bTaken <= True;
							else bTaken = False;
						end
						
						`BLT: begin
							if (rs1 < rs2) bTaken <= True;
							else bTaken = False;
						end
						
						`BLTU: begin
							if (abs(rs1) < abs(rs2)) bTaken <= True;
							else bTaken = False;
						end
						
						`BGE: begin
							if (rs1 > rs2) bTaken <= True;
							else bTaken = False;
						end
						
						`BGEU: begin
							if (abs(rs1) > abs(rs2)) bTaken <= True;
							else bTaken = False;
						end
						
						default: bTaken = False;	
					endcase
				end
			endcase
			
			idEx.wRs1(rs1);
			idEx.wRs1(rs2);
			idEx.wRdNum(rdNum);
			idEx.wOpcode(opcode);
			idEx.wfunc(func);
			idEx.wImm12(imm12);
			idEx.wImm20(imm20);
		endrule
		
	endmodule: mkStage2
endpackage
