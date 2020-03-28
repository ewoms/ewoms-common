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
#ifndef EWOMS_OPTIONAL_HH
#define EWOMS_OPTIONAL_HH

#if HAVE_STD_OPTIONAL
#include <optional>
#elif HAVE_STD_EXPERIMENTAL_OPTIONAL
#include <experimental/optional>
#else
#error "Either std::optional or std::experimental::optional is required to use this header file"
#endif

#include <random>
#include <algorithm>
#include <string>

namespace Ewoms
{
#if HAVE_STD_OPTIONAL
    template <class T>
    using optional = std::optional<T>;
    constexpr auto nullopt = std::nullopt;
#elif HAVE_STD_EXPERIMENTAL_OPTIONAL
    template <class T>
    using optional = std::experimental::optional<T>;
    constexpr auto nullopt = std::experimental::nullopt;
#endif
} // namespace Ewoms

#endif //  EWOMS_OPTIONAL_HH
