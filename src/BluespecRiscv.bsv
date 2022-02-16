package BluespecRiscv;

	`include "Constants.defines"
	import PipeRegs :: * ;
	import MemoryController::*;
	import Stage1 :: * ;
	import Stage2 :: * ;
	import Stage3 :: * ;
	import Stage4 :: * ;
	import Stage5 :: * ;
	import DataHazardUnit :: * ;
	//import MemoryController::*;
	
	interface BluespecRiscv;
		(*always_enabled, always_ready*)
		method Bit#(4) led();
	endinterface: BluespecRiscv

	(*synthesize*)
	module mkBluespecRiscv (BluespecRiscv);
	//module mkBluespecRiscv#(Wire#(Bit#(4)) led) (Empty);
		Wire#(Bool) bTaken <- mkWire(); 
		Wire#(Bit#(32)) bPc <- mkWire();
		Wire#(Bit#(32)) rd <- mkWire();
		Wire#(Bit#(5)) rdNum <- mkWire();
		Wire#(Bool) stall <- mkWire();
		Wire#(Bit#(4)) _led <- mkDWire(0);
		Reg#(int) counter <-mkReg(0);
		
		IfId ifId <- mkIfId();
		IdEx idEx <- mkIdEx();
		ExMem exMem <- mkExMem();
		MemWb memWb <- mkMemWb();	
		DataHazardUnit dataHazardUnit <- mkDataHazardUnit(idEx, exMem, memWb);
		MemoryController memoryController <- mkMemoryController(_led);
		mkStage1(ifId, bTaken, bPc,memoryController, stall);
		//mkStage2(ifId, idEx, bTaken, bPc, rd, rdNum, dataHazardUnit, stall);
		//Only debug
		mkStage2(ifId, idEx, exMem, memWb, bTaken, bPc, rd, rdNum, dataHazardUnit, stall);
		mkStage3(idEx, exMem);
		mkStage4(exMem, memWb, memoryController);
		mkStage5(memWb, rd, rdNum);
		
		rule testbench;
			counter <= counter + 1;
			`DISPLAY_VAR("led status is %d", _led)
			Bit#(32) pc =  ifId.rPc();
			if (counter >= 3000) $finish (0);
		endrule
		
		method Bit#(4) led();
			return _led;
		endmethod
	endmodule: mkBluespecRiscv
endpackage
