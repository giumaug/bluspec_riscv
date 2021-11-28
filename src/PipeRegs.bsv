package PipeRegs;

	interface IfId;
		method Bit#(32) rPc();
		method Action wPc(Bit#(32) _pc);
		method Bit#(32) rInstr();
		method Action wInstr(Bit#(32) _instr);
	endinterface: IfId
	
	interface IdEx;
		method Bit#(32) rPc();
		method Action wPc(Bit#(32) _pc);
		method Bit#(32) rRs1();
		method Action wRs1(Bit#(32) _rs1);
		method Bit#(32) rRs2();
		method Action wRs2(Bit#(32) _rs2);
		method Bit#(5) rRdNum();
		method Action wRdNum(Bit#(5) _rdNum);
		method Bit#(12) rImm12();
		method Action wImm12(Bit#(12) _imm);
		method Bit#(20) rImm20();
		method Action wImm20(Bit#(20) _imm);
		method Bit#(7) rOpcode();
		method Action wOpcode(Bit#(7) _opcode);
		method Bit#(3) rFunc3();
		method Action wFunc3(Bit#(3) _func3);
		method Bit#(7) rFunc7();
		method Action wFunc7(Bit#(7) _func7);
	endinterface: IdEx
	
	interface ExMem;
		method Bit#(32) rRs1();
		method Action wRs1(Bit#(32) _rs1);
		method Bit#(32) rRs2();
		method Action wRs2(Bit#(32) _rs2);
		method Bit#(5) rRdNum();
		method Action wRdNum(Bit#(5) _rdNum);
		method Bit#(32) rAluOut();
		method Action wAluOut(Bit#(32) _aluOut);
		method Bit#(7) rOpcode();
		method Action wOpcode(Bit#(7) _opcode);
		method Bit#(1) rOpType();
		method Action wOpType(Bit#(1) _opType);
	endinterface: ExMem
	
	interface MemWb;
		method Bit#(32) rMemOut();
		method Action wMemOut(Bit#(32) _memOut);
		method Bit#(5) rRdNum();
		method Action wRdNum(Bit#(5) _rdNum);
		method Bit#(32) rAluOut();
		method Action wAluOut(Bit#(32) _aluOut);
		method Bit#(1) rOpType();
		method Action wOpType(Bit#(1) _opType);
	endinterface: MemWb
	
	module mkIfId(IfId);
		//pc refers to current instruction
		Reg#(Bit#(32)) pc <- mkReg(0);
		Reg#(Bit#(32)) instr <- mkReg(0);
		
		method Bit#(32) rPc();
			return pc;
		endmethod
		
		method Action wPc(Bit#(32) _pc);
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
		Reg#(Bit#(32)) pc <- mkReg(0);
		Reg#(Bit#(32)) rs1 <- mkReg(0);
		Reg#(Bit#(32)) rs2 <- mkReg(0);
		Reg#(Bit#(5)) rdNum <- mkReg(0);
		Reg#(Bit#(12)) imm12 <- mkReg(0);
		Reg#(Bit#(20)) imm20 <- mkReg(0);
		Reg#(Bit#(7)) opcode <- mkReg(0);
		Reg#(Bit#(3)) func3 <- mkReg(0);
		Reg#(Bit#(7)) func7 <- mkReg(0);
		
		method Bit#(32) rPc();
			return pc;
		endmethod
		
		method Action wPc(Bit#(32) _pc);
			pc <= _pc;
		endmethod
		
		method Bit#(32) rRs1();
			return rs1;
		endmethod
		
		method Action wRs1(Bit#(32) _rs1);
			rs1 <= _rs1;
		endmethod
		
		method Bit#(32) rRs2();
			return rs2;
		endmethod
		
		method Action wRs2(Bit#(32) _rs2);
			rs2 <= _rs2;
		endmethod
		
		method Bit#(5) rRdNum();
			return rdNum;
		endmethod
		
		method Action wRdNum(Bit#(5) _rdNum);
			rdNum <= _rdNum;
		endmethod
		
		method Bit#(12) rImm12();
			return imm12;
		endmethod
		
		method Action wImm12(Bit#(12) _imm12);
			imm12 <= _imm12;
		endmethod
		
		method Bit#(20) rImm20();
			return imm20;
		endmethod
		
		method Action wImm20(Bit#(20) _imm20);
			imm20 <= _imm20;
		endmethod
		
		method Bit#(7) rOpcode();
			return opcode;
		endmethod
		
		method Action wOpcode(Bit#(7) _opcode);
			opcode <= _opcode;
		endmethod
		
		method Bit#(3) rFunc3();
			return func3;
		endmethod
		
		method Action wFunc3(Bit#(3) _func3);
			func3 <= _func3;
		endmethod
		
		method Bit#(7) rFunc7();
			return func7;
		endmethod
		
		method Action wFunc7(Bit#(7) _func7);
			func7 <= _func7;
		endmethod
	endmodule: mkIdEx
		
	module mkExMem(ExMem);
		Reg#(Bit#(32)) rs1 <- mkReg(0);
		Reg#(Bit#(32)) rs2 <- mkReg(0);
		Reg#(Bit#(5)) rdNum <- mkReg(0);
		Reg#(Bit#(32)) aluOut <- mkReg(0);
		Reg#(Bit#(7)) opcode <- mkReg(0);
		Reg#(Bit#(1)) opType <- mkReg(0);
		
		method Bit#(32) rRs1();
			return rs1;
		endmethod
		
		method Action wRs1(Bit#(32) _rs1);
			rs1 <= _rs1;
		endmethod
		
		method Bit#(32) rRs2();
			return rs2;
		endmethod
		
		method Action wRs2(Bit#(32) _rs2);
			rs2 <= _rs2;
		endmethod
			
		method Bit#(5) rRdNum();
			return rdNum;
		endmethod
		
		method Action wRdNum(Bit#(5) _rdNum);
			rdNum <= _rdNum;
		endmethod
		
		method Bit#(32) rAluOut();
			return aluOut;
		endmethod
		
		method Action wAluOut(Bit#(32) _aluOut);
			aluOut <= _aluOut;
		endmethod
		
		method Bit#(7) rOpcode();
			return opcode;
		endmethod
		
		method Action wOpcode(Bit#(7) _opcode);
			opcode <= _opcode;
		endmethod
		
		method Bit#(1) rOpType();
			return opType;
		endmethod
		
		method Action wOpType(Bit#(1) _opType);
			opType <= _opType;
		endmethod
	endmodule: mkExMem
	
	module mkMemWb(MemWb);
		Reg#(Bit#(32)) memOut <- mkReg(0);
		Reg#(Bit#(5)) rdNum <- mkReg(0);
		Reg#(Bit#(32)) aluOut <- mkReg(0);
		Reg#(Bit#(1)) opType <- mkReg(0);
		
		method Bit#(32) rMemOut();
			return memOut;
		endmethod
		
		method Action wMemOut(Bit#(32) _memOut);
			memOut <= _memOut;
		endmethod
		
		method Bit#(5) rRdNum();
			return rdNum;
		endmethod
		
		method Action wRdNum(Bit#(5) _rdNum);
			rdNum <= _rdNum;
		endmethod
		
		method Bit#(32) rAluOut();
			return aluOut;
		endmethod
		
		method Action wAluOut(Bit#(32) _aluOut);
			aluOut <= _aluOut;
		endmethod
		
		method Bit#(1) rOpType();
			return opType;
		endmethod
		
		method Action wOpType(Bit#(1) _opType);
			opType <= _opType;
		endmethod
	endmodule: mkMemWb
endpackage
