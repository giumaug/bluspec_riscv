package Stage3;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	module mkStage3 #(IdEx idEx, ExMem exMem) (Empty);
	
		rule execute;
			$display("---begin execute---");
			Bit#(32) pc = idEx.rPc();
			Bit#(32) rs1 = signExtend(idEx.rRs1());
			Bit#(32) rs2 = signExtend(idEx.rRs2());
			Bit#(32) imm12 = signExtend(idEx.rImm12());
			//UInt#(32) uRs1 = unpack(zeroExtend(idEx.rRs1()));
			//UInt#(32) uRs2 = unpack(zeroExtend(idEx.rRs2()));
			//UInt#(32) uImm12 = unpack(zeroExtend(idEx.rImm12()));
			Bit#(7) opcode = idEx.rOpcode();
			Bit#(3) func3 = idEx.rFunc3();
			Bit#(7) func7 = idEx.rFunc7();
			Bit#(32) aluOut = 0;
			Bit#(1) opType = 0;
			Bit#(5) shiftImm = idEx.rImm12()[4:0];
			Bit#(5) shiftReg = idEx.rRs2()[4:0];
		
			case (opcode)
				`OPIMM: begin
					opType = 0;
					case (func3)
						`ADDI: begin
							$display("instruction ADDI");
							aluOut = rs1 + imm12;
						end
						`SLTI: begin
							$display("instruction SLTI");
							if (rs1 < imm12) aluOut = 1;
							else aluOut = 0;
						end
						`SLTIU: begin
							$display("instruction SLTIU");
							if (!signedCompare(rs1, imm12)) aluOut = 1;
							else aluOut = 0; 
						end
						`ANDI: begin
							$display("instruction ANDI");
							aluOut = rs1 & imm12;
						end
						`ORI: begin
							$display("instruction ORI");
							aluOut = rs1 | imm12;
						end
						`XORI: begin
							$display("instruction XORI");
							aluOut = rs1 ^ imm12;
						end
						`SLLI: begin
							$display("instruction SLLI");
							aluOut = rs1 << shiftImm;
						end
						`SRLISRAI: begin
							$display("instruction SRLISRAI");
							if (func7 == `SRLI)	aluOut = rs1 >> shiftImm;
							else if (func7 == `SRAI) aluOut = (rs1 >> shiftImm) | {idEx.rRs1()[31:31], 31'b0};
						end
					endcase
				end
				`OP: begin
				    opType = 0;
					case (func3)
						`ADDSUB: begin
							$display("instruction ADDSUB");
							if (func7 == `ADD) aluOut = rs1 + rs2;
						    else if (func7 == `SUB) aluOut = rs1 - rs2;
						end
						`SLT: begin
							$display("instruction SLT");
							if (rs1 < rs2) aluOut = 1;
							else aluOut = 0;
						end
						`SLTU: begin
							$display("instruction SLTU");
							if (!signedCompare(rs1, rs2)) aluOut = 1;
							else aluOut = 0;
						end
						`AND: begin
							$display("instruction AND");
							aluOut = rs1 & rs2;
						end
						`OR: begin
							$display("instruction OR");
							aluOut = rs1 | rs2;
						end
						`XOR: begin
							$display("instruction XOR");
							aluOut = rs1 ^ rs2;
						end
						`SLL: begin
							$display("instruction SLL");
							aluOut = rs1 << shiftReg;
						end
						`SRLSRA: begin
							$display("instruction SRLSRA");
							if (func7 == `SRL) aluOut = rs1 >> shiftReg;
							else if (func7 == `SRA) aluOut = (rs1 >> shiftReg) | {idEx.rRs1()[31:31], 31'b0};
						end
					endcase
				end
				`JAL: begin
					$display("instruction JAL");
					opType = 0;
					aluOut = idEx.rPc() + 4;
				end
				`JALR: begin
					$display("instruction JALR");
					opType = 0;
					aluOut = idEx.rPc() + 4;
				end
				`LUI: begin
					$display("instruction LUI");
					opType = 0;
					aluOut = {(idEx.rImm20 << 12), 12'b0};
				end
				`AUIPC: begin
					$display("instruction AUIPC");
					opType = 0;
					aluOut = {(idEx.rImm20 << 12), 12'b0} + pc;
				end
				`LOAD: begin
					$display("instruction LOAD");
					opType = 1;
					aluOut = rs1 + imm12;
				end
				`STORE: begin
					$display("instruction STORE");
					opType = 1;
					aluOut = rs1 + imm12;
				end		
			endcase
			
			$display("aluOut %d", aluOut);
			$display("rs1 is %d", rs1);
			$display("rs2 is %d", rs2);
			exMem.wAluOut(aluOut);
			exMem.wRdNum(idEx.rRdNum());
			exMem.wRs1(idEx.rRs1);
			exMem.wRs2(idEx.rRs2);
			exMem.wOpType(opType);
			exMem.wOpcode(opcode);
			exMem.wFunc3(func3);
			//Only debug
			exMem.wInstr(idEx.rInstr());
			$display("instr is %0h ", idEx.rInstr());
			$display("---end execute---");
		endrule
	endmodule: mkStage3
endpackage
