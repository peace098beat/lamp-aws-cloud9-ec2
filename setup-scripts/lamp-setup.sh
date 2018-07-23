# *****************************************************************************
#                                                              
#  ###      #                  #      #   #   #  ###        #   
#  #        #                  #     ##  # # ##  # #        #   
#  #    ## ### ## #  ####      #     ##  # ## #  # #    ##  ### 
#   ## # # #   #  #  ## #      #    #  # # ###  ###     #  ## # 
#    # ### #   # #   #  #     #     #### # # #  #        # ## # 
# ###  ### ##  ###   ###      #### #   # #   #  #    # ##  #  # 
#                   #     ###                                   
# 
# Author : T.Nohara
# Date: 2018/07/22
#
# [概要]
# 2018年現在、AWS Cloud9サービスを利用することで、EC2インスタンスを自動で生成し
# ブラウザ経由でSSH接続/コード編集ができるといったとても便利な時代になった。
# 現在、Cloud9コンソールを利用して新規EC2を立ち上げると、
# LAMP環境(Linux, Apache, MySQL, PHP)がそろったAmazon Linuxが立ち上がる.
# 本スクリプトは、上述のCloud9にて構築したLAMP環境EC2にて、
# Webページを作成するためのセットアップを記述している.セットアップ内容は以下に示す.
# 
# [セットアップ内容]
#	 :PHP:
#		PHP7へアップデート (必要であれば)
#	 :Apache:
#		サービス起動
#		サービスの自動起動を設定
#		index.phpを生成
#		接続確認
#	 :MySQL:
#		ROOTパスワード生成
#		テストユーザ、テストDBの作成
#
# [使い方]
#	sh setup.sh (sudoは付けないこと!)
#
# [参考]
# [AWS Cloud9 のPHP/MySQL を 7.1/5.7 にしてみる - Qiita](https://qiita.com/kunit/items/ade739818ef86d8de716)
# [AWS EC2にLAMP環境を構築するまで - Qiita](https://qiita.com/michimani/items/06e4d625205b94d4c039)
# [ホームディレクトリ以下のファイルへのシンボリックリンクが読み込めない - Handwriting](http://lv4.hateblo.jp/entry/2014/02/20/221439)
#					 	== Enjoy!! ==

# /*************************/
# /* MySQL                  /
# /* DB名 : test_db 	      /
# /* ユーザー名 : test_user   /
# /* ユーザーパスワード: jogpass098/
# /*************************/


# 以下、スクリプト本体


#!/bin/sh
set -eu

# 念のため実行者確認. スーパーユーザーではダメです
if [ `whoami` = 'root' ]; then
    echo 'sudoは付けてはいけません. 右のようにしてください: $ sh setup.sh'
    exit;
fi



echo ================================================== #
echo PHP SETUP  #
echo ================================================== #
php -v 						# ヴァージョン確認

# PHP7を使う場合はコメント解除 --
sudo yum -y install php71 php71-cli php71-common php71-devel php71-mysqlnd php71-pdo php71-xml php71-gd php71-intl php71-mbstring php71-mcrypt php71-opcache php71-pecl-apcu php71-pecl-imagick php71-pecl-memcached php71-pecl-redis php71-pecl-xdebug
sudo alternatives --set php /usr/bin/php-7.1 
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer
# -- (ここまで) PHP7を使う場合はコメント解除

echo ================================================== #
echo Web Server SETUP
echo DocumentRoot "/var/www/html"
echo ================================================== #
httpd -v                    # ヴァージョン確認
sudo service httpd stop            #　webサーバーの起動
sudo chkconfig httpd on     # 再起動時に自動起動するように設定
sudo service httpd start            #　webサーバーの起動
sudo service httpd status   # webサーバーの状態確認

# welcomページを削除
sudo mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.backup

# リンクされた新しいドキュメントルートを作る
PUBLIC_DIR=/home/ec2-user/environment/www/public
mkdir -p $PUBLIC_DIR
mkdir -p $PUBLIC_DIR/api
sudo chown -R ec2-user:ec2-user /home/ec2-user/environment/www
# index.phpを生成
sh -c "echo 'hello' > $PUBLIC_DIR/index.php" #indexファイルの配置
sh -c "date >> $PUBLIC_DIR/index.php" # 配置時刻を追加
sh -c "echo '<?php' >> $PUBLIC_DIR/index.php" #indexファイルの配置
sh -c "echo 'phpinfo();' >> $PUBLIC_DIR/index.php" # 配置時刻を追加

# いらない?
# sudo usermod -a -G apache ec2-user # ec2-user を apache グループに追加
# 一旦ログアウトして再度ログイン

# /var/www/htmlを削除
sudo rm -rf /var/www/html

# シンボリックリンクを張る
sudo ln -s $PUBLIC_DIR /var/www/html
chmod 755 /home/ec2-user # アクセス権限の設定 (根元のDIRまでアクセス権は影響する)
sudo service httpd restart            #　webサーバーの起動
curl localhost              # ウェブページの確認



echo ================================================== #
echo MySQL SETUP
echo ================================================== #
mysql --version             # ヴァージョン確認

# MySQL57を使う場合はコメント解除 --
sudo service mysqld stop
sudo yum -y erase mysql-config mysql55-server mysql55-libs mysql55
sudo yum -y install mysql57-server mysql57
sudo service mysqld start
# -- (ここまで) MySQL57を使う場合はコメント解除

mysql --version             # ヴァージョン確認

sudo chkconfig mysqld on    # 自動起動を設定
chkconfig --list mysqld     # 自動起動の設定確認

sudo service mysqld start        # MySQLの起動開始
sudo service mysqld status        # MySQLの状態を確認


# 初期状態ではmysql -urootでパスワード無しでアクセスできる
mysql -uroot << EOF
-- 新しくデータベースを作成する
CREATE DATABASE IF NOT EXISTS test_db;
-- データベース一覧を表示する
SHOW DATABASES;
EOF

mysql -uroot << EOF
-- 新しくユーザーを作成する (ハマリポイント:USER IF EXISTSはMySQL5.7系しか使えない. 5.5系の場合はコメントアウトしておく)
DROP USER IF EXISTS 'test_user'@'localhost';
CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'jogpass098';

-- 作成したユーザーに作成したデータベースの操作権限を付与する
GRANT ALL PRIVILEGES ON test_db.* TO 'test_user'@'localhost';

-- 設定を反映する
FLUSH PRIVILEGES;

-- ユーザー一覧を表示する
SELECT host, user FROM mysql.user;
-- SELECT host, user, password FROM mysql.user;
EOF

mysql -uroot << EOF
-- テーブルの作成
DROP TABLE IF EXISTS test_db.test_tbl;
CREATE TABLE IF NOT EXISTS test_db.test_tbl (
	id int AUTO_INCREMENT,
	date text(100),
	PRIMARY KEY (ID)
	);

-- テーブル一覧を表示する
SHOW TABLES FROM test_db;

-- テーブルの列の情報を一覧表示する
SHOW COLUMNS FROM test_db.test_tbl;
EOF

mysql -uroot << EOF
-- 一行だけ挿入
INSERT INTO test_db.test_tbl (date) VALUES ("2018/00/00 00:00:00");
-- 全部取得
SELECT * FROM test_db.test_tbl;
EOF




echo ================================================== #
echo 日本時間の設定
echo ================================================== #
date  # 現在時刻を確認
sudo cp /etc/localtime /etc/localtime.org	# オリジナルをバックアップ
sudo ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime # タイムゾーンファイルの変更
# 以下、再起動時にタイムゾーンがUTCに戻らないための対応をします。
sudo cp /etc/sysconfig/clock /etc/sysconfig/clock.org # 一応、バックアップを取ります
sudo sh -c 'echo ZONE="Asia/Tokyo" > /etc/sysconfig/clock'
sudo sh -c "echo 'UTC=false' >> /etc/sysconfig/clock"
sudo cat /etc/sysconfig/clock
date

echo ================================================== #
echo CRONの設定
echo ================================================== #



# スクリプト終わり

echo "FIN :D"
