package BluespecRiscv;

	import PipeRegs :: * ;
	import Stage1 :: * ;
	import Stage2 :: * ;
	import Stage3 :: * ;
	import Stage4 :: * ;
	import Stage5 :: * ;
	import DataHazardUnit :: * ;

	(*synthesize*)
	module mkRiscv(Empty);
        Reg#(int) counter <- mkReg (0);
		Wire#(Bool) bTaken <- mkWire(); 
		Wire#(Bit#(32)) bPc <- mkWrire();
		Wire#(Bit#(32)) rd <- mkWrire();
		Wire#(Bool) stall <- mkWire(False);
		
		IfId ifId <- mkIfId();
		IdEx idEx <- mkIdEx();
		ExMem exMem <- mkExMem();
		MemWb memWb <- mkMemWb();
		
		mkStage1(ifId, bTaken, bPc, stall);
		mkStage2(ifId, idEx, bTaken, bPc, rd, mkDataHazardUnit, stall);
		mkStage3(idEx, exMem);
		mkStage4(exMem, memWb);
		mkStage5(memWb, rd);
		mkDataHazardUnit(idEx, exMem, memWb);
		
		rule testbench;
			Bit#(32) pc =  ifId.rPc();
			$display("pc is = %0d", pc);
			$display("instruction is = %0d", ifId.rInstr());
			
			if (pc >= 10) $finish (0);
		endrule
	endmodule: mkRiscv
endpackage
