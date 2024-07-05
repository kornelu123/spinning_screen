V_SRCS := hdl/*
SIM_TOP := top
SIM_SNAPSHOT := sim_snapshot

.xvlog: $(V_SRCS)
	xvlog $(V_SRCS)

.xelab: .xvlog
	xelab -debug typical -top $(SIM_TOP) -snapshot $(SIM_SNAPSHOT)

.xsim: .xelab
	xsim $(SIM_SNAPSHOT) --tclbatch tcl/sim.tcl

all: .xsim

clean:
	rm -Rf xsim.dir > /dev/null
	rm -Rf *.log > /dev/null
	rm -Rf *.jou > /dev/null
	rm -Rf *.pb  > /dev/null
	rm -Rf *.str > /dev/null
	rm -Rf *.wdb > /dev/null
	rm -Rf .Xil  > /dev/null
	rm -Rf *.dcp  > /dev/null
	rm -Rf reports/* > /dev/null
	rm -Rf *.txt > /dev/null

synth:
	vivado -mode batch -script tcl/synth.tcl

impl:
	vivado -mode batch -script tcl/impl.tcl

flash:
	vivado -mode batch -script tcl/flash.tcl
