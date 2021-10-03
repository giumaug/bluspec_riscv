package BluespecRiscv;

	import PipeRegs :: * ;
	import Stage1 :: * ;

	(*synthesize*)
	module mkRiscv(Empty);
        Reg#(int) counter <- mkReg (0);
		Reg#(Bool) bTaken <- mkReg(False); 
		Reg#(Bit#(32)) bPc <- mkReg(0); 
		IfId ifId <- mkIfId();
		mkStage1(ifId, bTaken, bPc);
	
		rule testbench;
			$display("counter is = %0d", counter);
			$display("instruction read is = %0d", ifId.rInstr());
			
			counter <= counter + 1;
			if (counter >= 10) $finish (0);
		endrule
	
	endmodule: mkRiscv

endpackage
