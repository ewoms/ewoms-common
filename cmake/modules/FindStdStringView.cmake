# Module that finds the libraries required to use std::optional or
# (if this is unavailable) std::experimental::optional.
#
# This module sets the following variables:
#
# STD_STRING_VIEW_FOUND                 Either std::string_view or std::experimental::string_view is available and has been found
# HAVE_STD_STRING_VIEW                  1 if std::string_view is available, else unset
# HAVE_STD_EXPERIMENTAL::STRING_VIEW    1 if std::experimental::string_view is available and std::string_view is not, else unset

include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(CMakePushCheckState)
include(CheckCXXCompilerFlag)

cmake_push_check_state(RESET)
set(CMAKE_REQUIRED_QUIET TRUE)
check_cxx_source_compiles("
#include <string_view>

int main(void){
    std::string_view> foo(\"hello\");
    return 0;
}" STD_STRING_VIEW_FOUND_PLAIN)

cmake_pop_check_state()

if (STD_STRING_VIEW_FOUND_PLAIN)
  # std::string_view has been found and no special flags are required to use it
  set(STD_STRING_VIEW_FOUND 1)
  set(HAVE_STD_STRING_VIEW 1)
else()
  # std::string_view has not been found. Check if we can use
  # std::experimental::string_view
  cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_QUIET TRUE)
  check_cxx_source_compiles("
#include <experimental/string_view>

int main(void){
    std::experimental::string_view foo(\"hello\");
    return 0;
}" STD_STRING_VIEW_FOUND_EXPERIMENTAL)

  cmake_pop_check_state()

  if (STD_STRING_VIEW_FOUND_EXPERIMENTAL)
    # std::experimental::string_view has been found
    set(STD_STRING_VIEW_FOUND 1)
    set(HAVE_STD_EXPERIMENTAL_STRING_VIEW 1)
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(StdString_view
  DEFAULT_MSG
  STD_STRING_VIEW_FOUND
  )
