[catch {exec nproc} max_threads]

set_param general.maxThreads $max_threads
open_checkpoint post_synth.dcp
opt_design -directive AddRemap

write_checkpoint -force post_opt
report_timing_summary -file reports/opt_timing.txt

place_design
write_checkpoint -force post_place
report_timing_summary -file reports/place_timings.txt

route_design
write_checkpoint -force post_route
report_timing_summary -file reports/route_timings.txt
report_utilization -file reports/utilization_final.txt
report_power -file reports/power.txt

write_bitstream spin_screen
