# CMAKE generated file: DO NOT EDIT!
# Generated by "NMake Makefiles" Generator, CMake Version 3.15

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE
NULL=nul
!ENDIF
SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = "C:\Program Files\CMake\bin\cmake.exe"

# The command to remove a file.
RM = "C:\Program Files\CMake\bin\cmake.exe" -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = C:\work\matd\matd\sw

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = C:\work\matd\matd\sw\build

# Include any dependencies generated for this target.
include cli\CMakeFiles\load_array_ph_ctrl.dir\depend.make

# Include the progress variables for this target.
include cli\CMakeFiles\load_array_ph_ctrl.dir\progress.make

# Include the compile flags for this target's objects.
include cli\CMakeFiles\load_array_ph_ctrl.dir\flags.make

cli\CMakeFiles\load_array_ph_ctrl.dir\load_array_ph_ctrl.cpp.obj: cli\CMakeFiles\load_array_ph_ctrl.dir\flags.make
cli\CMakeFiles\load_array_ph_ctrl.dir\load_array_ph_ctrl.cpp.obj: ..\cli\load_array_ph_ctrl.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=C:\work\matd\matd\sw\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object cli/CMakeFiles/load_array_ph_ctrl.dir/load_array_ph_ctrl.cpp.obj"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles\load_array_ph_ctrl.dir\load_array_ph_ctrl.cpp.obj -c C:\work\matd\matd\sw\cli\load_array_ph_ctrl.cpp
	cd C:\work\matd\matd\sw\build

cli\CMakeFiles\load_array_ph_ctrl.dir\load_array_ph_ctrl.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/load_array_ph_ctrl.dir/load_array_ph_ctrl.cpp.i"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E C:\work\matd\matd\sw\cli\load_array_ph_ctrl.cpp > CMakeFiles\load_array_ph_ctrl.dir\load_array_ph_ctrl.cpp.i
	cd C:\work\matd\matd\sw\build

cli\CMakeFiles\load_array_ph_ctrl.dir\load_array_ph_ctrl.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/load_array_ph_ctrl.dir/load_array_ph_ctrl.cpp.s"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S C:\work\matd\matd\sw\cli\load_array_ph_ctrl.cpp -o CMakeFiles\load_array_ph_ctrl.dir\load_array_ph_ctrl.cpp.s
	cd C:\work\matd\matd\sw\build

cli\CMakeFiles\load_array_ph_ctrl.dir\cli_common.cpp.obj: cli\CMakeFiles\load_array_ph_ctrl.dir\flags.make
cli\CMakeFiles\load_array_ph_ctrl.dir\cli_common.cpp.obj: ..\cli\cli_common.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=C:\work\matd\matd\sw\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object cli/CMakeFiles/load_array_ph_ctrl.dir/cli_common.cpp.obj"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles\load_array_ph_ctrl.dir\cli_common.cpp.obj -c C:\work\matd\matd\sw\cli\cli_common.cpp
	cd C:\work\matd\matd\sw\build

cli\CMakeFiles\load_array_ph_ctrl.dir\cli_common.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/load_array_ph_ctrl.dir/cli_common.cpp.i"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E C:\work\matd\matd\sw\cli\cli_common.cpp > CMakeFiles\load_array_ph_ctrl.dir\cli_common.cpp.i
	cd C:\work\matd\matd\sw\build

cli\CMakeFiles\load_array_ph_ctrl.dir\cli_common.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/load_array_ph_ctrl.dir/cli_common.cpp.s"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S C:\work\matd\matd\sw\cli\cli_common.cpp -o CMakeFiles\load_array_ph_ctrl.dir\cli_common.cpp.s
	cd C:\work\matd\matd\sw\build

cli\CMakeFiles\load_array_ph_ctrl.dir\matd.cpp.obj: cli\CMakeFiles\load_array_ph_ctrl.dir\flags.make
cli\CMakeFiles\load_array_ph_ctrl.dir\matd.cpp.obj: ..\cli\matd.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=C:\work\matd\matd\sw\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object cli/CMakeFiles/load_array_ph_ctrl.dir/matd.cpp.obj"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles\load_array_ph_ctrl.dir\matd.cpp.obj -c C:\work\matd\matd\sw\cli\matd.cpp
	cd C:\work\matd\matd\sw\build

cli\CMakeFiles\load_array_ph_ctrl.dir\matd.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/load_array_ph_ctrl.dir/matd.cpp.i"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E C:\work\matd\matd\sw\cli\matd.cpp > CMakeFiles\load_array_ph_ctrl.dir\matd.cpp.i
	cd C:\work\matd\matd\sw\build

cli\CMakeFiles\load_array_ph_ctrl.dir\matd.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/load_array_ph_ctrl.dir/matd.cpp.s"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S C:\work\matd\matd\sw\cli\matd.cpp -o CMakeFiles\load_array_ph_ctrl.dir\matd.cpp.s
	cd C:\work\matd\matd\sw\build

# Object files for target load_array_ph_ctrl
load_array_ph_ctrl_OBJECTS = \
"CMakeFiles\load_array_ph_ctrl.dir\load_array_ph_ctrl.cpp.obj" \
"CMakeFiles\load_array_ph_ctrl.dir\cli_common.cpp.obj" \
"CMakeFiles\load_array_ph_ctrl.dir\matd.cpp.obj"

# External object files for target load_array_ph_ctrl
load_array_ph_ctrl_EXTERNAL_OBJECTS =

..\bin\load_array_ph_ctrl: cli\CMakeFiles\load_array_ph_ctrl.dir\load_array_ph_ctrl.cpp.obj
..\bin\load_array_ph_ctrl: cli\CMakeFiles\load_array_ph_ctrl.dir\cli_common.cpp.obj
..\bin\load_array_ph_ctrl: cli\CMakeFiles\load_array_ph_ctrl.dir\matd.cpp.obj
..\bin\load_array_ph_ctrl: cli\CMakeFiles\load_array_ph_ctrl.dir\build.make
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=C:\work\matd\matd\sw\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX executable ..\..\bin\load_array_ph_ctrl"
	cd C:\work\matd\matd\sw\build\cli
	C:\cygwin64\bin\g++.exe   -std=c++17 -lstdc++fs   $(load_array_ph_ctrl_OBJECTS) $(load_array_ph_ctrl_EXTERNAL_OBJECTS)  -o ..\..\bin\load_array_ph_ctrl -lstdc++fs 
	cd C:\work\matd\matd\sw\build

# Rule to build all files generated by this target.
cli\CMakeFiles\load_array_ph_ctrl.dir\build: ..\bin\load_array_ph_ctrl

.PHONY : cli\CMakeFiles\load_array_ph_ctrl.dir\build

cli\CMakeFiles\load_array_ph_ctrl.dir\clean:
	cd C:\work\matd\matd\sw\build\cli
	$(CMAKE_COMMAND) -P CMakeFiles\load_array_ph_ctrl.dir\cmake_clean.cmake
	cd C:\work\matd\matd\sw\build
.PHONY : cli\CMakeFiles\load_array_ph_ctrl.dir\clean

cli\CMakeFiles\load_array_ph_ctrl.dir\depend:
	$(CMAKE_COMMAND) -E cmake_depends "NMake Makefiles" C:\work\matd\matd\sw C:\work\matd\matd\sw\cli C:\work\matd\matd\sw\build C:\work\matd\matd\sw\build\cli C:\work\matd\matd\sw\build\cli\CMakeFiles\load_array_ph_ctrl.dir\DependInfo.cmake --color=$(COLOR)
.PHONY : cli\CMakeFiles\load_array_ph_ctrl.dir\depend

