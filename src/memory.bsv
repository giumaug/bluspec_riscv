package Memory;

	interface Mem;
		method Bit#(32) read(Bit#(32) address);
		method Action write(Bit#(32) address, Bit#(32) value);
	endinterface: Mem
	
	(*synthesize*)
	module mkMem#(parameter int size) (Mem);
		Reg#(Bit#(32)) mem[size];
		
		method (Bit#(32)) read(Bit#(32) address);
			return mem[address];
		endmethod
		
		method Action write(Bit#(32) address, Bit#(32) value);
			Mem[address] <= value;
		endmethod
	endmodule: mkMem	
	
endpackage
