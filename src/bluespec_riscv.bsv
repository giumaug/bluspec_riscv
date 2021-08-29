package BluespecRiscv;

	import DataTypes :: * ;

	(*synthesize*)
	module mkRiscv(Empty);	
		Mem dataMem <- mkMem(DATA_CACHE_SIZE);
		Mem instMem <- mkMem(INST_CACHE_SIZE);
		RegFile regFile <- mkRegFile();
		
	
	endmodule: mkRiscv

endpackage
