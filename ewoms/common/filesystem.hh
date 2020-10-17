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
#ifndef EWOMS_FILESYSTEM_HH
#define EWOMS_FILESYSTEM_HH

#if HAVE_STD_FILESYSTEM
#include <filesystem>
#elif HAVE_STD_EXPERIMENTAL_FILESYSTEM
#include <experimental/filesystem>
#else
#error "Either std::filesystem or std::experimental::filesystem is required to use this header file"
#endif

#include <random>
#include <algorithm>
#include <string>

namespace Ewoms
{
#if HAVE_STD_FILESYSTEM
    namespace filesystem = std::filesystem;
#elif HAVE_STD_EXPERIMENTAL_FILESYSTEM
    namespace filesystem = std::experimental::filesystem;
#endif

    // A poor man's filesystem::unique_path
    inline std::string unique_path(const std::string& input)
    {
        std::random_device rd;
        std::mt19937 gen(rd());
        auto randchar = [&gen]()
        {
            const std::string set = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
            std::uniform_int_distribution<> select(0, set.size()-1);
            return set[select(gen)];
        };

        std::string ret;
        ret.reserve(input.size());
        std::transform(input.begin(), input.end(), std::back_inserter(ret),
                       [&randchar](const char c)
                       {
                           return (c == '%') ? randchar() : c;
                       });

        return ret;
    }


} // end namespace Ewoms

#endif //  EWOMS_FILESYSTEM_HH
