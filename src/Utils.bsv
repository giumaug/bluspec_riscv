package Utils;

	function Bit#(12) rImm12 (Bit#(32) word);
		Bit#(4) imm1 = word[11:8]; // imm[4:1]
		Bit#(6) imm2 = word[30:25];// imm[10:5]
		Bit#(1) imm3 = word[7];    // imm[11]
		Bit#(1) imm4 = word[31];   // imm[12]
		Bit#(12) imm = {imm4, imm3, imm2, imm1};
		return imm;
	endfunction
		
	function Bit#(20) rImm20 (Bit#(32) word);
		Bit#(10) imm1 = word[30:21]; // imm[10:1]
		Bit#(1) imm2 = word[20];    // imm[11]
		Bit#(8) imm3 = word[19:12]; // imm[19:12]
		Bit#(1) imm4 = word[31];    // imm[20]
		Bit#(20) imm = {imm4, imm3, imm2, imm1};
		return imm;
	endfunction
	
	function Bool signedCompare(Bit#(32) op1, Bit#(32) op2);
		UInt#(32) uOp1 = unpack(zeroExtend(op1));
		UInt#(32) uOp2 = unpack(zeroExtend(op2));
		return uOp1 > uOp2;
	endfunction
endpackage
