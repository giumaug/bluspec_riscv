package PipeRegs;

	interface IfId;
		method Reg#(Bit#(32)) rPc();
		method Action wPc(Reg#(Bit#(32)) _pc);
		method Bit#(32) rInstr();
		method Action wInstr(Bit#(32) _instr);
	endinterface: IfId
	
	interface IdEx;
		method Reg#(Bit#(32)) rRs1();
		method Action wRs1(Reg#(Bit#(32)) _rs1);
		method Reg#(Bit#(32)) rRs2();
		method Action wRs2(Reg#(Bit#(32)) _rs2);
		method Reg#(Bit#(32)) rRdNum();
		method Action wRdNum(Reg#(Bit#(32)) _rdNum);
		method Reg#(Bit#(12)) rImm12();
		method Action wImm12(Reg#(Bit#(12)) _imm);
		method Reg#(Bit#(20)) rImm20();
		method Action wImm20(Reg#(Bit#(20)) _imm);
		method Reg#(Bit#(5) rOpcode();
		method Action wOpcode(Reg#(Bit#(5)) _opcode);
		method Reg#(Bit#(3) rfunc();
		method Action wfunc(Reg#(Bit#(3) _func);
		method Reg#(Bit#(32)) rPc();
		method Action wPc(Reg#(Bit#(32)) _pc);
	endinterface: IfEx
	
	interface ExMem;
		method Reg#(Bit#(32)) rRs1();
		method Action wRs1(Reg#(Bit#(32)) _rs1);
		method Reg#(Bit#(32)) rRs2();
		method Action wRs2(Reg#(Bit#(32)) _rs2);
		method Reg#(Bit#(32)) rRdNum();
		method Action wRdNum(Reg#(Bit#(32)) _rdNum);
		method Reg#(Bit#(32)) rAluOut();
		method Action wAluOut(Reg#(Bit#(32)) _rdNum);
		method Reg#(Bit#(5) rOpcode();
		method Action wOpcode(Reg#(Bit#(5)) _opcode);
		method Reg#(Bit#(3) rfunc();
		method Action wfunc(Reg#(Bit#(3) _func);
	endinterface: ExMem

	module mkIfId(IfId);
		//pc refers to current instruction
		Reg#(Bit#(32)) pc <- mkReg(0);
		Reg#(Bit#(32)) instr <- mkReg(0);
		
		method Reg#(Bit#(32)) rPc();
			return pc;
		endmethod
		
		method Action wPc(Reg#(Bit#(32)) _pc);
			pc <= _pc;
		endmethod
		
		method Bit#(32) rInstr();
			return instr;
		endmethod
		
		method Action wInstr(Bit#(32) _instr);
			instr <= _instr;
		endmethod
	endmodule: mkIfId
	
	module mkIdEx(IdEx);
		Reg#(Bit#(32)) rs1 <- mkReg(0);
		Reg#(Bit#(32)) rs2 <- mkReg(0);
		Reg#(Bit#(32)) rdNum <- mkReg(0);
		Reg#(Bit#(12)) imm12 <- mkReg(0);
		Reg#(Bit#(20)) imm20 <- mkReg(0);
		Reg#(Bit#(5)) opcode <- mkReg(0);
		Reg#(Bit#(3)) func <- mkReg(0);
		
		method Reg#(Bit#(32)) rRs1();
			return rs1;
		endmethod
		
		method Action wRs1(Reg#(Bit#(32)) _rs1);
			rs1 <= _rs1;
		endmethod
		
		method Reg#(Bit#(32)) rRs2();
			return rs2;
		endmethod
		
		method Action wRs2(Reg#(Bit#(32)) _rs2);
			rs2 <= _rs2;
		endmethod
		
		method Reg#(Bit#(32)) rRdNum();
			return rdNum;
		endmethod
		
		method Action wRdNum(Reg#(Bit#(32)) _rdNum);
			rdNum <= _rdNum;
		endmethod
		
		method Reg#(Bit#(12)) rImm12();
			return imm12;
		endmethod
		
		method Action wImm(Reg#(Bit#(12)) _imm12);
			imm12 <= _imm12;
		endmethod
		
		method Reg#(Bit#(20)) rImm20();
			return imm20;
		endmethod
		
		method Action wImm(Reg#(Bit#(20)) _imm20);
			imm20 <= _imm20;
		endmethod
		
		method Reg#(Bit#(5)) rOpcode();
			return opcode;
		endmethod
		
		method Action wOpcode(Reg#(Bit#(5)) _opcode);
			opcode <= _opcode;
		endmethod
		
		method Reg#(Bit#(3)) rFunc();
			return func;
		endmethod
		
		method Action wFunc(Reg#(Bit#(3)) _func);
			func <= _func;
		endmethod
	endmodule: mkIdEx
		
	module mkExMem(ExMem);
		Reg#(Bit#(32)) rs1 <- mkReg(0);
		Reg#(Bit#(32)) rs2 <- mkReg(0);
		Reg#(Bit#(32)) rdNum <- mkReg(0);
		Reg#(Bit#(32)) aluOut <- mkReg(0);
		Reg#(Bit#(5)) opcode <- mkReg(0);
		Reg#(Bit#(3)) func <- mkReg(0);----------------qui mettere get and set!!!!
		
		method Reg#(Bit#(32)) rRs1();
			return rs1;
		endmethod
		
		method Action wRs1(Reg#(Bit#(32)) _rs1);
			rs1 <= _rs1;
		endmethod
		
		method Reg#(Bit#(32)) rRs2();
			return rs2;
		endmethod
		
		method Action wRs2(Reg#(Bit#(32)) _rs2);
			rs2 <= _rs2;
		endmethod
			
		method Reg#(Bit#(32)) rRdNum();
			return rdNum;
		endmethod
		
		method Action wRdNum(Reg#(Bit#(32)) _rdNum);
			rdNum <= _rdNum;
		endmethod
		
		method Reg#(Bit#(32)) rAluOut();
			return aluOut;
		endmethod
		
		method Action wAluOut(Reg#(Bit#(32)) _aluOut);
			aluOut <= _aluOut;
		endmethod
	endmodule: mkExMem

endpackage
