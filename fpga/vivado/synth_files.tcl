
# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/../rtl/async_fifo.v"]"\
 "[file normalize "$origin_dir/../rtl/interface/axi4_lite_if.sv"]"\
 "[file normalize "$origin_dir/../rtl/interface/axi4_stream_if.sv"]"\
 "[file normalize "$origin_dir/../rtl/video_ctrl/axi_stream_mux.sv"]"\
 "[file normalize "$origin_dir/../rtl/video_ctrl/axi_stream_tp_gen.sv"]"\
 "[file normalize "$origin_dir/../rtl/interface/bt656_stream_if.sv"]"\
 "[file normalize "$origin_dir/../rtl/video_ctrl/bt656_to_axi_stream.sv"]"\
 "[file normalize "$origin_dir/../rtl/sys_ctrl/pwm_gen.sv"]"\
 "[file normalize "$origin_dir/../rtl/video_ctrl/rx_cfg_if.sv"]"\
 "[file normalize "$origin_dir/../rtl/sync_pulse.sv"]"\
 "[file normalize "$origin_dir/../rtl/sys_ctrl/sys_ctrl_axi.sv"]"\
 "[file normalize "$origin_dir/../rtl/sys_ctrl/sys_ctrl_top.sv"]"\
 "[file normalize "$origin_dir/../rtl/video_ctrl/video_ctrl_axi.sv"]"\
 "[file normalize "$origin_dir/../rtl/video_ctrl/video_ctrl_top.sv"]"\
 "[file normalize "$origin_dir/../rtl/sys_ctrl/video_meas.sv"]"\
 "[file normalize "$origin_dir/../rtl/system_top.sv"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/../rtl/interface/axi4_lite_if.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/interface/axi4_stream_if.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/video_ctrl/axi_stream_mux.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/video_ctrl/axi_stream_tp_gen.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/interface/bt656_stream_if.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/video_ctrl/bt656_to_axi_stream.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/sys_ctrl/pwm_gen.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/video_ctrl/rx_cfg_if.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/sync_pulse.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/sys_ctrl/sys_ctrl_axi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/sys_ctrl/sys_ctrl_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/video_ctrl/video_ctrl_axi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/video_ctrl/video_ctrl_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/sys_ctrl/video_meas.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../rtl/system_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
set_property -name "used_in" -value "synthesis simulation" -objects $file_obj
set_property -name "used_in_implementation" -value "0" -objects $file_obj

