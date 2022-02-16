#FILENAME = Top
FILENAME = BluespecRiscv
BSVINCDIR = .:%/Libraries
#BSCCMD = bsc -sim -g mkRiscv
BSCCMD = bsc -sim
BSCCMD_BIN = bsc -sim -e mkBluespecRiscv
BO = Utils.bo RegisterFile.bo PipeRegs.bo DataHazardUnit.bo Cache.bo MemoryController.bo Stage1.bo Stage2.bo Stage3.bo Stage4.bo Stage5.bo BluespecRiscv.bo
DEFINES = +RTS -K40000M -RTS

%.bo: %.bsv
	@$(BSCCMD) $(DEFINES) -p $(BSVINCDIR) $<
	
	
all: $(BO)
	@$(BSCCMD_BIN) -o $(FILENAME)

#all: RegisterFile.bo PipeRegs.bo InstCache.bo DataCache.bo Stage1.bo BluespecRiscv.bo
#	bsc -sim -e mkRiscv -o $(FILENAME)

clean:
	rm -f model* mkTop* *.bo *.so *.cxx *.ba *.h

