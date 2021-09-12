package RegisterFile;

	interface RegFile;
		method Bit#(Int) read1(Bit#(Int) regNum);
		method Bit#(Int) read2(Bit#(Int) regNum);
		method Action write(Bit#(Int) regNum, Bit#(32) value);
	endinterface: RegFile
	
	(*synthesize*)
	module mkRegFile(Mem);
		Reg#(Bit#(32)) regs[32];
	
		method (Bit#(32)) read1(Bit#(32) regNum);
			return regs[regNum];
		endmethod
		
		method (Bit#(32)) read2(Bit#(32) regNum);
			return regs[regNum];
		endmethod
		
		method Action write(Bit#(32) regNum, Bit#(32) value);
			Mem[regNum] <= value;
		endmethod
	endmodule: mkRegFile
	
endpackage	
