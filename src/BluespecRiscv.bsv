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
		Wire#(Bool) bTaken <- mkWire(); 
		Wire#(Bit#(32)) bPc <- mkWire();
		Wire#(Bit#(32)) rd <- mkWire();
		Wire#(Bool) stall <- mkWire();
		Reg#(int) counter <-mkReg(0);
		
		IfId ifId <- mkIfId();
		IdEx idEx <- mkIdEx();
		ExMem exMem <- mkExMem();
		MemWb memWb <- mkMemWb();	
		DataHazardUnit dataHazardUnit <- mkDataHazardUnit(idEx, exMem, memWb);
		mkStage1(ifId, bTaken, bPc, stall);
		mkStage2(ifId, idEx, bTaken, bPc, rd, dataHazardUnit, stall);
		mkStage3(idEx, exMem);
		mkStage4(exMem, memWb);
		mkStage5(memWb, rd);
		
		rule testbench;
			counter <= counter + 1;
			Bit#(32) pc =  ifId.rPc();
			$display("pc is = %0d", pc);
			$display("instruction is = %0d", ifId.rInstr());
			
			if (counter >= 10) $finish (0);
		endrule
	endmodule: mkRiscv
endpackage
