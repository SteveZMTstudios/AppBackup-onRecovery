# AppBackup-onRecovery
A suite of scripts used to backup app data on recovery. Suitable for that device cannot boot properly.

Recovery 应用备份套件，适用于安卓12+设备（因为没有在更低版本中测试）。用于在无法启动到Android时备份应急的应用数据。

~~人送外号"Titanium Backup for Recovery" (bushi~~

在twrp和orangefox中测试良好。

> 10.24程序员节快乐（

```bash
############################################
#  WARNING:                                #
#  This script is only for emergency use.  #
#  The backup data may not be complete.    #
#  We not guarantee the backup data.       #
#  Use at your own risk.                   #
#  You have been warned!                   #
############################################
```

## Usage 用法

### Backup 备份

#### Direct use by Script 直接使用脚本
Download the **backup.sh**, the push into device.

Add run permission to this file.

Then wait.



```shell
git clone https://github.com/SteveZMTstudios/AppBackup-onRecovery.git
cd AppBackup-onRecovery
adb push ./backup.sh /tmp
adb shell chmod +x /tmp/backup.sh
adb shell sh /tmp/backup.sh
```

> Verbose version is also available. Use `sh /tmp/backup_verbose.sh` to use verbose ver.

#### Via Install Zip 通过安装zip包
Download the **backup.zip**, then install it in recovery.

Then wait.


### Restore 还原
Unzip to move files by your self. :)

(Cause the restore script is not completed yet. =.=)



## 目录结构
```
/sdcard/EmergencyBak/
            |---<packagename>-backup.tar.gz
                    |---|- data
                        |   |- app (same as /data/app/*)
                        |- data_data
                        |  |- data
                        |       |- data (same as /data/data/*)
                        |- data_user
                        |- data_user_de
                        |- media_data
                        |- media_obb
```

## Licenses
```
AppBackup-onRecovery, including all git submodules are free software:
you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by the Free Software Foundation,
either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
