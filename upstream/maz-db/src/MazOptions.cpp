/* Copyright (C) 2017 Dan Chapman <dpniel@ubuntu.com>

   This file is part of Dekko email client for Ubuntu devices

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License or (at your option) version 3

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
#include "MazOptions.h"
#include <leveldb/options.h>

MazOptions::MazOptions(QObject *parent) : QObject(parent),
    m_createIfMissing(true), m_errorIfExists(false), m_paranoidChecks(false),
    m_compressionType(CompressionType::SnappyCompression)
{
}

bool MazOptions::createIfMissing() const
{
    return m_createIfMissing;
}

bool MazOptions::errorIfExists() const
{
    return m_errorIfExists;
}

bool MazOptions::paranoidChecks() const
{
    return m_paranoidChecks;
}

MazOptions::CompressionType MazOptions::compressionType() const
{
    return m_compressionType;
}

void MazOptions::setCreateIfMissing(const bool value)
{
    if (value != m_createIfMissing) {
        m_createIfMissing = value;
        emit optionChanged();
    }
}

void MazOptions::setErrorIfExists(const bool value)
{
    if (value != m_errorIfExists) {
        m_errorIfExists = value;
        emit optionChanged();
    }
}

void MazOptions::setParanoidChecks(const bool value)
{
    if (value != m_paranoidChecks) {
        m_paranoidChecks = value;
        emit optionChanged();
    }
}

void MazOptions::setCompressionType(const MazOptions::CompressionType type)
{
    if (type != m_compressionType) {
        m_compressionType = type;
        emit optionChanged();
    }
}

