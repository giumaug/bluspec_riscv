package Cache;

	`include "Constants.defines"
	
	interface Cache;
		method Bit#(32) read32(Bit#(32) address);
		method Action write32(Bit#(32) address, Bit#(32) value);
		method Bit#(16) read16(Bit#(32) address);
		method Action write16(Bit#(32) address, Bit#(16) value);
		method Bit#(8) read8(Bit#(32) address);
		method Action write8(Bit#(32) address, Bit#(8) value);
	endinterface: Cache
	
	module mkCache#(parameter Integer payload[], parameter Integer payloadSize, parameter Integer size) (Cache);
		Reg#(Bit#(8)) mem[size];
		if (payloadSize > 0)
		begin
			for (Integer k = 0; k < `PAYLOAD_SIZE; k = k + 1) mem[k] <- mkReg(fromInteger(payload[k]));
			for (Integer k = `PAYLOAD_SIZE; k < size; k = k + 1) mem[k] <- mkReg(0);
		end 
		
		method (Bit#(32)) read32(Bit#(32) address);
		    Bit#(8) val1 = mem[address];
		    Bit#(8) val2 = mem[address + 1];
		    Bit#(8) val3 = mem[address + 2];
		    Bit#(8) val4 = mem[address + 3];
		    Bit#(32) val = {val4, val3, val2, val1};
			return val;  
		endmethod
		
		method Action write32(Bit#(32) address, Bit#(32) value);
			mem[address] <= value[7:0];
			mem[address + 1] <= value[15:8];
			mem[address + 2] <= value[23:16];
			mem[address + 3] <= value[31:24];
		endmethod
		
		method (Bit#(16)) read16(Bit#(32) address);
		    Bit#(8) val1 = mem[address];
		    Bit#(8) val2 = mem[address + 1];
		    Bit#(32) val = {val2, val1};
			return val;  
		endmethod
		
		method Action write16(Bit#(32) address, Bit#(16) value);
			mem[address] <= value[7:0];
			mem[address + 1] <= value[15:8];
		endmethod
		
		method (Bit#(8)) read8(Bit#(32) address);
		    Bit#(8) val = mem[address];
			return val;  
		endmethod
		
		method Action write8(Bit#(32) address, Bit#(8) value);
			mem[address] <= value[7:0];
		endmethod	
	endmodule: mkCache
	
endpackage
