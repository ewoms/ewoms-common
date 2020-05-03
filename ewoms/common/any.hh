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
#ifndef EWOMS_ANY_HH
#define EWOMS_ANY_HH

#if HAVE_STD_ANY
#include <any>
#elif HAVE_STD_EXPERIMENTAL_ANY
#include <experimental/any>
#elif HAVE_BOOST_ANY
#include <boost/any.hpp>
#else
#error "Either std::any, std::experimental::any or boost::any are required to use this header file"
#endif

#include <random>
#include <algorithm>
#include <string>

namespace Ewoms
{
#if HAVE_STD_ANY

using any = std::any;

template <class T>
T any_cast(const any& a)
{ return std::any_cast<T>(a); }

template <class T>
T any_cast(any& a)
{ return std::any_cast<T>(a); }

template <class T>
const T* any_cast(const any* a)
{ return std::any_cast<T>(a); }

template <class T>
T* any_cast(any* a)
{ return std::any_cast<T>(a); }

#elif HAVE_STD_EXPERIMENTAL_ANY

using any = std::experimental::any;

template <class T>
T any_cast(const any& a)
{ return std::experimental::any_cast<T>(a); }

template <class T>
T any_cast(any& a)
{ return std::experimental::any_cast<T>(a); }

template <class T>
const T* any_cast(const any* a)
{ return std::experimental::any_cast<T>(a); }

template <class T>
T* any_cast(any* a)
{ return std::experimental::any_cast<T>(a); }

#elif HAVE_BOOST_ANY

using any = boost::any;

template <class T>
T any_cast(const any& a)
{ return boost::any_cast<T>(a); }

template <class T>
T any_cast(any& a)
{ return boost::any_cast<T>(a); }

template <class T>
const T* any_cast(const any* a)
{ return boost::any_cast<T>(a); }

template <class T>
T* any_cast(any* a)
{ return boost::any_cast<T>(a); }

#endif
} // namespace Ewoms

#endif //  EWOMS_ANY_HH
