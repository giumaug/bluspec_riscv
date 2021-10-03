package RegisterFile;

	interface RegFile;
		method Bit#(32) read1(Bit#(32) regNum);
		method Bit#(32) read2(Bit#(32) regNum);
		method Action write(Bit#(32) regNum, Bit#(32) value);
	endinterface: RegFile
	
	module mkRegFile(RegFile);
		Reg#(Bit#(32)) regs[32];
		
		for (int k = 0; k < 10; k = k + 1) regs[k] <- mkReg(0);
	
		method (Bit#(32)) read1(Bit#(32) regNum);
			return regs[regNum];
		endmethod
		
		method (Bit#(32)) read2(Bit#(32) regNum);
			return regs[regNum];
		endmethod
		
		method Action write(Bit#(32) regNum, Bit#(32) value);
			regs[regNum] <= value;
		endmethod
	endmodule: mkRegFile
	
endpackage	
