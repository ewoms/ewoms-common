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
 * \copydoc Ewoms::GenericGuard
 */
#ifndef EWOMS_GENERIC_GUARD_HH
#define EWOMS_GENERIC_GUARD_HH

namespace Ewoms {
/*!
 * \ingroup Common
 *
 * \brief A simple class which makes sure that a cleanup function is called once the
 *        object is destroyed.
 *
 * This class is particularly useful in conjunction with lambdas for code that might
 * throw exceptions.
 */
template <class Callback>
class GenericGuard
{
public:
    GenericGuard(Callback& callback)
        : callback_(callback)
        , isEnabled_(true)
    { }

    // allow moves
    GenericGuard(GenericGuard&& other)
        : callback_(other.callback_)
        , isEnabled_(other.isEnabled_)
    {
        other.isEnabled_ = false;
    }

    // disable copies
    GenericGuard(const GenericGuard& other) = delete;

    ~GenericGuard()
    {
        if (isEnabled_)
            callback_();
    }

    /*!
     * \brief Specify whether the guard object is "on duty" or not.
     *
     * If the guard object is destroyed while it is "off-duty", the cleanup callback is
     * not called. At construction, guards are on duty.
     */
    void setEnabled(bool value)
    { isEnabled_ = value; }

    /*!
     * \brief Returns whether the guard object is "on duty" or not.
     */
    bool enabled() const
    { return isEnabled_; }

    /*!
     * \brief Trigger the guard as if the guard object was destroyed.
     *
     * After calling this method, the guard is disabled.
     */
    void trigger()
    {
        if (isEnabled_)
            callback_();

        isEnabled_ = false;
    }

private:
    Callback& callback_;
    bool isEnabled_;
};

template <class Callback>
GenericGuard<Callback> make_guard(Callback& callback)
{ return GenericGuard<Callback>(callback); }

} // namespace Ewoms

#endif
