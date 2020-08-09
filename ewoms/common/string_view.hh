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
#ifndef EWOMS_STRING_VIEW_HH
#define EWOMS_STRING_VIEW_HH

#if HAVE_STD_STRING_VIEW
#include <string_view>
#elif HAVE_STD_EXPERIMENTAL_STRING_VIEW
#include <experimental/string_view>
#else
#error "Either std::string_view or std::experimental::string_view is required to use this header file"
#endif

#include <random>
#include <algorithm>
#include <string>

namespace Ewoms
{
#if HAVE_STD_STRING_VIEW
    using string_view = std::string_view;
#elif HAVE_STD_EXPERIMENTAL_STRING_VIEW
    using string_view = std::experimental::string_view;
#endif
} // namespace Ewoms

#endif //  EWOMS_STRING_VIEW_HH
