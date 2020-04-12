# .. cmake_module::
#
# This module contains a few convenience macros which are relevant for
# all eWoms modules
#

# Simplify variable reference and escape sequence evaluation.
if (POLICY CMP0053)
  cmake_policy(SET CMP0053 NEW)
endif()

# Only interpret ``if()`` arguments as variables or keywords when unquoted.
if (POLICY CMP0054)
  cmake_policy(SET CMP0054 NEW)
endif()

# Include file check macros honor ``CMAKE_REQUIRED_LIBRARIES``.
if (POLICY CMP0075)
  cmake_policy(SET CMP0075 NEW)
endif()

# allow generator expressions as arguments for install() (in reality,
# we don't care)
if (POLICY CMP0087)
  cmake_policy(SET CMP0087 NEW)
endif()

# Specify the BUILD_TESTING option and set it to off by default. The
# reason is that builing the unit tests often takes considerable more
# time than the actual module and that these tests are not interesting
# for people who just want to use the module but not develop on
# it. Before merging changes into master, the continuous integration
# system makes sure that the unit tests pass, though.
option(BUILD_TESTING "Build the unit tests" OFF)

# Specifies wheter the applications should be build by default or not
option(BUILD_APPLICATIONS "Build the applications shipped with this module" ON)

option(ADD_DISABLED_CTESTS "Add the tests which are disabled due to failed preconditions to the ctest output (this makes ctest return an error if such a test is present)" ON)
mark_as_advanced(ADD_DISABLED_CTESTS)

macro(ewoms_project)
  # find the dune build system (i.e., dune-common) and set cmake's
  # module path
  find_package(dune-common REQUIRED)
  list(INSERT CMAKE_MODULE_PATH 0 "${dune-common_MODULE_PATH}")

  # include the dune macros
  include(DuneMacros)

  dune_project()

  # make sure we have at least C++14
  dune_require_cxx_standard(VERSION 14)

  # add "all_tests", "all_applications" "test-suite" and "build_tests"
  # targets if they does not already exist. "test-suite" is used by the
  # traditional eWoms build system to build all tests, the "build_tests"
  # is the target which the DUNE build system uses for the same purpose
  if(NOT TARGET all_tests)
    add_custom_target(all_tests)
  endif()

  if(NOT TARGET all_applications)
    add_custom_target(all_applications)
  endif()

  if(NOT TARGET test-suite)
    add_custom_target(test-suite)
  endif()

  if(NOT TARGET build_tests)
    add_custom_target(build_tests)
  endif()

  # add "apps" and "application" targets if they does not already
  # exist. these targets are analogous to "test-suite" and "build_tests"
  # but for applications instead of for tests.
  if(NOT TARGET apps)
    add_custom_target(apps)
  endif()

  if(NOT TARGET applications)
    add_custom_target(applications)
  endif()

endmacro()

macro(finalize_ewoms_project)
  # make sure the build system files are installed for this project
  ewoms_export_cmake_modules()

  finalize_dune_project(GENERATE_CONFIG_H_CMAKE)
endmacro()

include(CMakeParseArguments)

# required to make add_test work without the version redefined by DUNE
# spitting out a warning
set(DUNE_REENABLE_ADD_TEST "YES")

# Add a single unit test (can be orchestrated by the 'ctest' command)
#
# Synopsis:
#       ewoms_add_test(TestName)
#
# Parameters:
#       TestName           Name of test
#       ONLY_COMPILE       Only build test but do not run it (optional)
#       DEFAULT_ENABLE_IF  Only enable by default if a given condition is true (optional)
#       EXE_NAME           Name of test executable (optional, default: ./bin/${TestName})
#       CONDITION          Condition to enable test (optional, cmake code)
#       DEPENDS            Targets which the test depends on (optional)
#       DRIVER             The script which supervises the test (optional, default: ${EWOMS_TEST_DRIVER})
#       DRIVER_ARGS        The script which supervises the test (optional, default: ${EWOMS_TEST_DRIVER_ARGS})
#       TEST_ARGS          Arguments to pass to test's binary (optional, default: empty)
#       SOURCES            Source files for the test (optional, default: ${EXE_NAME}.cc)
#       PROCESSORS         Number of processors to run test on (optional, default: 1)
#       TEST_DEPENDS       Other tests which must be run before running this test (optional, default: None)
#       INCLUDE_DIRS       Additional directories to look for include files (optional)
#       LIBRARIES          Libraries to link test against (optional)
#       WORKING_DIRECTORY  Working directory for test (optional, default: ${PROJECT_BINARY_DIR})
#
# Example:
#
# ewoms_add_test(funky_test
#              DEFAULT_ENABLE_IF TRUE
#              CONDITION FUNKY_GRID_FOUND
#              SOURCES tests/myfunkytest.cc
#              LIBRARIES -lgmp -lm)
function(ewoms_add_test TestName)
  cmake_parse_arguments(CURTEST
                        "NO_COMPILE;ONLY_COMPILE" # flags
                        "EXE_NAME;PROCESSORS;WORKING_DIRECTORY" # one value args
                        "CONDITION;DEFAULT_ENABLE_IF;TEST_DEPENDS;DRIVER;DRIVER_ARGS;DEPENDS;TEST_ARGS;SOURCES;LIBRARIES;INCLUDE_DIRS" # multi-value args
                        ${ARGN})

  # set the default values for optional parameters
  if (NOT CURTEST_EXE_NAME)
    set(CURTEST_EXE_NAME ${TestName})
  endif()

  # try to auto-detect the name of the source file if SOURCES are not
  # explicitly specified.
  if (NOT CURTEST_SOURCES)
    set(CURTEST_SOURCES "")
    set(_SDir "${PROJECT_SOURCE_DIR}")
    foreach(CURTEST_CANDIDATE "${CURTEST_EXE_NAME}.cpp"
                              "${CURTEST_EXE_NAME}.cc"
                              "tests/${CURTEST_EXE_NAME}.cpp"
                              "tests/${CURTEST_EXE_NAME}.cc")
      if (EXISTS "${_SDir}/${CURTEST_CANDIDATE}")
        set(CURTEST_SOURCES "${_SDir}/${CURTEST_CANDIDATE}")
      endif()
    endforeach()
  endif()

  # the default working directory is the content of
  # EWOMS_TEST_DEFAULT_WORKING_DIRECTORY or the source directory if this
  # is unspecified
  if (NOT CURTEST_WORKING_DIRECTORY)
    if (EWOMS_TEST_DEFAULT_WORKING_DIRECTORY)
      set(CURTEST_WORKING_DIRECTORY ${EWOMS_TEST_DEFAULT_WORKING_DIRECTORY})
    else()
      set(CURTEST_WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
    endif()
  endif()

  # don't build the tests by _default_ if BUILD_TESTING is false,
  # i.e., when typing 'make' the tests are not build in that
  # case. They can still be build using 'make test-suite' and they can
  # be build and run using 'make check'
  set(CURTEST_EXCLUDE_FROM_ALL "")
  if ("AND OR ${CURTEST_DEFAULT_ENABLE_IF}" STREQUAL "AND OR ")
    if (NOT BUILD_TESTING)
      set(CURTEST_EXCLUDE_FROM_ALL "EXCLUDE_FROM_ALL")
    endif()
  elseif (NOT (${CURTEST_DEFAULT_ENABLE_IF}))
    set(CURTEST_EXCLUDE_FROM_ALL "EXCLUDE_FROM_ALL")
  endif()

  # figure out the test driver script and its arguments. (the variable
  # for the driver script may be empty. In this case the binary is run
  # "bare metal".)
  if (NOT CURTEST_DRIVER)
    set(CURTEST_DRIVER "${EWOMS_TEST_DRIVER}")
  endif()
  if (NOT CURTEST_DRIVER_ARGS)
    set(CURTEST_DRIVER_ARGS "${EWOMS_TEST_DRIVER_ARGS}")
  endif()

  # the libraries to link against. the libraries produced by the
  # current module are always linked against
  get_property(DUNE_MODULE_LIBRARIES GLOBAL PROPERTY DUNE_MODULE_LIBRARIES)
  if (NOT CURTEST_LIBRARIES)
    SET(CURTEST_LIBRARIES "${DUNE_MODULE_LIBRARIES}")
  else()
    SET(CURTEST_LIBRARIES "${CURTEST_LIBRARIES};${DUNE_MODULE_LIBRARIES}")
  endif()

  # the additional include directories
  get_property(DUNE_MODULE_INCLUDE_DIRS GLOBAL PROPERTY DUNE_INCLUDE_DIRS)
  if (NOT CURTEST_INCLUDE_DIRS)
    SET(CURTEST_INCLUDE_DIRS "${DUNE_INCLUDE_DIRS}")
  else()
    SET(CURTEST_INCLUDE_DIRS "${CURTEST_INCLUDE_DIRS};${DUNE_MODULE_INCLUDE_DIRS}")
  endif()

  # determine if the test should be completely ignored, i.e., the
  # CONDITION argument evaluates to false. the "AND OR " is a hack
  # which is required to prevent CMake from evaluating the condition
  # in the string. (which might evaluate to an empty string even
  # though "${CURTEST_CONDITION}" is not empty.)
  if ("AND OR ${CURTEST_CONDITION}" STREQUAL "AND OR ")
    set(SKIP_CUR_TEST "0")
  elseif(${CURTEST_CONDITION})
    set(SKIP_CUR_TEST "0")
  else()
    set(SKIP_CUR_TEST "1")
  endif()

  if (NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
  endif()

  if (NOT SKIP_CUR_TEST)
    if (CURTEST_ONLY_COMPILE)
      # only compile the binary but do not run it as a test
      add_executable("${CURTEST_EXE_NAME}" ${CURTEST_EXCLUDE_FROM_ALL} ${CURTEST_SOURCES})
      target_link_libraries (${CURTEST_EXE_NAME} ${CURTEST_LIBRARIES})
      target_include_directories(${CURTEST_EXE_NAME} PRIVATE ${CURTEST_INCLUDE_DIRS})

      if(CURTEST_DEPENDS)
        add_dependencies("${CURTEST_EXE_NAME}" ${CURTEST_DEPENDS})
      endif()
    else()
      if (NOT CURTEST_NO_COMPILE)
        # in addition to being run, the test must be compiled. (the
        # run-only case occurs if the binary is already compiled by an
        # earlier test.)
        add_executable("${CURTEST_EXE_NAME}" ${CURTEST_EXCLUDE_FROM_ALL} ${CURTEST_SOURCES})
        target_link_libraries (${CURTEST_EXE_NAME} ${CURTEST_LIBRARIES})
        target_include_directories(${CURTEST_EXE_NAME} PRIVATE ${CURTEST_INCLUDE_DIRS})

        if(CURTEST_DEPENDS)
          add_dependencies("${CURTEST_EXE_NAME}" ${CURTEST_DEPENDS})
        endif()
      endif()

      # figure out how the test should be run. if a test driver script
      # has been specified to supervise the test binary, use it else
      # run the test binary "naked".
      if (CURTEST_DRIVER)
        set(CURTEST_COMMAND ${CURTEST_DRIVER} ${CURTEST_DRIVER_ARGS} ${CURTEST_EXE_NAME} ${CURTEST_TEST_ARGS})
      else()
        set(CURTEST_COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${CURTEST_EXE_NAME})
        if (CURTEST_TEST_ARGS)
          list(APPEND CURTEST_COMMAND ${CURTEST_TEST_ARGS})
        endif()
      endif()

      add_test(NAME ${TestName}
               WORKING_DIRECTORY "${CURTEST_WORKING_DIRECTORY}"
               COMMAND ${CURTEST_COMMAND})

      # return code 77 should be interpreted as skipped test
      set_tests_properties(${TestName} PROPERTIES SKIP_RETURN_CODE 77)

      # specify the dependencies between the tests
      if (CURTEST_TEST_DEPENDS)
        set_tests_properties(${TestName} PROPERTIES DEPENDS "${CURTEST_TEST_DEPENDS}")
      endif()

      # tell ctest how many cores it should reserve to run the test
      if (CURTEST_PROCESSORS)
        set_tests_properties(${TestName} PROPERTIES PROCESSORS "${CURTEST_PROCESSORS}")
      endif()
    endif()

    if (NOT CURTEST_NO_COMPILE)
      add_dependencies(test-suite "${CURTEST_EXE_NAME}")
      add_dependencies(all_tests "${CURTEST_EXE_NAME}")
      add_dependencies(build_tests "${CURTEST_EXE_NAME}")
    endif()

  else() # test is skipped

    if (NOT "${CURTEST_DRIVER}" STREQUAL "")
      # the following causes the test to appear as 'skipped' in the
      # CDash dashboard. it this is removed, the test is just silently
      # ignored. these tests only appear if a dedicated test driver is
      # specified. this driver is assumed to accept the --skip option.
      if (NOT CURTEST_ONLY_COMPILE AND ADD_DISABLED_CTESTS)
        add_test(${TestName}  ${CURTEST_DRIVER} --skip)
        
        # return code 77 should be interpreted as skipped test
        set_tests_properties(${TestName} PROPERTIES SKIP_RETURN_CODE 77)
      endif()
    endif()

  endif()
endfunction()

# Add an application. This function takes most of the arguments of
# ewoms_add_test() but applications are collected by the
# "all_applications" instead of "all_tests".
#
# Synopsis:
#       ewoms_add_application(AppName [OPTIONS])
#
# Parameters:
#       AppName            Name of application
#       DEFAULT_ENABLE_IF  Only enable by default if a given condition is true (optional)
#       EXE_NAME           Name of application executable (optional, default: ./bin/${ApplicationName})
#       CONDITION          Condition to enable application (optional, cmake code)
#       DEPENDS            Targets which the application depends on (optional)
#       SOURCES            source files for the application (optional, default: ${EXE_NAME}.cc)
#       INCLUDE_DIRS       Additional directories to look for include files (optional)
#       LIBRARIES          Libraries to link application against (optional)
#
# Example:
#
# ewoms_add_application(funky_application
#              DEFAULT_ENABLE_IF FUNKY_LIBRARY_FOUND
#              CONDITION FUNKY_GRID_FOUND
#              SOURCES applications/myfunkyapplication.cc
#              LIBRARIES -lgmp -lm)
function(ewoms_add_application AppName)
  cmake_parse_arguments(CURAPP
                        "" # flags
                        "EXE_NAME" # one value args
                        "CONDITION;DEFAULT_ENABLE_IF;DEPENDS;SOURCES;LIBRARIES;INCLUDE_DIRS" # multi-value args
                        ${ARGN})

  # set the default values for optional parameters
  if (NOT CURAPP_EXE_NAME)
    set(CURAPP_EXE_NAME ${AppName})
  endif()

  # do not add a target at all the preconditions are not met
  if (NOT ("AND OR ${CURAPP_CONDITION}" STREQUAL "AND OR "))
    if ((NOT CURAPP_CONDITION))
      return()
    endif()
  endif()

  if (NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
  endif ()

  # try to auto-detect the name of the source file if SOURCES are not
  # explicitly specified.
  if (NOT CURAPP_SOURCES)
    set(CURAPP_SOURCES "")
    set(_SDir "${PROJECT_SOURCE_DIR}")
    foreach(CURAPP_CANDIDATE "${CURAPP_EXE_NAME}.cpp"
                              "${CURAPP_EXE_NAME}.cc"
                              "applications/${CURAPP_EXE_NAME}.cpp"
                              "applications/${CURAPP_EXE_NAME}.cc")
      if (EXISTS "${_SDir}/${CURAPP_CANDIDATE}")
        set(CURAPP_SOURCES "${_SDir}/${CURAPP_CANDIDATE}")
      endif()
    endforeach()
  endif()
  
  # don't build the app by _default_ if either BUILD_APPLICATIONS or
  # the condition to build it by default is false, i.e., when simply
  # typing 'make' such applications are not build, but they can still
  # be build using 'make all_applications' or 'make $APP_NAME'
  set(CURAPP_EXCLUDE_FROM_ALL "")
  if (NOT BUILD_APPLICATIONS)
    set(CURAPP_EXCLUDE_FROM_ALL "EXCLUDE_FROM_ALL")
  elseif (NOT ("AND OR ${CURAPP_DEFAULT_ENABLE_IF}" STREQUAL "AND OR "))
    if (NOT ${CURAPP_DEFAULT_ENABLE_IF})
      set(CURAPP_EXCLUDE_FROM_ALL "EXCLUDE_FROM_ALL")
    endif()
  endif()

  # the libraries to link against. the libraries produced by the
  # current module are always linked against
  get_property(DUNE_MODULE_LIBRARIES GLOBAL PROPERTY DUNE_MODULE_LIBRARIES)
  if (NOT CURAPP_LIBRARIES)
    set(CURAPP_LIBRARIES "${DUNE_MODULE_LIBRARIES}")
  else()
    set(CURAPP_LIBRARIES "${CURAPP_LIBRARIES};${DUNE_MODULE_LIBRARIES}")
  endif()

  # the additional include directories
  get_property(DUNE_MODULE_INCLUDE_DIRS GLOBAL PROPERTY DUNE_INCLUDE_DIRS)
  if (NOT CURAPP_INCLUDE_DIRS)
    set(CURAPP_INCLUDE_DIRS "${DUNE_INCLUDE_DIRS}")
  else()
    set(CURAPP_INCLUDE_DIRS "${CURAPP_INCLUDE_DIRS};${DUNE_MODULE_INCLUDE_DIRS}")
  endif()

  # instruct cmake to add a target for the application
  add_executable("${CURAPP_EXE_NAME}" ${CURAPP_EXCLUDE_FROM_ALL} ${CURAPP_SOURCES})
  target_link_libraries (${CURAPP_EXE_NAME} ${CURAPP_LIBRARIES})
  target_include_directories(${CURAPP_EXE_NAME} PRIVATE ${CURAPP_INCLUDE_DIRS})

  if(CURAPP_DEPENDS)
    add_dependencies("${CURAPP_EXE_NAME}" ${CURAPP_DEPENDS})
  endif()

  # install binary if it is build by default
  if("AND OR ${CURAPP_EXCLUDE_FROM_ALL}" STREQUAL "AND OR ")
    install(TARGETS "${CURAPP_EXE_NAME}" DESTINATION bin)
  endif()

  # add the application to the custom "all_applications" target
  add_dependencies(all_applications "${CURAPP_EXE_NAME}")
endfunction()

# macro to set the default test driver script and the its default
# arguments
macro(ewoms_set_test_driver DriverBinary DriverDefaultArgs)
  set(EWOMS_TEST_DRIVER "${DriverBinary}")
  set(EWOMS_TEST_DRIVER_ARGS "${DriverDefaultArgs}")
endmacro()

# macro to set the default test driver script and the its default
# arguments
macro(ewoms_set_test_default_working_directory Dir)
  set(EWOMS_TEST_DEFAULT_WORKING_DIRECTORY "${Dir}")
endmacro()

function(ewoms_recursive_add_internal_library LIBNAME)
  set(TMP2 "")
  foreach(DIR ${ARGN})
    file(GLOB_RECURSE TMP RELATIVE "${CMAKE_SOURCE_DIR}" "${DIR}/*.cpp" "${DIR}/*.cc" "${DIR}/*.c")
    list(APPEND TMP2 ${TMP})
  endforeach()

  add_library("${LIBNAME}" STATIC "${TMP2}")
endfunction()

function(ewoms_recursive_add_library LIBNAME)
  set(TMP2 "")
  foreach(ENTITY ${ARGN})
    if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/${ENTITY}")
      file(GLOB_RECURSE TMP RELATIVE "${CMAKE_SOURCE_DIR}" "${ENTITY}/*.cpp" "${ENTITY}/*.cc" "${ENTITY}/*.c")
      list(APPEND TMP2 ${TMP})
    elseif(EXISTS "${CMAKE_SOURCE_DIR}/${ENTITY}")
      list(APPEND TMP2 "${CMAKE_SOURCE_DIR}/${ENTITY}")
    else()
      message(FATAL_ERROR "Cannot create library '${LIBNAME}': Source entity '${ENTITY}' does not exist")
    endif()
  endforeach()

  dune_add_library("${LIBNAME}"
    SOURCES "${TMP2}"
    )
endfunction()

set(LISTSFILE_READ FALSE)
macro(ewoms_read_listsfile)
  if (NOT LISTSFILE_READ)
    set(LISTSFILE_READ TRUE)

    # include list with source files and executables
    include("${CMAKE_SOURCE_DIR}/CMakeLists_files.cmake")
  endif()
endmacro()

# add all source files from each modules CMakeLists_files.cmake
# to the library and executables. Argument is the library name
function(ewoms_add_headers_library_and_executables LIBNAME)
  # the cmake modules get a special treatment
  ewoms_export_cmake_modules()

  # we want all features detected by the build system to be enabled,
  # thank you!
  dune_enable_all_packages()

  ewoms_read_listsfile()

  dune_add_library("${LIBNAME}"
    SOURCES "${MAIN_SOURCE_FILES}"
    )

  # add header for installation
  foreach( HEADER ${PUBLIC_HEADER_FILES})
    # extract header directory for installation
    get_filename_component(DIRNAME "${HEADER}" DIRECTORY)
    install(FILES "${HEADER}" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${DIRNAME}")
  endforeach()

  # add executables from list of executables
  foreach( FILE_NAME ${EXAMPLE_SOURCE_FILES} )
    # extract executable name
    get_filename_component(EXEC_NAME ${FILE_NAME} NAME_WE)
    ewoms_add_application( ${EXEC_NAME} SOURCES ${FILE_NAME} )
  endforeach()

  # add tests from list of test files
  foreach( FILE_NAME ${TEST_SOURCE_FILES} )
    # extract executable name
    get_filename_component(EXEC_NAME ${FILE_NAME} NAME_WE)
    ewoms_add_test( ${EXEC_NAME} SOURCES "${FILE_NAME}" LIBRARIES "${Boost_LIBRARIES}" INCLUDE_DIRS "${Boost_INCLUDE_DIRS}")
  endforeach()
endfunction()

function(ewoms_recusive_copy_testdata)
  foreach(PAT ${ARGN})
    file(GLOB_RECURSE TMP RELATIVE "${CMAKE_SOURCE_DIR}" "${PAT}")

    foreach(SOURCE_FILE ${TMP})
      get_filename_component(DIRNAME "${SOURCE_FILE}" DIRECTORY)
      get_filename_component(FILENAME "${SOURCE_FILE}" NAME)

      if (NOT EXISTS "${CMAKE_BINARY_DIR}/${DIRNAME}/${FILENAME}")
        file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/${DIRNAME}")
        execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink
          "${CMAKE_SOURCE_DIR}/${SOURCE_FILE}"
          "${CMAKE_BINARY_DIR}/${DIRNAME}/${FILENAME}")
      endif()
    endforeach()
  endforeach()
endfunction()

function(ewoms_recusive_copy_testdata_to_builddir)
  foreach(PAT ${ARGN})
    file(GLOB_RECURSE TMP RELATIVE "${CMAKE_SOURCE_DIR}" "${PAT}")

    foreach(SOURCE_FILE ${TMP})
      get_filename_component(DIRNAME "${SOURCE_FILE}" DIRECTORY)
      get_filename_component(FILENAME "${SOURCE_FILE}" NAME)

      if (NOT EXISTS "${CMAKE_BINARY_DIR}/${FILENAME}")
        file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/${DIRNAME}")
        execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink
          "${CMAKE_SOURCE_DIR}/${SOURCE_FILE}"
          "${CMAKE_BINARY_DIR}/${FILENAME}")
      endif()
    endforeach()
  endforeach()
endfunction()

function(ewoms_recusive_export_all_headers)
  foreach(DIR ${ARGN})
    file(GLOB_RECURSE TMP RELATIVE "${CMAKE_SOURCE_DIR}" "${DIR}/*.hpp" "${DIR}/*.hh" "${DIR}/*.h")

    foreach(HEADER ${TMP})
      get_filename_component(DIRNAME "${HEADER}" DIRECTORY)
      install(FILES "${HEADER}" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${DIRNAME}")
    endforeach()
  endforeach()
endfunction()

function(ewoms_export_cmake_modules)
  file(GLOB_RECURSE TMP RELATIVE "${CMAKE_SOURCE_DIR}" "cmake/*.cmake")

  foreach(CM_MOD ${TMP})
    get_filename_component(DIRNAME "${CM_MOD}" DIRECTORY)
    install(FILES "${CM_MOD}" DESTINATION "${DUNE_INSTALL_MODULEDIR}")
  endforeach()
endfunction()
