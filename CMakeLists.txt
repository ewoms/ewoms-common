# -*- mode: cmake; tab-width: 2; indent-tabs-mode: t; truncate-lines: t
# vim: set filetype=cmake autoindent tabstop=2 shiftwidth=2 noexpandtab softtabstop=2 nowrap:

cmake_minimum_required(VERSION 3.10)

# set up project and specify the minimum cmake version
project("ewoms-common" C CXX)

list(INSERT CMAKE_MODULE_PATH 0 "${ewoms-common_MODULE_PATH}")
list(INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/modules")

# include the additional generic eWoms cmake macros
include(EwomsMacros)

# start a ewoms project with the information from dune.module
ewoms_project()

# either std::any or std::experimental::any needs to be supported
find_package(StdAny REQUIRED)

# we want all features detected by the build system to be enabled,
# thank you!
dune_enable_all_packages()

# recursively mark all header files beneath the "ewoms" directory for
# installation.
ewoms_recusive_export_all_headers("ewoms")

# add all unit tests
ewoms_add_test(test_conditionalstorage)
ewoms_add_test(test_densead)
ewoms_add_test(test_spline)
ewoms_add_test(test_2dtables)
ewoms_add_test(test_propertysystem)
ewoms_add_test(test_tasklets)

# finalize the project, e.g. generating config.h etc.
finalize_ewoms_project()
