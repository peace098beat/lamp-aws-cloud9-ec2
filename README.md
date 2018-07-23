
# AWS Cloud9のEC2直結環境に LAMP環境構築

AWS Cloud9にてEC2の新規作成をして直接SSHで入っている環境が数分で手に入る.
開発用に至急作業したいことがあるだろう。
しかし、そのままだと色々不便なので、事前セットアップスクリプトを準備した。

## 概要
2018年現在、AWS Cloud9サービスを利用することで、EC2インスタンスを自動で生成しブラウザ経由でSSH接続/コード編集ができるといったとても便利な時代になった。現在(2018/07/23)、Cloud9コンソールを利用して新規EC2を立ち上げると、LAMP環境(Linux, Apache, MySQL5.5, PHP5)がそろったAmazon Linuxが立ち上がる.本スクリプトは、上述のCloud9にて構築したLAMP環境EC2にて、PHP7, MySQL5.7へアップデートしWebページを作成するためのセットアップを記述している.セットアップ内容は以下に示す.

## セットアップ内容

セットアップ内容は以下の通りである
```
* :PHP:
		PHP7へアップデート
* :Apache:
		サービス起動
		サービスの自動起動を設定
		index.phpを生成
		接続確認
* :MySQL:
		ROOTパスワード生成
		テストユーザ、テストDBの作成
* :CRON:
       毎分起動されるCRONの設定
```

## 環境作成方法

1. AWS Cloud9へログイン
2. 「Create environment」で環境構築開始
3. 環境の「名前」と「概要」を適当に入力
4. Envronment settings
    * Create a new instance for envronment(EC2)を選択
    * あとはデフォルトでOK
5. 構築まで少し待つ


## セットアップ方法
環境が構築されたら、セットアップの前にポートを開放する

```
EC2のページを開き, インバウンドのhttp/ポート80を開放しておく.
```


次に本リポジトリのスクリプトをgitを使ってクローンし実行する。

```
# 一度クローン先を空にする
$ sh rm -rf ~/environment/*

# リポジトリをクローン (中身だけをクローン)
$ git clone https://github.com/peace098beat/lamp-aws-cloud9-ec2.git ~/environment/. 

# セットアップスクリプトの実行
$ sh ./setup-scripts/lamp-setup.sh
```

以上.

セットアップは完了です.

開発を初めてください。

以下は、リポジトリの詳細説明です。

# 詳細説明

## ファイルの説明

```
/home/ec2-user/environment/         (clound9 IDEのホームディレクトリ.)
├── README.md
├── setup-scripts     (セットアップに利用するスクリプト郡. 作業後削除)
│   ├── cron-setup.sh
│   ├── lamp-setup.sh
│   └── test_cron
└── www
    ├── cron      (cronにより実行されるファイル郡)
    │   ├── 1min_exec.php
    │   ├── 1min_exec.sh
    │   └── 60min_exec.php
    ├── logs      (実行ログ)
    │   ├── 1min_exec.php.log
    │   ├── 1min_exec.sh.log
    │   ├── 60min_exec.php.log
    │   ├── cron_envs.log
    │   └── date-now-cron.log
    └── public    (ドキュメントルート)
        ├── index.php
        ├── test_mysql_insert.php
        └── test_web.php
```

* ec2-user: ログインユーザ名である。
* /home/ec2-user/environment/: clound9 IDEのホームディレクトリ. 本当は/home/ec2-user/等に変更したいが、やり方がみつからなかったので、しかたなく今回の作業ディレクトリとしてる。
* README.md: 本ファイルである。
* setup-scripts/ : セットアップに利用するスクリプト郡の格納ディレクトリである. セットアップが終われば削除してください。
* www/: ウェブに必要なファイル郡格納用ディレクトリ. (公開はされてません.)
* www/public: ドキュメントルートです. 公開ディレクトリ.
* www/logs: 実行ログの格納ディレクトリ. 主にCRONで実行されたファイルのログを格納
* www/cron: システムCRONによって定期的に呼び出されるファイルを格納

## MySQLの操作方法

PHP7でのMySQLへのアクセスには[PDO](http://php.net/manual/ja/class.pdo.php)を用いている.
LOGIN, SELECT, INSERTについては[/www/public/test_mysql_insert.php](https://github.com/peace098beat/lamp-aws-cloud9-ec2/blob/master/www/public/test_mysql_insert.php)参照のこと

```
# root権限でログイン
$ mysql -uroot
```


## CRONの設定方法

(lamp-setup.shの実行時にCRONは起動させてます。通常は以下の処理は不要です。以下は、変更が必要な場合の方法です)

CRONの実行にはCRONファイルを/etc/crond.d/*に配置し、crondを再起動する必要がある.
その際/etc/crond.d/*に配置するファイルのパーミッション等の取り決めがあり面倒なのでスクリプト化してある。

CRONの設定方法は、test_cronに変更を加えたあと./setup-scripts/cron-setup.shを実行すると反映される.

1. CRONファイルを変更

```
$ vim ./setup-scripts/test_cron

(CRONファイルを修正)...

```

2. crondを再起動

 
```
$ sh ./setup-scripts/cron-setup.sh
```

CRONのシステムログの場所.
test_cronを書き換えて動作確認する際に注意が必要。
cronファイルは決まりが多いため、少しでも文法ミス等がある場合はシステムエラーとなる。
その際には、下記のシステムログにログが吐かれるので参照のこと.

```
# 場所
$ /var/log/cron

# ログの内容を確認する
$ tail -f /var/log/cron
```

CRONのユーザログの場所CRON. CRONによって実行されたユーザのファイルの実行結果は以下のディレクトリに吐かれる。
ドコに吐き出すかは./setup-scripts/test_cronファイルに指定されている.

```
# 場所
$ ./www/logs
```




