# Compiler and PATH should be set to:
# /cygdrive/c/Xilinx/Vitis/2019.2/gnu/aarch32/nt/gcc-arm-linux-gnueabi/bin/arm-linux-gnueabihf-gcc.exe
#
# export PATH=/cygdrive/c/Xilinx/Vitis/2019.2/gnu/aarch32/nt/gcc-arm-linux-gnueabi/bin:$PATH
#
# Start cmake in build/:
# cmake -DCMAKE_TOOLCHAIN_FILE=../GCC.cmake ..
# On Windows:
# cmake -G "NMake Makefiles" -DCMAKE_TOOLCHAIN_FILE=../GCC.cmake ../

cmake_minimum_required(VERSION 3.2)

project(matd C CXX)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -lstdc++fs")


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_HOME_DIRECTORY}/bin/)

if(${CMAKE_BINARY_DIR} STREQUAL ${CMAKE_HOME_DIRECTORY})
  set(CMAKE_BUILD_DIRECTORY ${CMAKE_HOME_DIRECTORY}/build)
else()
  set(CMAKE_BUILD_DIRECTORY ${CMAKE_BINARY_DIR})
endif()

add_subdirectory(cli)
