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
			$display("---begin decode---");
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
			        	$display("instruction JALR");
			    	end
					`BRANCH: begin
						imm12 = rImm12B(word);
			     		_bPc = ifId.rPc() + signExtend(imm12 << 1);
			     		_rdNum = 0;
						case (func3) 
							`BEQ: begin
								if (rs1 == rs2) _bTaken = True;
								else _bTaken = False;
								$display("instruction JALR");
							end	
							`BNE: begin
								if (rs1 != rs2) _bTaken = True;
								else _bTaken = False;
								$display("instruction BNE");
							end
							`BLT: begin
								if (rs1 < rs2) _bTaken = True;
								else _bTaken = False;
								$display("instruction BLT");
							end
							`BLTU: begin
								if (abs(rs1) < abs(rs2)) _bTaken = True;
								else _bTaken = False;
								$display("instruction BLTU");
							end
							`BGE: begin
								if (rs1 > rs2) _bTaken = True;
								else _bTaken = False;
							end
							`BGEU: begin
								if (abs(rs1) > abs(rs2)) _bTaken = True;
								else _bTaken = False;
								$display("instruction BGEU");
							end
							//default: bTaken <= False;
						endcase
					end
					`STORE: begin
						_rdNum = 0;
						_bTaken = False;
						_bPc = 0;
						imm12 = rImm12S(word);
						$display("instruction STORE");
					end
					`LOAD: begin
						_bTaken = False;
						_bPc = 0;
						imm12 = rImm12I(word);
						$display("instruction LOAD");
					end
					`OPIMM: begin
						imm12 = rImm12I(word);
						$display("instruction OPIMM");
					end
					default: begin
						$display("instruction DEFAULT");
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
			$display("instr is %0h ", ifId.rInstr());
			$display("bpc %d", _bPc);
			$display("bTaken %d", _bTaken);
			$display("imm12 %d", imm12);
			$display("imm20 %d", imm20);
			$display("rs1Num is %d", rs1Num);
			$display("rs2Num is %d", rs2Num);
			$display("_rdNum is %d", _rdNum);
			$display("rd is %d", rd);
			$display("rdNum is %d", rdNum);
			$display("rs1 is %d", rs1);
			$display("rs2 is %d", rs2);
			$display("---end decode---");
		endrule
		
		rule doStall;
			$display("---begin doStall---");
			Bool _stall;
			Bit#(32) word = ifId.rInstr();
			Bit#(7) opcode = word[6:0]; 
			Bit#(5) rs1Num = word[19:15]; 
			Bit#(5) rs2Num = word[24:20];
			
			_stall = dataHazardUnit.doStall(opcode, rs1Num, rs2Num);
			stall <= _stall;
			$display("instr is %0h ", ifId.rInstr());
			$display("rs1Num is %d", rs1Num);
			$display("rs2Num is %d", rs2Num);
			$display("idEx.rRdNum is %d", idEx.rRdNum());
			$display("exMem.rRdNum is %d", exMem.rRdNum());
			$display("memWb.rRdNum is %d", memWb.rRdNum());
			$display("doStall is %d", _stall);
			$display("---end doStall---");
		endrule
	endmodule: mkStage2
endpackage
