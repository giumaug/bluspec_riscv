package Stage4;

	`include "Constants.defines"
	import Utils::*;
	import PipeRegs::*;
	
	module mkStage4 #(ExMem exMem, MemWb memWb) (Empty);
	
		rule memAcess;
			
		
			case (opcode)
			
				`OP-IMM: begin
				end
			
			endcase
		endrule
	endmodule: mkStage4
endpackage
