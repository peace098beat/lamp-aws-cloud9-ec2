
# AWS Cloud9のEC2直結環境に LAMP環境構築

AWS Cloud9にてEC2の新規作成をして直接SSHで入っている環境が数分で手に入る.
開発用に至急作業したいことがあるだろう。
しかし、そのままだと色々不便なので、事前セットアップスクリプトを準備した。

## 実行方法

```
$ sh ./setup-scripts/lamp-setup.sh

```

## CRONの設定方法

1. CRONファイルを変更
2. crondを再起動

 
```
$ sh ./setup-scripts/cron-setup.sh
```

Cronのシステムログの場所

```
# 場所
$ /var/log/cron
# ログの内容を確認する
$ tail -f /var/log/cron
```

CRONのユーザログの場所CRON

```
# 場所
$ ./www/logs
```




