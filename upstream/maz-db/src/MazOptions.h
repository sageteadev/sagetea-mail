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
#ifndef MAZOPTIONS_H
#define MAZOPTIONS_H

#include <QObject>

namespace leveldb {
class DB;
struct Options;
}

class MazOptions : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool createIfMissing READ createIfMissing WRITE setCreateIfMissing NOTIFY optionChanged)
    Q_PROPERTY(bool errorIfExists READ errorIfExists WRITE setErrorIfExists NOTIFY optionChanged)
    Q_PROPERTY(bool paranoidChecks READ paranoidChecks WRITE setParanoidChecks NOTIFY optionChanged)
    Q_PROPERTY(CompressionType compressionType READ compressionType WRITE setCompressionType NOTIFY optionChanged)
    Q_ENUMS(CompressionType)
public:
    explicit MazOptions(QObject *parent = 0);

    enum CompressionType{
        NoCompression     = 0x0,
        SnappyCompression = 0x1
    };

    bool createIfMissing() const;
    bool errorIfExists() const;
    bool paranoidChecks() const;
    CompressionType compressionType() const;

signals:
    void optionChanged();

public slots:
    void setCreateIfMissing(const bool value);
    void setErrorIfExists(const bool value);
    void setParanoidChecks(const bool value);
    void setCompressionType(const CompressionType type);

private:
    Q_DISABLE_COPY(MazOptions)
    bool m_createIfMissing;
    bool m_errorIfExists;
    bool m_paranoidChecks;
    CompressionType m_compressionType;
};

#endif // MAZOPTIONS_H
