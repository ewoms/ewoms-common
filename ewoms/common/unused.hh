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
 * \brief Provides the EWOMS_UNUSED macro
 *
 * This macro can be used to mark variables as "potentially unused" which suppresses some
 * bogus compiler warnings. If the compiler does not support this, the macro is a no-op.
 */
#ifndef EWOMS_UNUSED_HH
#define EWOMS_UNUSED_HH

#ifndef HAS_ATTRIBUTE_UNUSED
#define EWOMS_UNUSED
#else
#define EWOMS_UNUSED __attribute__((unused))
#endif

#ifdef NDEBUG
#define EWOMS_DEBUG_UNUSED
#define EWOMS_OPTIM_UNUSED EWOMS_UNUSED
#else
#define EWOMS_DEBUG_UNUSED EWOMS_UNUSED
#define EWOMS_OPTIM_UNUSED
#endif

#ifdef HAVE_MPI
#define EWOMS_UNUSED_NOMPI
#else
#define EWOMS_UNUSED_NOMPI EWOMS_UNUSED
#endif

#endif
