package MemoryController;

	`include "Constants.defines"
	
	interface MemoryController;
		method Bit#(32) read32(Bit#(32) address, Bit#(1) opType);
		method Action write32(Bit#(32) address, Bit#(32) value);
		method Bit#(16) read16(Bit#(32) address);
		method Action write16(Bit#(32) address, Bit#(16) value);
		method Bit#(8) read8(Bit#(32) address);
		method Action write8(Bit#(32) address, Bit#(8) value);
	endinterface: MemoryController
	
	module mkMemoryController#(Wire#(Bit#(4) led)) (MemoryController);
		Integer instrPayloadSize =  `PAYLOAD_SIZE;
		Integer instrSize = `INST_CACHE_SIZE;
		Integer intrPayload[payloadSize];
        //Expand payload here
        `PAYLOAD
        
        Integer dataPayloadSize =  `DATA_PAYLOAD_SIZE;
		Integer dataSize = `DATA_CACHE_SIZE;
		Integer dataPayload[payloadSize];
        //Expand payload here
        `DATA_PAYLOAD
	
		Cache instrCache <- mkCache(instrPayload, instrPayloadSize, instrSize, `INST_CACHE_OFFSET);
		Cache dataCache <- mkCache(dataPayload, dataPayloadSize, dataSize, `DATA_CACHE_OFFSET);
		
		method (Bit#(32)) read32(Bit#(32) address, Bit#(1) opType);
			Bit#(32) val = 0;
			if (opType == 0) val = dataCache.read32(address);
			else if (opType == 1) val = instrCache.read32(address);
		   	return val;
		endmethod
		
		method Action write32(Bit#(32) address, Bit#(32) value, Bit#(1) opType);
			if (opType == 0) dataCache.write32(address, value);
			else if (opType == 1) instrCache.write32(address, value);
		endmethod
		
		method (Bit#(16)) read16(Bit#(32) address,);
			Bit#(16) val = 0;
			if (opType == 0) val = dataCache.read16(address);
			else if (opType == 1) val =  instrCache.read16(address);
		   	return val;  
		endmethod
		
		method Action write16(Bit#(32) address, Bit#(16) value, Bit#(1) opType);
			if (opType == 0) dataCache.write16(address, value);
			else if (opType == 1) instrCache.write16(address, value);	
		endmethod
		
		method (Bit#(8)) read8(Bit#(32) address, Bit#(1) opType);
			Bit#(8) val = 0;
			if (opType == 0) val = dataCache.read8(address);
			else if (opType == 1) val = instrCache.read8(address);
		   	return val;
		endmethod
		
		method Action write8(Bit#(32) address, Bit#(8) value, Bit#(1) opType);
			if (opType == 0) begin 
				if (address == `LED_ADDRESS) led <= value;
				else dataCache.write8(address, value);
			end
			else if (opType == 1) instrCache.write8(address, value);
		endmethod
	
	endmodule: mkMemoryController
endpackage
