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

#if __cplusplus < 201703L || \
    (defined(__GNUC__) && __GNUC__ < 8)
#include <experimental/filesystem>
#else
#include <filesystem>
#endif

#include <random>
#include <algorithm>
#include <string>

namespace Ewoms
{
#if __cplusplus < 201703L || \
    (defined(__GNUC__) && __GNUC__ < 8)
    namespace filesystem = std::experimental::filesystem;
#else
    namespace filesystem = std::filesystem;
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
