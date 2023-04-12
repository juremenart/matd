set(cli_source_files
    cli_common.cpp
    cli_common.h
    matd.cpp
    matd.h
    phase_ctrl.h
    pwm_gen.h)


add_executable(access_phase_ctrl access_phase_ctrl.cpp ${cli_source_files} access_phase_ctrl.cpp)
add_executable(access_pwm_gen access_pwm_gen.cpp ${cli_source_files})
add_executable(disable_array disable_array.cpp ${cli_source_files})
add_executable(set_pwm_out set_pwm_out.cpp ${cli_source_files})

add_executable(load_array load_array.cpp ${cli_source_files})
add_executable(move_ph_ctrl move_ph_ctrl.cpp ${cli_source_files})

target_link_libraries(load_array stdc++fs)
target_link_libraries(move_ph_ctrl stdc++fs)
target_link_libraries(access_phase_ctrl stdc++fs)
target_link_libraries(access_pwm_gen stdc++fs)
target_link_libraries(disable_array stdc++fs)
target_link_libraries(set_pwm_out stdc++fs)
