package Stage2;

	`include "Constants.defines"
	import Cache::*;
	import PipeRegs::*;
	import DataHazardUnit::*;
	import RegisterFile::*;
	import Utils::*;
	
	module mkStage2#(IfId ifId, IdEx idEx, Wire#(Bool) bTaken, Wire#(Bit#(32)) bPc, Wire#(Bit#(32)) rd, DataHazardUnit dataHazardUnit, Wire#(Bool) stall) (Empty);
	
		RegFile regFile <- mkRegFile();
		
		rule decode;
			Bit#(32) pc = ifId.rPc();
			Bit#(32) word = ifId.rInstr();
			Bit#(7) opcode = word[6:0]; 
			Bit#(3) func3 = word[14:12];
			Bit#(7) func7 = word[31:25];
			Bit#(5) rs1Num = word[19:15]; 
			Bit#(5) rs2Num = word[24:20];
			Bit#(5) rdNum = word[11:7];
			Bit#(32) rs1 = regFile.read1(rs1Num);
			Bit#(32) rs2 = regFile.read2(rs2Num);
			//Int#(11) instr = {func, opcode};
			Bit#(12) imm12 = rImm12(word);
			Bit#(20) imm20 = rImm20(word);
			//Bool _stall;
			
			regFile.write(rdNum, rd);
			//_stall = dataHazardUnit.doStall(opcode, rs1Num, rs2Num);
			if (stall == False) begin
				//JAL AND JALR: https://stackoverflow.com/questions/59150608/offset-address-for-jal-and-jalr-instrctions-in-risc-v
				case (opcode)
					`JAL: begin
						//Note: if imm is two complement negative number, the positive value is zeroExtend( ~ (imm - 1))
						Bit#(21) imm21 = {(imm20 << 1), 1'b0};
						if (imm21[20] == 0) bPc <= ifId.rPc() + extend(imm21);
						else bPc <= ifId.rPc() - zeroExtend( ~ (imm21 - 1));
				 		bTaken <= True;
			    	end
			   		`JALR: begin
			     		if (imm12[11] == 0) bPc <= (rs1 + extend(imm12)) & 4094;
			     		else bPc <= (rs1 - zeroExtend( ~ (imm12 - 1))) & 4094;
			        	bTaken <= True;
			    	end
					`BRANCH: begin
			     		bPc <= ifId.rPc() + signExtend(imm12 << 1);
						case (func3) 
							`BEQ: begin
								if (rs1 == rs2) bTaken <= True;
								else bTaken <= False;
							end	
							`BNE: begin
								if (rs1 != rs2) bTaken <= True;
								else bTaken <= False;
							end
							`BLT: begin
								if (rs1 < rs2) bTaken <= True;
								else bTaken <= False;
							end
							`BLTU: begin
								if (abs(rs1) < abs(rs2)) bTaken <= True;
								else bTaken <= False;
							end
							`BGE: begin
								if (rs1 > rs2) bTaken <= True;
								else bTaken <= False;
							end
							`BGEU: begin
								if (abs(rs1) > abs(rs2)) bTaken <= True;
								else bTaken <= False;
							end
							default: bTaken <= False;	
						endcase
					end
				endcase
			
				idEx.wPc(pc);
				idEx.wRs1(rs1);
				idEx.wRs2(rs2);
				idEx.wRdNum(rdNum);
				idEx.wOpcode(opcode);
				idEx.wFunc3(func3);
				idEx.wFunc7(func7);
				idEx.wImm12(imm12);
				idEx.wImm20(imm20);
		 	end
			else begin
				idEx.wPc(0);
				idEx.wRs1(0);
				idEx.wRs2(0);
				idEx.wRdNum(0);
				idEx.wOpcode(`OPIMM);
				idEx.wFunc3(`ADDI);
				idEx.wImm12(0);
				idEx.wImm20(0);
			end
			//stall <= _stall;
		endrule
		
		rule doStall;
			Bit#(32) word = ifId.rInstr();
			Bit#(7) opcode = word[6:0]; 
			Bit#(5) rs1Num = word[19:15]; 
			Bit#(5) rs2Num = word[24:20];
			
			stall <= dataHazardUnit.doStall(opcode, rs1Num, rs2Num);
		endrule
	endmodule: mkStage2
endpackage
