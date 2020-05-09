# Find Valgrind.
#
# This module defines:
#  Valgrind_INCLUDE_DIR, where to find valgrind/memcheck.h, etc.
#  Valgrind_PROGRAM, the valgrind executable.
#  Valgrind_FOUND, If false, do not try to use valgrind.
#
# If you have valgrind installed in a non-standard place, you can define
# Valgrind_ROOT to tell cmake where it is.
if (Valgrind_FOUND)
  return()
endif()

find_path(Valgrind_INCLUDE_DIR valgrind/memcheck.h
  HINTS ${Valgrind_ROOT}/include)

# if Valgrind_ROOT is empty, we explicitly add /bin to the search
# path, but this does not hurt...
find_program(Valgrind_PROGRAM NAMES valgrind
  HINTS ${Valgrind_ROOT}/bin)

find_package_handle_standard_args(Valgrind DEFAULT_MSG
  Valgrind_INCLUDE_DIR
  Valgrind_PROGRAM)

mark_as_advanced(Valgrind_ROOT Valgrind_INCLUDE_DIR Valgrind_PROGRAM)
