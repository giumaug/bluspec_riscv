include makefile.inc

ISA=UNDEFINED
JOBS:=1
JTAG_TYPE:=JTAG_BSCAN2E

MOREDEFINES=$(addprefix -D , $(BSC_DEFINES))

#TO DEBUG bo target
#$(info building $@)
#@echo $@
#@echo $<
#@echo $(BSCCMD) $(MOREDEFINES) -p $(BSVINCDIR) $<

%.bo:
	@echo $(BSCCMD) $(MOREDEFINES) -p $(BSVINCDIR) $<
	@$(BSCCMD) $(MOREDEFINES) -p $(BSVINCDIR) $<
	
.PHONY: generate_verilog
generate_verilog:$(BSVBUILDDIR)/$(TOP_BIN)
	echo $(BSVBUILDDIR)/$(TOP_BIN)

.PHONY: arty_build
arty_build:	
	vivado -nojournal -nolog -mode tcl -notrace -source tcl/create_project.tcl -tclargs $(SYNTHTOP) $(FPGA) $(ISA) $(JTAG_TYPE) $(VERILOGDIR)\
	|| (echo "Could not create core project"; exit 1)
	vivado -nojournal -log artybuild.log -notrace -mode tcl -source tcl/run.tcl \
		-tclargs $(JOBS) || (echo "ERROR: While running synthesis")
		
.PHONY: program_fpga_jlink
program_fpga_jlink:
	vivado -nojournal -nolog -mode tcl -source tcl/program.tcl
	
.PHONY: generate_mcs
generate_mcs: ## Generate the FPGA Configuration Memory file.
	vivado -nojournal -nolog -mode tcl -source tcl/generate_mcs.tcl

.PHONY: program_mcs
program_mcs: ## Program the FPGA Configuration Memory in order to use the onboard ftdi jtag chain
	$(Vivado_loc) -nojournal -nolog -mode tcl -source tcl/program_mcs.tcl
	echo "Please Disconnect and reconnect Your Arty Board from your PC"
	echo "After programming reset the device once and run"
	
.PHONY: clean
clean:
	@echo $(BSVBUILDDIR)
	@echo $(VERILOGDIR)
	rm -rf $(BSVBUILDDIR)/*
	rm -rf $(VERILOGDIR)/*
	rm -rf fpga_project *.jou *.log
