[catch {exec nproc} max_threads]

set_param general.maxThreads $max_threads
read_verilog [ glob ./hdl/*.v ]
read_xdc /home/j00r/spinning_screen/fpga/constrains/Arty-Z7-20-Master.xdc
synth_design -part xc7z020 -top top

write_checkpoint -force post_synth
report_utilization -file reports/synth_utilization.txt
report_timing -file reports/synth_timing.txt
