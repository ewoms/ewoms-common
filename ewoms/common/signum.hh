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
*/
/*!
 * \file
 * \copydoc sgn()
 */
#ifndef EWOMS_SIGNUM_HH
#define EWOMS_SIGNUM_HH

namespace Ewoms {
/*!
 * \brief Template function which returns the sign of a floating point value
 *
 * This is a type safe and fast implementation of a sign() function for arbitrary
 * floating point values. It a slightly modified variant of
 *
 * https://stackoverflow.com/questions/1903954/is-there-a-standard-sign-function-signum-sgn-in-c-c
 */
template <class Scalar>
int signum(Scalar val)
{ return (0 < val) - (val < 0); }

} // namespace Ewoms

#endif
