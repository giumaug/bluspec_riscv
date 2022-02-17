package Utils;

	function Bit#(12) rImm12B (Bit#(32) word);
		Bit#(4) imm1 = word[11:8];
		Bit#(6) imm2 = word[30:25];
		Bit#(1) imm3 = word[7];
		Bit#(1) imm4 = word[31];
		Bit#(12) imm = {imm4, imm3, imm2, imm1};
		return imm;
	endfunction
	
	function Bit#(12) rImm12S (Bit#(32) word);
		Bit#(5) imm1 = word[11:7];
		Bit#(7) imm2 = word[31:25];
		Bit#(12) imm = {imm2, imm1};
		return imm;
	endfunction
	
	function Bit#(12) rImm12I (Bit#(32) word);
		Bit#(12) imm = word[31:20];
		return imm;
	endfunction
	
	function Bit#(20) rImm20I (Bit#(32) word);
		Bit#(20) imm = word[31:12];
		return imm;
	endfunction
	
	function Bit#(20) rImm20 (Bit#(32) word);
		Bit#(10) imm1 = word[30:21];
		Bit#(1) imm2 = word[20];
		Bit#(8) imm3 = word[19:12];
		Bit#(1) imm4 = word[31];
		Bit#(20) imm = {imm4, imm3, imm2, imm1};
		return imm;
	endfunction
	
	function Bool signedCompare(Bit#(32) op1, Bit#(32) op2);
		UInt#(32) uOp1 = unpack(zeroExtend(op1));
		UInt#(32) uOp2 = unpack(zeroExtend(op2));
		return uOp1 > uOp2;
	endfunction
endpackage
