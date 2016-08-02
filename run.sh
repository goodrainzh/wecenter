#!/bin/bash

[ $DEBUG ] && set -x

AppDir="/app"
UserCfg="${AppDir}/system/config/database.php"
InstallFile="${AppDir}/install/index.php"
TmpCfgDir=/app/.config

# 如果已经保存了数据库配置文件，做软连接处理
[ -f $TmpCfgDir/database.php ] && ln -s $TmpCfgDir/database.php $UserCfg

# 如果存在my.php 清理install.php和upgrade.php 文件
if [ -f $UserCfg ];then
  [ -f $InstallFile ] && rm -f $InstallFile
fi

# crontab for process config file
crontab cron.txt && cron

# 启动web server
vendor/bin/heroku-php-nginx -F fpm_custom.conf
