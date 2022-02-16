VERILOGDIR:=build/hw/verilog

BSVBUILDDIR:=build/hw/intermediate

#BSVOUTDIR:=bin

BSCCMD:=bsc -u -verilog -elab -vdir build/hw/verilog -bdir build/hw/intermediate -info-dir build/hw/intermediate +RTS -K40000M -RTS -check-assert  -keep-fires -opt-undetermined-vals -remove-false-rules -remove-empty-rules -remove-starved-rules -remove-dollar -unspecified-to X -show-schedule -show-module-use  -suppress-warnings G0010:T0054:G0020:G0024:G0023:G0096:G0036:G0117:G0015

#PUT HERE DEFINES
BSC_DEFINES:=

BSVINCDIR:=.:%/Libraries:src/

#BS_VERILOG_LIB:=/opt/bsc/lib/Verilog/

TOP_MODULE:=mTop

TOP_DIR:=./

#TOP_FILE:=Soc.bsv

#XLEN:=64

TOP_BIN=BluespecRiscv.bo

#ISA=RV64IMACSU

FPGA=xc7a100tcsg324-1

SYNTHTOP=top

#BSCAN2E=enable

include depends.mk
