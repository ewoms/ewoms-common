Installation Instructions
=========================

This file describes how to compile and install eWoms. In this context
it is useful to keep in mind that eWoms is implemented as a DUNE
module, i.e., the generic build instructions for DUNE modules
apply [2].

Prerequisites
-------------

The eWoms software stack is firmly targeted at the Linux platform and
requires a relatively recent C++ compiler. Thus, be aware that even
though you are encouraged to try to build and run the software on
other platforms, your mileage may vary considerably.

In order to compile eWoms, you first need to install the following
DUNE modules and their respective dependencies:

  - dune-common         from [0]
  - dune-geometry       from [0]
  - dune-grid           from [0]
  - dune-localfunctions from [0]
  - dune-istl           from [0]

Note: Many Linux distributions ship DUNE packages. For reasonably
current distributions, these packages are a more convenient
alternative to building and installing DUNE manually. For Debian-based
distributions like e.g. Ubuntu, the DUNE dependencies can be installed
using

    sudo apt install libdune-grid-dev libdune-istl-dev libdune-localfunctions-dev

Before installing DUNE the appropriate package repositories must be
enabled. For Debian nothing is required, for Ubuntu the universe
repository must be enabled using

    sudo apt-add-repository universe

The base functionality of eWoms is provided by the following modules

  - ewoms-common        from [1]
  - ewoms-material      from [1]
  - ewoms-numerics      from [1]

The capabilities implemented by these modules are quite low-level and
they are primarily targeted at people who require as much flexibility
as possible for doing research on multi-phase fluid flow in porous
media. End users are normally better served by Ewoms' ECL Black-Oil
Simulator (eebos) which ingests and produces files that are compatible
with the ECLIPSE 100 [4] reservoir simulator (which is the de-facto
standard reservoir simulator in the petroleum industry). To compile
eebos, the following dependencies are required in addition to the ones
mentioned above:

  - ewoms-eclio         from [1]
  - ewoms-eclgrids      from [1]
  - ewoms-eclsimulators from [1]

Note that the modules for handling ECL compatible files require the
boost libraries to be installed and -- if MPI parallel simulations
ought to be used -- the ZOLTAN graph partitioning libraries from the
TRILINOS project. On Debian-based distributions, these dependencies
can be installed using

    sudo apt install libboost-all-dev trilinos-all-dev

Building
--------

To build any eWoms module, the generic instructions of the DUNE build
system apply [2]. For your convenience, the ewoms-common module ships
with a few ready-made option files for dunecontrol. These files can be
found on the topmost directory of the ewoms-common module and exhibit
the '.opts' extension. It is advisable to adapt these files to your
particular needs before you start the build.

After the prerequisites have been dealt with, you can compile any
eWoms module using

    cd $EWOMS_BASE_SOURCE_DIR
    cp ewoms-common/optim.opts .
    ### edit optim.opts
    $PATH_TO_DUNECONTROL/dunecontrol --opts=optim.opts --module=ewoms-$MODULE all

Depending on the dunecontrol option file used, the test simulators
might not be compiled by default in order to speed up the build
process. If you want to force a given test simulator to be compiled,
use e.g.,

    cd $EWOMS_BASE_SOURCE_DIR/ewoms-numerics/build-cmake
    make lens_immiscible_ecfv_ad

to compile the `lens_immiscible_ecfv_ad` executable provided by the
ewoms-numerics module. Unconditionally compiling all available tests
of a module can be achieved via

    cd $EWOMS_BASE_SOURCE_DIR/ewoms-$MODULE/build-cmake
    make all_tests


Installing
----------

If you merely want to use some parts eWoms -- i.e., if you are not
interested in modifying them -- you can install the modules of your
non-interest globally on your system using the following commands:

    cd $EWOMS_BASE_SOURCE_DIR/ewoms-$MODULE/build-cmake
    sudo make install

Be aware that you can specify the target directory for the
installation process by adding `-DCMAKE_INSTALL_PREFIX=$TARGET_DIR` to
the `CMAKE_FLAGS` variable specified by the `.opts` file which you
passed to dunecontrol.


Getting started
===============

Once the compilation is done, the produced executables can be found in
the directory $EWOMS_BASE_SOURCE_DIR/ewoms-$MODULE/build-cmake/bin. To
use them, it is usually sufficient to simply run the binary of
interest from the command line without any arguments. For example, to
run the `lens_immiscible_ecfv_ad` test simulator mentioned above, type

    cd $EWOMS_SOURCE_DIR/ewoms-numerics/build-cmake
    ./bin/lens_immiscible_ecfv_ad

This produces a sequence of VTK files in the current directory which
can be visualized using -- for example -- ParaView [3]:

    paraview --data=lens_immiscible_ecfv_ad.pvd

You may also specify command line parameters to alter the behavior of
the simulation. The list of recognized parameters and their
descriptions can usually be obtained via the '--help' command line
argument, e.g.,

    cd $EWOMS_SOURCE_DIR/build-cmake
    ./bin/lens_immiscible_ecfv_ad --help


Links
=====

[0] https://dune-project.org/releases/
[1] https://github.com/ewoms
[2] https://dune-project.org/doc/installation/
[3] https://paraview.org/
[4] https://software.slb.com/products/eclipse
