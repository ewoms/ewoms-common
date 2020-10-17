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
 * \brief Provides the ewoms-common specific exception classes.
 */
#ifndef EWOMS_MATERIAL_EXCEPTIONS_HH
#define EWOMS_MATERIAL_EXCEPTIONS_HH

#include <dune/common/exceptions.hh>

#include <stdexcept>

// the ewoms-common specific exception classes
namespace Ewoms {
class NumericalIssue
    : public std::runtime_error
{
public:
    explicit NumericalIssue(const std::string &message)
      : std::runtime_error(message)
    {}
};
}

#endif // EWOMS_MATERIAL_EXCEPTIONS_HH
