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
#ifndef SNAPSTANDARDPATHS_H
#define SNAPSTANDARDPATHS_H

#include <QStringList>

class Q_CORE_EXPORT SnapStandardPaths
{
public:

    enum StandardLocation {
        HomeLocation,
        CommonHomeLocation,
        CacheLocation,
        CommonCacheLocation,
        AppCacheLocation,
        CommonAppCacheLocation,
        DataLocation,
        CommonDataLocation,
        AppDataLocation,
        CommonAppDataLocation,
        ConfigLocation,
        CommonConfigLocation,
        AppConfigLocation,
        CommonAppConfigLocation
    };

    enum LocateOption {
        LocateFile = 0x0,
        LocateDirectory = 0x1
    };
    Q_DECLARE_FLAGS(LocateOptions, LocateOption)

    static QString writableLocation(StandardLocation location);
    static QStringList standardLocations(StandardLocation location);

    static void setTestModeEnabled(bool testMode);
    static bool isTestModeEnabled();

private:
    // prevent construction
    SnapStandardPaths();
    ~SnapStandardPaths();
};

#endif // SNAPSTANDARDPATHS_H
