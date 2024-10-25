# AppBackup-onRecovery
A suite of scripts used to backup app data on recovery. Suitable for that device cannot boot properly.

Recovery环境下的应用备份套件，适用于安卓11+设备。用于在无法启动到Android时备份应急的应用数据。

~~人送外号"Titanium Backup for Recovery" (bushi~~

在twrp和orangefox中测试良好。

> 10.24程序员节快乐（

```bash
#########################################################################################
#  WARNING:                                #  警告：                                    #
#  We are not responsible for dead sdcard, #  我们不对SD卡损坏，数据丢失，核战争，或者  #
#  lost data, nuclear war, or you getting  #  你因为闹钟不响铃而被解雇负责。            #
#  fired because the alarm app failed.     #                                            #
#  This script is only for emergency use.  #  此脚本仅用于紧急情况。                    #
#  The backup data may not be complete.    #  备份数据可能不完整。                      #
#  We not guarantee the backup data.       #  我们不保证备份数据。                      #
#  Use at your own risk.                   #  请自行承担风险。                          #
#  You have been warned!                   #  你已经被警告！                            #
#########################################################################################
```

## Usage 用法

### Backup 备份

As the title says, this script is used to backup app data on **RECOVERY ENVIRONMENT**.

就像标题所说，这个脚本仅用于在**RECOVERY环境**中备份应用数据。

#### Direct use by Script 直接使用脚本
Download the **backup.sh**, the push into device.

Add run permission to this file.

Then wait. Your total backup file will store at `/sdcard/complete_backup.tar.gz`.

Your device may not have enough space to store the backup file, if in that case, you may want to backup to an external storage that connected by OTG (that mean you should edit the script by your self), or push the backup file to your computer (You should stare at the terminal, wait an tar.gz complete, then pulled them by adb. Annoying.).

下载 **backup.sh**，然后推送到设备中。

添加运行权限。

然后等待。

你的完整备份文件将存储在`/sdcard/complete_backup.tar.gz`。

你的设备可能没有足够的空间来存储备份文件, 如果是这种情况，你可能需要备份到一个通过OTG连接的外部存储 (你将需要自己编辑脚本），或者将备份文件推送到你的电脑。 (你应该盯着终端，等待tar.gz完成，然后通过adb拉取它们。 烦人。)

```shell
git clone https://github.com/SteveZMTstudios/AppBackup-onRecovery.git
cd AppBackup-onRecovery
adb push ./backup.sh /tmp
adb shell chmod +x /tmp/backup.sh
adb shell sh /tmp/backup.sh
adb pull /sdcard/complete_backup.tar.gz /path/to/your/backup/folder
```

> Verbose version is also available. Use `sh /tmp/backup.sh -v` to enable verbose mode.
>
> Verbose版本也可用。使用 `sh /tmp/backup.sh -v` 来启用详细模式。

#### Via Install Zip 通过安装zip包
(Still in development) (仍在开发中)
Download the **backup.zip**, then install it in recovery.

Then wait.

下载 **backup.zip**，然后在recovery中安装。

然后等待。


### Restore 还原
Unzip to move files by your self. :)

(Cause the restore script is not completed yet.)

解压缩后自行移动文件。:)

(因为还原脚本尚未完成。=.=)

## Features 功能

- [x] Backup app data 备份应用数据
- [ ] Restore app data 还原应用数据
- [ ] Backup Storage 备份存储

## Known Issues 已知问题

Not suitable for Android 10 and below. (Because the apk directory structure has been changed after Android 11)

App when restored may not work properly. (Because some app require a match Android ID or more)

Some data may still lost. (Because some app doen't store data in /data/data/ or they should store in.)

不适用于安卓10及以下。(因为Android 11以后变更了apk的目录结构)

还原后的应用可能无法正常工作。(因为一些应用需要匹配Android ID或更多)

一些数据可能仍然丢失。(因为一些应用不会存储数据在/data/data/或者他们应该存储的位置。)

脚本使用的是英文（你不能苛责这一点！不是所有的Recovery都带中文！）


## Backup Package Tree 备份包目录结构
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
