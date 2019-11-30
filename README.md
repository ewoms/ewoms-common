[ewoms-common logo]{ewoms-common.svg image-align:right clear: both}

What is eWoms?
==============

eWoms [0] is a C++ software framework concerned with fully-implicit
numerical models for flow and transport in porous media and is made
available under the terms of the GNU General Public License (GPL).

The name "eWoms" is an acronym for the German phrase "eierlegende
Wollmilchsau" (egg-laying wool-milk pig) and reflects the fact that
its goal is to be an all-encompassing simulation framework for flow
and transport processes in porous media.

To achieve this goal, eWoms aims to be as generic as possible, easy to
extend, well performing, and well maintained: It is -- in principle --
capable of simulating all macro-scale scenarios that are relevant for
academic research and industrial applications which involve flow and
transport processes in porous media, while performance-wise,
simulators based on eWoms are often on-par or even faster than the
best commercial solutions.

eWoms uses the the pull request based development model established by
github.com. The main development branch of any module is considered to
be unstable and it thus may incorporat "hard" API changes without a
deprecation period. For this reason, if you are primarily interested
in using eWoms, you are advised to stick to a stable/release version
and to carefully read the change log before upgrading. eWoms releases
happen relatively often, i.e. approximately two are prepared each
year.

As a base, eWoms uses the DUNE [2] numerical C++ framework. It has
been spun off from the source code of the Open Porous Media initiative
[1] which in turn inherited substantial swaths of its technical
foundations from the Dumux [3] porous media simulation framework. Be
aware, though, that although Dumux, OPM and eWoms have similar goals
and share some conceptual similarities, their implementations have
diverged considerably.

Modules
-------

Currently the eWoms project features the following modules core:

- ewoms-common: Common infrastructure that is used by all eWoms
  modules and which is possibly useful in contexts that are not
  related to fluid simulations at all.
- ewoms-material: Thermodynamic framework including multi-phase fluid
  systems, representation of fluid states, solvers for systems of
  equations that emerge in the thermodynamic context and
  pseudo-empiric material relations with an eye on fluid flow
  simulation in porous media.
- ewoms-numerics: Fully-implicit temporal and spatial discretization
  methods for systems of coupled partial differential equations, flow
  models for multi-phase flow in porous media, solvers linear and
  non-linear systems of equations, and support code.

For simulation of petroleum reservoirs, the following additional
modules are build on top of the core modules:

- ewoms-eclio: A library for parsing ECLIPSE 100 [5] input files and
  writing the corresponding output files.
- ewoms-eclgrids: Various implementations of cornerpoint grids that
  are largely compatible with ECLIPSE 100.
- ewoms-eclsimulators: Ready-to-be-used simulators for ECLIPSE 100
  data sets.

INSTALLATION
============

For compiling and installing eWoms, DUNE's 'dunecontrol' utility is
recommended. For details, confer the INSTALL file.

LICENSE
=======

eWoms is licensed under the terms of the GNU General Public License
(GPL) version three or -- at your option -- any later version. The
exact wording of the GPL can either be read online [4] or it can be
found in the COPYING file.

Please note that eWoms' license -- unlike DUNE's -- does *not* feature
a template exception. In particular, this means that programs which
use eWoms header files must make the program's full source code
available under the GPL to anyone to whom it is distributed to.

Links
=====

[0] https://github.com/ewoms
[1] https://opm-project.org
[2] https://dune-project.org
[3] http://dumux.org
[4] https://gnu.org/licenses/gpl-3.0.html
