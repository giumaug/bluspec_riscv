package BluespecRiscv;

	import DataTypes :: * ;

	(*synthesize*)
	module mkRiscv(Empty);
		int payload[10];
		int payloadSize;
       
        payload[0] = 0;
        payload[1] = 1;
        payload[2] = 2;
        payload[3] = 3;
        payload[4] = 4;
        payload[5] = 5;
        payload[6] = 6;
        payload[7] = 7;
        payload[8] = 8;
        payload[9] = 9;
        payloadSize = 0;
        
        Reg#(int) counter <- mkReg (0);
		Mem dataMem <- mkMem(DATA_CACHE_SIZE, payload, 0, 0);
		Mem instMem <- mkMem(INST_CACHE_SIZE, payload, payloadSize);
		RegFile regFile <- mkRegFile();
		
		IfId ifId <- mkIfId();
		Wire#(Bool) bTaken <- mkWire(); 
		Wire#(Bool) bPc <- mkWire(); 
		mkStage1 stage1 <- mkStage1(ifId, bTaken, bPc);
	
		rule testbench;
			$display("counter is = %0d", counter);
			$display("instruction read is = %0d", ifId.rInstr());
			counter <= counter + 1;
			if (count >= 10) $finish (0);
		endrule
	
	endmodule: mkRiscv

endpackage
