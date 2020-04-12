# Module that finds the libraries required to use std::variant or
# (if this is unavailable) boost::variant.
#
# This module sets the following variables:
#
# STD_VARIANT_FOUND                 Either std::variant or std::experimental::variant is available and has been found
# HAVE_STD_VARIANT                  1 if std::variant is available, else unset
# HAVE_BOOST_VARIANT                1 if boost::variant is available and std::variant is not, else unset

include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(CMakePushCheckState)
include(CheckCXXCompilerFlag)

cmake_push_check_state(RESET)
set(CMAKE_REQUIRED_QUIET TRUE)
check_cxx_source_compiles("
#include <variant>
#include <string>

int main(void){
    std::variant<int, std::string> foo;
    foo = 123;
    foo = \"hello\";
    return 0;
}" STD_VARIANT_FOUND_PLAIN)

cmake_pop_check_state()

if (STD_VARIANT_FOUND_PLAIN)
  # std::variant has been found and no special flags are required to use it
  set(STD_VARIANT_FOUND 1)
  set(HAVE_STD_VARIANT 1)
else()
  # std::variant has not been found. Check if we can use
  # std::experimental::variant
  cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_QUIET TRUE)
  check_cxx_source_compiles("
#include <boost/variant.hpp>
#include <string>

int main(void){
    boost::variant<int, std::string> foo;
    foo = 123;
    foo = \"hello\";
    return 0;
}" BOOST_VARIANT_FOUND)

  cmake_pop_check_state()

  if (BOOST_VARIANT_FOUND)
    # std::experimental::variant has been found
    set(STD_VARIANT_FOUND 1)
    set(HAVE_BOOST_VARIANT 1)
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(StdVariant
  DEFAULT_MSG
  STD_VARIANT_FOUND
  )
