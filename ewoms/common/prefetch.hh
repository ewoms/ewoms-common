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
 * \copydoc prefetch
 */
#ifndef EWOMS_PREFETCH_HH
#define EWOMS_PREFETCH_HH

namespace Ewoms {
/*!
 * \brief Template function which emits prefetch instructions for a range of memory
 *
 * This function does not change the semantics of the code, but used correctly it will
 * improve performace because the number of cache misses will be reduced.
 */
template <int temporalLocality = 3, int writeOnly = 0, class T = void>
void prefetch(const T& val, unsigned n = 1)
{
#if __clang__ || __GNUC__
    // this value is architecture specific, but a cache line size of 64 bytes seems to be
    // used by all contemporary architectures.
    static const int cacheLineSize = 64;

    const char *beginPtr = reinterpret_cast<const char*>(&val);
    const char *endPtr = reinterpret_cast<const char*>(&val + n);
    for (; beginPtr < endPtr; beginPtr += cacheLineSize)
        __builtin_prefetch(beginPtr, writeOnly, temporalLocality);
#endif
}

} // namespace Ewoms

#endif
