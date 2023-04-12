if(REL_GCC_LOADED)
  return()
endif()
set(REL_GCC_LOADED TRUE)

set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

set(CMAKE_SYSTEM_NAME Generic)

get_filename_component(_CMAKE_C_TOOLCHAIN_LOCATION "${CMAKE_C_COMPILER}" PATH)
get_filename_component(_CMAKE_CXX_TOOLCHAIN_LOCATION "${CMAKE_CXX_COMPILER}" PATH)

set(CROSS_PREFIX arm-linux-gnueabihf-)

find_program(REL_GCC_COMPILER gcc     HINTS "${_CMAKE_C_TOOLCHAIN_LOCATION}" "${_CMAKE_CXX_TOOLCHAIN_LOCATION}" )
find_program(REL_GXX_COMPILER g++     HINTS "${_CMAKE_C_TOOLCHAIN_LOCATION}" "${_CMAKE_CXX_TOOLCHAIN_LOCATION}" )
find_program(REL_GCC_LINKER   ld      HINTS "${_CMAKE_C_TOOLCHAIN_LOCATION}" "${_CMAKE_CXX_TOOLCHAIN_LOCATION}" )
find_program(REL_GCC_AR       ar      HINTS "${_CMAKE_C_TOOLCHAIN_LOCATION}" "${_CMAKE_CXX_TOOLCHAIN_LOCATION}" )
find_program(REL_GCC_OBJCOPY  objcopy HINTS "${_CMAKE_C_TOOLCHAIN_LOCATION}" "${_CMAKE_CXX_TOOLCHAIN_LOCATION}" )

set(CMAKE_LINKER "${REL_GCC_LINKER}" CACHE FILEPATH "The GCC linker" FORCE)
mark_as_advanced(REL_GCC_LINKER)
set(CMAKE_AR "${REL_GCC_AR}" CACHE FILEPATH "The GCC archiver" FORCE)
mark_as_advanced(REL_GCC_AR)
set(CMAKE_C_COMPILER "${REL_GCC_COMPILER}" CACHE FILEPATH "The GCC compiler" FORCE)
set(CMAKE_CXX_COMPILER "${REL_GXX_COMPILER}" CACHE FILEPATH "The G++ compiler" FORCE)

mark_as_advanced(REL_GCC_COMPILER)

message("Found CMAKE_AR = ${CMAKE_AR}")
message("Found CMAKE_LINKER = ${CMAKE_LINKER}")
message("Found CMAKE_C_COMPILER = ${CMAKE_C_COMPILER}")
message("Found CMAKE_CXX_COMPILER = ${CMAKE_CXX_COMPILER}")