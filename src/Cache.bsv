package Cache;

	`include "Constants.defines"
	
	interface Cache;
		method Bit#(32) read32(Bit#(32) address);
		method Action write32(Bit#(32) address, Bit#(32) value);
		method Bit#(16) read16(Bit#(32) address);
		method Action write16(Bit#(32) address, Bit#(16) value);
		method Bit#(8) read8(Bit#(32) address);
		method Action write8(Bit#(32) address, Bit#(8) value);
		method Action dumpMem();
	endinterface: Cache
	
	module mkCache#(parameter Integer payload[], parameter Integer payloadSize, parameter Integer size, parameter Int#(32) offset) (Cache);
		Bit#(32) _offset = pack(offset);
		Reg#(Bit#(8)) mem[size];
		if (payloadSize > 0)
		begin
			for (Integer k = 0; k < payloadSize; k = k + 1) mem[k] <- mkReg(fromInteger(payload[k]));
			for (Integer k = payloadSize; k < size; k = k + 1) mem[k] <- mkReg(0);
		end
		else begin
			for (Integer k = 0; k < size; k = k + 1) mem[k] <- mkReg(0);
		end
		
		method (Bit#(32)) read32(Bit#(32) address);
		    Bit#(8) val1 = mem[address - _offset];
		    Bit#(8) val2 = mem[address + 1 - _offset];
		    Bit#(8) val3 = mem[address + 2 - _offset];
		    Bit#(8) val4 = mem[address + 3 - _offset];
		    Bit#(32) val = {val4, val3, val2, val1};
			return val;  
		endmethod
		
		method Action write32(Bit#(32) address, Bit#(32) value);
			mem[address - _offset] <= value[7:0];
			mem[address + 1 - _offset] <= value[15:8];
			mem[address + 2 - _offset] <= value[23:16];
			mem[address + 3 - _offset] <= value[31:24];
		endmethod
		
		method (Bit#(16)) read16(Bit#(32) address);
		    Bit#(8) val1 = mem[address - _offset];
		    Bit#(8) val2 = mem[address + 1 - _offset];
		    Bit#(16) val = {val2, val1};
			return val;  
		endmethod
		
		method Action write16(Bit#(32) address, Bit#(16) value);
			mem[address - _offset] <= value[7:0];
			mem[address + 1 - _offset]  <= value[15:8];
		endmethod
		
		method (Bit#(8)) read8(Bit#(32) address);
		    Bit#(8) val = mem[address - _offset];
			return val;  
		endmethod
		
		method Action write8(Bit#(32) address, Bit#(8) value);
			mem[address - _offset] <= value[7:0];
		endmethod
		
		method Action dumpMem();
			Bit#(32) out[7];
			Bit#(32) val;
			Bit#(8) val1;
		    Bit#(8) val2;
		    Bit#(8) val3;
		    Bit#(8) val4;
			
			for (Integer k = 0; k < 7; k = k + 1) begin
				val1 = mem[0 + (4 * k)];
		   		val2 = mem[1 + (4 * k)];
		    	val3 = mem[2 + (4 * k)];
		    	val4 = mem[3 + (4 * k)];
		    	val = {val4, val3, val2, val1};
				out[k] = val;
			end
			`DISPLAY("---start dump memory---")
			`DISPLAY_VAR("val 0 is %0d", out[0])
			`DISPLAY_VAR("val 1 is %0d", out[1])
			`DISPLAY_VAR("val 2 is %0d", out[2])
			`DISPLAY_VAR("val 3 is %0d", out[3])
			`DISPLAY_VAR("val 4 is %0d", out[4])
			`DISPLAY_VAR("val 5 is %0d", out[5])
			`DISPLAY_VAR("val 6 is %0d", out[6])
			`DISPLAY("---end dump memory---")
		endmethod
	endmodule: mkCache
endpackage
