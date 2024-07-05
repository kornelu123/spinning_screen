open_hw_manager
connect_hw_server -url 127.0.0.1:3121
current_hw_target [get_hw_targets *]
open_hw_target

current_hw_device [get_hw_devices xc7z020_1]
refresh_hw_device -update_hw_probes false [get_hw_devices xc7z020_1]
set_property PROGRAM.FILE {spin_screen.bit} [get_hw_devices xc7z020_1] 

program_hw_devices  [get_hw_devices xc7z020_1]
refresh_hw_device   [get_hw_devices xc7z020_1]
