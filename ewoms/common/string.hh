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
 * \brief Provides some Boost-surrogate string manipulation routines.
 */
#ifndef EWOMS_UTILITY_STRING_HH
#define EWOMS_UTILITY_STRING_HH

#include <algorithm>
#include <cctype>
#include <sstream>
#include <string>
#include <vector>

namespace Ewoms {

template< typename T, typename U >
U& uppercase( const T& src, U& dst ) {
    const auto up = []( char c ) { return std::toupper( c ); };
    std::transform( std::begin( src ), std::end( src ), std::begin( dst ), up );
    return dst;
}

template< typename T >
typename std::decay< T >::type uppercase( T&& x ) {
    typename std::decay< T >::type t( std::forward< T >( x ) );
    return uppercase( t, t );
}

template<typename T>
std::string ltrim_copy(const T& s)
{
    auto ret = std::string(s.c_str());

    const auto start = ret.find_first_not_of(" \t\n\r\f\v");
    if (start == std::string::npos)
        return "";

    return ret.substr(start);
}

template<typename T>
std::string rtrim_copy(const T& s)
{
    auto ret = std::string(s.c_str());

    const auto end = ret.find_last_not_of(" \t\n\r\f\v");
    if (end == std::string::npos)
        return "";

    return ret.substr(0, end + 1);
}

template<typename T>
std::string trim_copy(const T& s)
{
    return ltrim_copy( rtrim_copy(s) );
}

template<typename T>
void replaceAll(T& data, const T& toSearch, const T& replace)
{
    // Get the first occurrence
    size_t pos = data.find(toSearch);

    // Repeat till end is reached
    while (pos != std::string::npos)
    {
        // Replace this occurrence of Sub String
        data.replace(pos, toSearch.size(), replace);
        // Get the next occurrence from the current position
        pos = data.find(toSearch, pos + replace.size());
    }
}

inline std::vector<std::string> split_string(const std::string& input,
                                             char delimiter)
{
    std::vector<std::string> result;
    std::string token;
    std::istringstream tokenStream(input);
    while (std::getline(tokenStream, token, delimiter))
        result.push_back(token);

    return result;
}

inline std::vector<std::string> split_string(const std::string& input,
                                             const std::string& delimiters)
{
    std::vector<std::string> result;
    std::string::size_type start = 0;
    while (start < input.size()) {
        auto end = input.find_first_of(delimiters, start);
        if (end == std::string::npos) {
            result.push_back(input.substr(start));
            end = input.size() - 1;
        } else if (end != start)
            result.push_back(input.substr(start, end-start));

        start = end + 1;
    }

    return result;
}

}

#endif
