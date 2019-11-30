// -*- mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
// vi: set et ts=4 sw=4 sts=4:
/*
  This file is part of the eWoms project.

  eWoms is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  eWoms is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with eWoms.  If not, see <http://www.gnu.org/licenses/>.

  Consult the COPYING file in the top-level source directory of this
  module for the precise wording of the license and the list of
  copyright holders.
*/
/*!
 * \file
 * \brief This file provides a wrapper around the "final" C++-2011 statement.
 *
 * The "final" C++-2011 statement specifies that a virtual method cannot be overloaded by
 * derived classes anymore. This allows the compiler to de-virtualize calls to such
 * methods and is this an optimization. (it also prevents the programmer from creating a
 * new method instead of overloading an existing one, i.e., it is nice to have from a
 * code quality perspective.) Since not all compilers which must be supported
 * feature the "final" qualifier, this method provides a wrapper macro around it.
 */
#ifndef EWOMS_FINAL_HH
#define EWOMS_FINAL_HH

#if HAVE_FINAL
#define EWOMS_FINAL final
#else
#define EWOMS_FINAL /* nothing; compiler does not recognize "final" */
#endif

#endif
