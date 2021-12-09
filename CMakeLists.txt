cmake_minimum_required(VERSION 3.10)
project(FortRAND_example)
enable_language(Fortran)

#---------------------------------------------------------------------------#
# Set directories 
#---------------------------------------------------------------------------#
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules)

#---------------------------------------------------------------------------#
# Set soruces
#---------------------------------------------------------------------------#
add_subdirectory(src)
set(sources example.f90)
add_executable(example ${sources})

#---------------------------------------------------------------------------#
# Link subdirectories
#---------------------------------------------------------------------------#
target_link_libraries(example fortrand)

#---------------------------------------------------------------------------#
# Link debugging libraries
#---------------------------------------------------------------------------#
if(NOT CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE STREQUAL Debug)
    message(STATUS "Using debug libraries")
    target_link_libraries(example efence)
endif()

#---------------------------------------------------------------------------#
# Add custom targets
#---------------------------------------------------------------------------#
add_custom_target(release
    COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Release ${CMAKE_SOURCE_DIR}
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target all
    COMMENT "Switch CMAKE_BUILD_TYPE to Release"
)

add_custom_target(debug
    COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Debug ${CMAKE_SOURCE_DIR}
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target all
    COMMENT "Switch CMAKE_BUILD_TYPE to Debug"
)

add_custom_target(run
    COMMAND example
    DEPENDS example
    WORKING_DIRECTORY ${CMAKE_PROJECT_DIR}
)