# Module that finds the libraries required to use std::filesystem or
# (if this is unavailable) std::experimental::filesystem.
#
# This module sets the following variables:
#
# STD_FILESYSTEM_FOUND                 Either std::filesystem or std::experimental::filesystem is available and has been found
# HAVE_STD_FILESYSTEM                  1 if std::filesystem is available, else unset
# HAVE_STD_EXPERIMENTAL::FILESYSTEM    1 if std::experimental::filesystem is available and std::filesystem is not, else unset
# STD_FILESYSTEM_LIBRARIES             The libraries which must be linked against to use either std::filesystem or std::experimental::filesystem

include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(CMakePushCheckState)
include(CheckCXXCompilerFlag)

cmake_push_check_state(RESET)
set(CMAKE_REQUIRED_QUIET TRUE)
check_cxx_source_compiles("
#include <filesystem>

int main(void){
   std::filesystem::path foo;
   return 0;
}" STD_FILESYSTEM_FOUND_PLAIN)

cmake_pop_check_state()

if (STD_FILESYSTEM_FOUND_PLAIN)
  # std::filesystem has been found and no special flags are required to use it
  set(STD_FILESYSTEM_FOUND 1)
  set(HAVE_STD_FILESYSTEM 1)
  set(STD_FILESYSTEM_LIBRARIES "")
else()
  # std::filesystem has not been found without flags. Check if we have
  # to link with -lstdc++fs
  cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_QUIET TRUE)
  list(APPEND CMAKE_REQUIRED_LIBRARIES "stdc++fs")
  check_cxx_source_compiles("
#include <filesystem>

int main(void){
    std::filesystem::path foo;
    return 0;
}" STD_FILESYSTEM_FOUND_LIB)

  cmake_pop_check_state()

  if (STD_FILESYSTEM_FOUND_LIB)
    # std::filesystem has been found and we need to link against libstdc++fs to use it
    set(STD_FILESYSTEM_FOUND 1)
    set(HAVE_STD_FILESYSTEM 1)
    set(STD_FILESYSTEM_LIBRARIES "stdc++fs")
  else()
    # std::filesystem has not been found. Check if we can use
    # std::experimental::filesystem
    cmake_push_check_state(RESET)
    set(CMAKE_REQUIRED_QUIET TRUE)
    list(APPEND CMAKE_REQUIRED_LIBRARIES "stdc++fs")
    check_cxx_source_compiles("
#include <experimental/filesystem>

int main(void){
    std::experimental::filesystem::path foo;
    return 0;
}" STD_FILESYSTEM_FOUND_EXPERIMENTAL)

    cmake_pop_check_state()

    if (STD_FILESYSTEM_FOUND_EXPERIMENTAL)
      # std::experimental::filesystem has been found
      set(STD_FILESYSTEM_FOUND 1)
      set(HAVE_STD_EXPERIMENTAL_FILESYSTEM 1)
      set(STD_FILESYSTEM_LIBRARIES "stdc++fs")
    else()
      # std::experimental::filesystem has not been found yet. Check if
      # we can use it if we link against libc++experimental from libc++
      cmake_push_check_state(RESET)
      set(CMAKE_REQUIRED_QUIET TRUE)
      list(APPEND CMAKE_REQUIRED_LIBRARIES "c++experimental")
      check_cxx_source_compiles("
#include <experimental/filesystem>

int main(void){
    std::experimental::filesystem::path foo;
    return 0;
}" STD_FILESYSTEM_FOUND_EXPERIMENTAL2)

      cmake_pop_check_state()

      if (STD_FILESYSTEM_FOUND_EXPERIMENTAL2)
        # std::experimental::filesystem has been found
        set(STD_FILESYSTEM_FOUND 1)
        set(HAVE_STD_EXPERIMENTAL_FILESYSTEM 1)
        set(STD_FILESYSTEM_LIBRARIES "c++experimental")
      endif()
    endif()
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(StdFilesystem
  DEFAULT_MSG
  STD_FILESYSTEM_FOUND
  )
