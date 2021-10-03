package Cache;

	`include "Constants.defines"
	
	interface Cache;
		method Bit#(32) read(Bit#(32) address);
		method Action write(Bit#(32) address, Bit#(32) value);
	endinterface: Cache
	
	module mkCache#(parameter Integer payload[], parameter Integer payloadSize, parameter Integer size) (Cache);
		Reg#(Bit#(32)) mem[size];
		if (payloadSize > 0)
		begin
			for (Integer k = 0; k < `PAYLOAD_SIZE; k = k + 1) mem[k] <- mkReg(fromInteger(payload[k]));
			for (Integer k = `PAYLOAD_SIZE; k < size; k = k + 1) mem[k] <- mkReg(0);
		end 
		
		method (Bit#(32)) read(Bit#(32) address);
			return mem[address];  
		endmethod
		
		method Action write(Bit#(32) address, Bit#(32) value);
			mem[address] <= value;
		endmethod
	endmodule: mkCache
	
endpackage
