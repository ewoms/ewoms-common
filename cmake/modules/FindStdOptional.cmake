# Module that finds the libraries required to use std::optional or
# (if this is unavailable) std::experimental::optional.
#
# This module sets the following variables:
#
# STD_OPTIONAL_FOUND                 Either std::optional or std::experimental::optional is available and has been found
# HAVE_STD_OPTIONAL                  1 if std::optional is available, else unset
# HAVE_STD_EXPERIMENTAL::OPTIONAL    1 if std::experimental::optional is available and std::optional is not, else unset

include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(CMakePushCheckState)
include(CheckCXXCompilerFlag)

cmake_push_check_state(RESET)
set(CMAKE_REQUIRED_QUIET TRUE)
check_cxx_source_compiles("
#include <optional>

int main(void){
    std::optional<int> foo = std::nullopt;
    return 0;
}" STD_OPTIONAL_FOUND_PLAIN)

cmake_pop_check_state()

if (STD_OPTIONAL_FOUND_PLAIN)
  # std::optional has been found and no special flags are required to use it
  set(STD_OPTIONAL_FOUND 1)
  set(HAVE_STD_OPTIONAL 1)
else()
  # std::optional has not been found. Check if we can use
  # std::experimental::optional
  cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_QUIET TRUE)
  check_cxx_source_compiles("
#include <experimental/optional>

int main(void){
    std::experimental::optional<int> foo = std::experimental::nullopt;
    return 0;
}" STD_OPTIONAL_FOUND_EXPERIMENTAL)

  cmake_pop_check_state()

  if (STD_OPTIONAL_FOUND_EXPERIMENTAL)
    # std::experimental::optional has been found
    set(STD_OPTIONAL_FOUND 1)
    set(HAVE_STD_EXPERIMENTAL_OPTIONAL 1)
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(StdOptional
  DEFAULT_MSG
  STD_OPTIONAL_FOUND
  )
