# .. cmake_module::
#
# This module's content is executed whenever a Dune module requires or
# suggests ewoms-common!
#

# support for quadruple precision math
find_package(Quadmath)
if(QUADMATH_FOUND)
  set(HAVE_QUAD 1)
  dune_register_package_flags(
    LIBRARIES "${QUADMATH_LIBRARIES}")
endif()

# Check if valgrind library is available or not.
find_package(Valgrind)

# export include flags for valgrind
set(HAVE_VALGRIND "${Valgrind_FOUND}")
if(Valgrind_FOUND)
  dune_register_package_flags(
    INCLUDE_DIRS "${Valgrind_INCLUDE_DIR}")
endif()
