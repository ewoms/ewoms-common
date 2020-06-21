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
#ifndef EWOMS_VARIANT_HH
#define EWOMS_VARIANT_HH

#if HAVE_STD_VARIANT
#include <variant>
#elif HAVE_BOOST_VARIANT
#include <boost/variant.hpp>
#else
#error "Either std::variant or boost::variant is required to use this header file"
#endif

#include <random>
#include <algorithm>
#include <string>

namespace Ewoms
{
#if HAVE_STD_VARIANT
template <class ...T>
using variant = std::variant<T...>;

template <class ...T>
int variantIndex(const variant<T...> v)
{ return v.index(); }

template <class T, class ...U>
constexpr bool holds_alternative(const variant<U...>& v)
{ return std::holds_alternative<T>(v); }

template <int i, class ...U>
auto get(variant<U...>& v)
    -> decltype(std::get<i>(v))
{ return std::get<i>(v); }

template <int i, class ...U>
auto get(const variant<U...>& v)
    -> decltype(std::get<i>(v))
{ return std::get<i>(v); }

template <class T, class ...U>
auto get(variant<U...>& v)
    -> decltype(std::get<T>(v))
{ return std::get<T>(v); }

template <class T, class ...U>
auto get(const variant<U...>& v)
    -> decltype(std::get<T>(v))
{ return std::get<T>(v); }

#elif HAVE_BOOST_VARIANT
template <class ...T>
using variant = boost::variant<T...>;

template <class ...T>
int variantIndex(const variant<T...> v)
{ return v.which(); }

template <class T>
constexpr bool holds_alternative__()
{ return false; }

template <class T, class U0, class ...U>
constexpr bool holds_alternative__()
{ return std::is_same<T, U0>::value || holds_alternative__<T, U...>(); }

template <class T, class ...U>
constexpr bool holds_alternative(const variant<U...>& v)
{ return holds_alternative__<T, U...>(); }

template <int i, class ...U>
auto get(variant<U...>& v)
    -> decltype(boost::get<i>(v))
{ return boost::get<i>(v); }

template <int i, class ...U>
auto get(const variant<U...>& v)
    -> decltype(boost::get<i>(v))
{ return boost::get<i>(v); }

template <class T, class ...U>
auto get(variant<U...>& v)
    -> decltype(boost::get<T>(v))
{ return boost::get<T>(v); }

template <class T, class ...U>
auto get(const variant<U...>& v)
    -> decltype(boost::get<T>(v))
{ return boost::get<T>(v); }

#endif
} // namespace Ewoms

#endif //  EWOMS_VARIANT_HH
