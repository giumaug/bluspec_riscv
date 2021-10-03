package PipeRegs;

/*
	typedef struct {
		Bit#(7) opcode;
		Bit#(5) rd;
		Bit#(3) func3;
		Bit#(5) rs1;
		Bit#(5) rs2;
		Bit#(7) func7;
	} RInstr;
	
	typedef struct {
		Bit#(7) opcode;
		Bit#(5) rd;
		Bit#(3) func3;
		Bit#(5) rs1;
		Bit#(12) imm;
	} IInstr;
	
	typedef struct {
		Bit#(7) opcode;
		Bit#(5) imm1;
		Bit#(3) func3;
		Bit#(5) rs1;
		Bit#(5) rs2;
		Bit#(7) imm2;
	} SInstr;
	
	typedef struct {
		Bit#(7) opcode;
		Bit#(5) rd;
		Bit#(20) imm;
	} UInstr;
	
	typedef union tagged {
		RInstr R;
		IInstr I;
		SInstr S;
		UInstr U;
	} Instr;
*/

	interface IfId;
		method Reg#(Bit#(32)) rPc();
		method Action wPc(Reg#(Bit#(32)) _pc);
		method Bit#(32) rInstr();
		method Action wInstr(Bit#(32) _instr);
	endinterface: IfId

	module mkIfId(IfId);
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

	
/*		
	typedef struct {
	} IdEx;
		
	typedef struct {
	} ExMem;
		
	typedef struct {
	} MemWb;
	
	typedef struct {
	} IfInSigs;
	
	typedef struct {
	} IfOutSigs;
*/

endpackage
