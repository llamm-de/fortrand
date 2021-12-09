# Create library to link the feap executable against
add_library(fortrand random.f90 sampling.f90)
set_target_properties(fortrand PROPERTIES LINKER_LANGUAGE Fortran)
target_link_libraries(fortrand)