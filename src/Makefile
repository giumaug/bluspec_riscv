FILENAME = BluespecRiscv
BSVINCDIR = .:%/Libraries
#BSCCMD = bsc -sim -g mkRiscv
BSCCMD = bsc -sim
BSCCMD_BIN = bsc -sim -e mkRiscv
BO = RegisterFile.bo PipeRegs.bo Cache.bo Stage1.bo BluespecRiscv.bo
DEFINES = +RTS -K40000M -RTS

%.bo: %.bsv
	@$(BSCCMD) $(DEFINES) -p $(BSVINCDIR) $<
	
	
all: $(BO)
	@$(BSCCMD_BIN) -o $(FILENAME)

#all: RegisterFile.bo PipeRegs.bo InstCache.bo DataCache.bo Stage1.bo BluespecRiscv.bo
#	bsc -sim -e mkRiscv -o $(FILENAME)

#CHECK BEFORE EXECUTE!!!
clean:
	rm -f model* mkRiscv* *.bo *.so *.cxx *.ba *.h

