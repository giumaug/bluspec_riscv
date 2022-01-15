package RegisterFile;

	`include "Constants.defines"

	interface RegFile;
		method ActionValue#(Bit#(32)) read1(Bit#(5) regNum);
		method ActionValue#(Bit#(32)) read2(Bit#(5) regNum);
		method Action write(Bit#(5) regNum, Bit#(32) value);
	endinterface: RegFile
	
	module mkRegFile(RegFile);
		Reg#(Bit#(32)) regs[32];
		
		for (int k = 0; k < 2; k = k + 1) regs[k] <- mkReg(0);
		//Dirty temporary trick. It's up to software to inizialize the stack pointer.
		regs[2] <- mkReg(`STACK_ADDRESS);
		for (int k = 3; k < 32; k = k + 1) regs[k] <- mkReg(0);
		
	
		method ActionValue#(Bit#(32)) read1(Bit#(5) regNum);
    		//$display("reg 8 is %d",regs[8]);
    		//$display("reg 2 is %d",regs[2]);
			return regs[regNum];
		endmethod
		
		method ActionValue#(Bit#(32)) read2(Bit#(5) regNum);
			//$display("reg 8 is %d",regs[8]);
			//$display("reg 2 is %d",regs[2]);
			return regs[regNum];
		endmethod
		
		method Action write(Bit#(5) regNum, Bit#(32) value);
		    //$display("writing regNum %d", regNum);
		    //$display("writing value  %d", value);
			regs[regNum] <= value;
		endmethod
	endmodule: mkRegFile
endpackage	
