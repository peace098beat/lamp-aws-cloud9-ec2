# *********************************************************************
#    ####   ######     ###    #     # 
#   #    #  #     #   #   #   ##    # 
#  #        #     #  #     #  # #   # 
#  #        ######   #     #  #  #  # 
#  #        #   #    #     #  #   # # 
#   #    #  #    #    #   #   #    ## 
#    ####   #     #    ###    #     # 
#
# [crondの実行ログ]
#   cronの実行ログは/var/log/cronに書き込まれている. 
#   以下のコマンドで確認できる
#   $ sudo cat /var/log/cron
#   または
#   $ tail -f /var/log/cron
# 
#
# *********************************************************************


#!/bin/sh
set -eu

if [ `whoami` = 'root' ]; then
    echo 'sudoは付けてはいけません. $ sh setup.sh'
    exit;
fi

# 以下、スクリプト本体
sudo mv /home/ec2-user/environment/setup-scripts/test_cron /etc/cron.d/test_cron # cronファイルをコピー
sudo chmod 644 /etc/cron.d/test_cron
sudo chown root:root /etc/cron.d/test_cron
sudo cat /etc/cron.d/test_cron # cronファイルを確認

# CRONのリスタート
sudo /etc/init.d/crond restart
sudo /etc/init.d/crond status

