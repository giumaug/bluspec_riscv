package Memory;

	interface Mem;
		method Bit#(32) read(Bit#(32) address);
		method Action write(Bit#(32) address, Bit#(32) value);
	endinterface: Mem
	
	(*synthesize*)
	module mkMem#(parameter int size, int[] payload, int payloadSize) (Mem);
		Reg#(Bit#(32)) mem[size];
		
		//Memory initialization
		for (int k = 0; k < size; k = k + 1) mem[k] <- mkReg(0);
		if (payloadSize > 0)
		begin
			for (int k = 0; k < payloadSize; k = k + 1) mem[k] <= payload[k];
		end
		
		method (Bit#(32)) read(Bit#(32) address);
			return mem[address];
		endmethod
		
		method Action write(Bit#(32) address, Bit#(32) value);
			Mem[address] <= value;
		endmethod
	endmodule: mkMem	
	
endpackage
