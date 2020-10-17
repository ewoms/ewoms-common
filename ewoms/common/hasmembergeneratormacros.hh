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
 *
 * \copydoc EWOMS_GENERATE_HAS_MEMBER
 */
#ifndef EWOMS_HAS_MEMBER_GENERATOR_MACROS_HH
#define EWOMS_HAS_MEMBER_GENERATOR_MACROS_HH

/// \cond 0
namespace Ewoms {
template <class T>
struct AlwaysVoid
{
    typedef void type;
};
}
/// \endcond

/*!
 * \brief This macro generates a class HasMember_${MEMBER_NAME} which can be used for
 *        template specialization.
 *
 * e.g. if EWOMS_GENERATE_HAS_MEMBER(foo, int(), int(), int()) has been used,
 * HasMember_foo<T>::value is true (if and only if) t.foo(int(), int(), int()) is a valid
 * expression for an object t of the class T.
 */
#define EWOMS_GENERATE_HAS_MEMBER(MEMBER_NAME, ...)                       \
    template <class T, class T2>                                        \
    struct HasMember_##MEMBER_NAME##_Helper                             \
    {                                                                   \
        static constexpr bool value = false;                            \
    };                                                                  \
                                                                        \
    template <class T>                                                  \
    struct HasMember_##MEMBER_NAME##_Helper<T,                             \
      typename Ewoms::AlwaysVoid<decltype(std::declval<T>().MEMBER_NAME(__VA_ARGS__))>::type> \
    {                                                                   \
        static constexpr bool value = true;                             \
    };                                                                  \
                                                                        \
    template<typename T>                                                \
    struct HasMember_##MEMBER_NAME                                            \
    {                                                                   \
        static constexpr bool value = HasMember_##MEMBER_NAME##_Helper<T, void>::value; \
    };

#endif
