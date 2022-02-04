package Stage2;

	`include "Constants.defines"
	import Cache::*;
	import PipeRegs::*;
	import DataHazardUnit::*;
	import RegisterFile::*;
	import Utils::*;
	
	//module mkStage2#(IfId ifId, IdEx idEx, Wire#(Bool) bTaken, Wire#(Bit#(32)) bPc, Wire#(Bit#(32)) rd, Wire#(Bit#(5)) rdNum, DataHazardUnit dataHazardUnit, Wire#(Bool) stall) (Empty);
	//Only debug
	module mkStage2#(IfId ifId, IdEx idEx, ExMem exMem, MemWb memWb, Wire#(Bool) bTaken, Wire#(Bit#(32)) bPc, Wire#(Bit#(32)) rd, Wire#(Bit#(5)) rdNum, DataHazardUnit dataHazardUnit, Wire#(Bool) stall) (Empty);
	
		RegFile regFile <- mkRegFile();
		
		rule decode;
			`DISPLAY("---begin decode---")
			Bit#(32) pc = ifId.rPc();
			Bit#(32) word = ifId.rInstr();
			Bit#(7) opcode = word[6:0]; 
			Bit#(3) func3 = word[14:12];
			Bit#(7) func7 = word[31:25];
			Bit#(5) rs1Num = word[19:15]; 
			Bit#(5) rs2Num = word[24:20];
			Bit#(5) _rdNum = word[11:7];
			Bit#(32) rs1 <- regFile.read1(rs1Num);
			Bit#(32) rs2 <- regFile.read2(rs2Num);
			Bit#(12) imm12 = 0;
			Bit#(20) imm20 = 0;
			Bit#(32) _bPc = 0;
			Bool _bTaken = False;
			
			regFile.write(rdNum, rd);
			//Bool _stall = dataHazardUnit.doStall(opcode, rs1Num, rs2Num);
			if (stall == False) begin
				//JAL AND JALR: https://stackoverflow.com/questions/59150608/offset-address-for-jal-and-jalr-instrctions-in-risc-v
				case (opcode)
					`JAL: begin
						//Note: if imm is two complement negative number, the positive value is zeroExtend( ~ (imm - 1))
						imm20 = rImm20(word);
						Bit#(21) imm21 = {imm20, 1'b0};
						if (imm21[20] == 0) _bPc = ifId.rPc() + extend(imm21);
						else _bPc = ifId.rPc() - zeroExtend( ~ (imm21 - 1));
				 		_bTaken = True;
			    	end
			   		`JALR: begin
			   			imm12 = rImm12I(word);
			     		if (imm12[11] == 0) _bPc = (rs1 + extend(imm12)) & 4094;
			     		else _bPc = (rs1 - zeroExtend( ~ (imm12 - 1))) & 4094;
			        	_bTaken = True;
			        	`DISPLAY("instruction JALR")
			    	end
					`BRANCH: begin
						imm12 = rImm12B(word);
			     		_bPc = ifId.rPc() + signExtend(imm12 << 1);
			     		_rdNum = 0;
						case (func3) 
							`BEQ: begin
								if (rs1 == rs2) _bTaken = True;
								else _bTaken = False;
								`DISPLAY("instruction JALR")
							end	
							`BNE: begin
								if (rs1 != rs2) _bTaken = True;
								else _bTaken = False;
								`DISPLAY("instruction BNE")
							end
							`BLT: begin
								if (rs1 < rs2) _bTaken = True;
								else _bTaken = False;
								`DISPLAY("instruction BLT")
							end
							`BLTU: begin
								if (abs(rs1) < abs(rs2)) _bTaken = True;
								else _bTaken = False;
								`DISPLAY("instruction BLTU")
							end
							`BGE: begin
								if (rs1 > rs2) _bTaken = True;
								else _bTaken = False;
							end
							`BGEU: begin
								if (abs(rs1) > abs(rs2)) _bTaken = True;
								else _bTaken = False;
								`DISPLAY("instruction BGEU")
							end
							//default: bTaken <= False;
						endcase
					end
					`STORE: begin
						_rdNum = 0;
						_bTaken = False;
						_bPc = 0;
						imm12 = rImm12S(word);
						`DISPLAY("instruction STORE")
					end
					`LOAD: begin
						_bTaken = False;
						_bPc = 0;
						imm12 = rImm12I(word);
						`DISPLAY("instruction LOAD")
					end
					`OPIMM: begin
						imm12 = rImm12I(word);
						`DISPLAY("instruction OPIMM")
					end
					default: begin
						`DISPLAY("instruction DEFAULT")
						_bTaken = False;
						_bPc = 0;
					end
				endcase
				
				bTaken <= _bTaken;
				bPc <= _bPc;
			
				idEx.wPc(pc);
				idEx.wRs1(rs1);
				idEx.wRs2(rs2);
				idEx.wRdNum(_rdNum);
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
			//Only debug
			idEx.wInstr(ifId.rInstr());
			`DISPLAY_VAR("instr is %0h ", ifId.rInstr())
			`DISPLAY_VAR("bpc %d", _bPc)
			`DISPLAY_VAR("bTaken %d", _bTaken)
			`DISPLAY_VAR("imm12 %d", imm12)
			`DISPLAY_VAR("imm20 %d", imm20)
			`DISPLAY_VAR("rs1Num is %d", rs1Num)
			`DISPLAY_VAR("rs2Num is %d", rs2Num)
			`DISPLAY_VAR("_rdNum is %d", _rdNum)
			`DISPLAY_VAR("rd is %d", rd)
			`DISPLAY_VAR("rdNum is %d", rdNum)
			`DISPLAY_VAR("rs1 is %d", rs1)
			`DISPLAY_VAR("rs2 is %d", rs2)
			`DISPLAY("---end decode---")
		endrule
		
		rule doStall;
			`DISPLAY("---begin doStall---")
			Bool _stall;
			Bit#(32) word = ifId.rInstr();
			Bit#(7) opcode = word[6:0]; 
			Bit#(5) rs1Num = word[19:15]; 
			Bit#(5) rs2Num = word[24:20];
			
			_stall = dataHazardUnit.doStall(opcode, rs1Num, rs2Num);
			stall <= _stall;
			`DISPLAY_VAR("instr is %0h ", ifId.rInstr())
			`DISPLAY_VAR("rs1Num is %d", rs1Num)
			`DISPLAY_VAR("rs2Num is %d", rs2Num)
			`DISPLAY_VAR("idEx.rRdNum is %d", idEx.rRdNum())
			`DISPLAY_VAR("exMem.rRdNum is %d", exMem.rRdNum())
			`DISPLAY_VAR("memWb.rRdNum is %d", memWb.rRdNum())
			`DISPLAY_VAR("doStall is %d", _stall)
			`DISPLAY("---end doStall---")
		endrule
	endmodule: mkStage2
endpackage
