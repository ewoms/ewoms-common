# Module that finds the libraries required to use std::any or
# (if this is unavailable) std::experimental::any.
#
# This module sets the following variables:
#
# STD_ANY_FOUND                 Either std::any or std::experimental::any is available and has been found
# HAVE_STD_ANY                  1 if std::any is available, else unset
# HAVE_STD_EXPERIMENTAL_ANY     1 if std::experimental::any is available and std::any is not, else unset

include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(CMakePushCheckState)
include(CheckCXXCompilerFlag)

cmake_push_check_state(RESET)
set(CMAKE_REQUIRED_QUIET TRUE)
check_cxx_source_compiles("
#include <any>

int main(void){
    std::any foo(int(4));
    return 0;
}" STD_ANY_FOUND_PLAIN)

cmake_pop_check_state()

if (STD_ANY_FOUND_PLAIN)
  # std::any has been found and no special flags are required to use it
  set(STD_ANY_FOUND 1)
  set(HAVE_STD_ANY 1)
else()
  # std::any has not been found. Check if we can use
  # std::experimental::any
  cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_QUIET TRUE)
  check_cxx_source_compiles("
#include <experimental/any>

int main(void){
    std::experimental::any foo(int(4));
    return 0;
}" STD_ANY_FOUND_EXPERIMENTAL)

  cmake_pop_check_state()

  if (STD_ANY_FOUND_EXPERIMENTAL)
    # std::experimental::any has been found
    set(STD_ANY_FOUND 1)
    set(HAVE_STD_EXPERIMENTAL_ANY 1)
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(StdAny
  DEFAULT_MSG
  STD_ANY_FOUND
  )
