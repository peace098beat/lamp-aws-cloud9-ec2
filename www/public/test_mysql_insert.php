<?php
 /******************************************************************************
       __            __                                __   _                      __ 
      / /____  _____/ /_   ____ ___  __  ___________ _/ /  (_)___  ________  _____/ /_
     / __/ _ \/ ___/ __/  / __ `__ \/ / / / ___/ __ `/ /  / / __ \/ ___/ _ \/ ___/ __/
    / /_/  __(__  ) /_   / / / / / / /_/ (__  ) /_/ / /  / / / / (__  )  __/ /  / /_  
    \__/\___/____/\__/  /_/ /_/ /_/\__, /____/\__, /_/  /_/_/ /_/____/\___/_/   \__/  
                                  /____/        /_/                                   

 * 
 * [概要]
 *  MySQLのテストテーブル test_tblに1行INSERTする為のPHPファイルを作り実行すする
 * 
 * [ファイル名]
 *  test_mysql_insert.php
 * 
 * [MySQL テーブル]
 *  テーブル名: test_tbl
 *  カラム:
 *      id int AUTO INCREMENT
 *      date text(100)
 * 
 * [内容]
 *  mysqlに接続
 *  テーブルtest_tbl に 1行INSERTする
 *  ⇒INSERTする内容: 現在日時
 *  テーブルtest_tblの行数をcountする
 *  mysql切断
 *  画面に行数を表示する
 *  ⇒行数は x 行です
 *  ⇒「Mysqlへの接続」が目的なので、 MySQLへの接続パスワードとか、test_mysql_insert.phpにハードコートしてOK	
 * 
 * [参考]
 * [PHPでPDOを使ってMySQLに接続 - Qiita](https://qiita.com/tabo_purify/items/2575a58c54e43cd59630)
 * 
 * ***************************************************************************/


# ****************************************** #
# DBに接続
#  - host: localhost
#  - db: test_db
#  - table: test_tbl
#  - user: test_user
#  - pass: jogpass098
# ****************************************** #

try {
    $pdo = new PDO('mysql:host=localhost;dbname=test_db','test_user','jogpass098');
} catch (PDOException $e) {
    exit('データベース接続失敗。'.$e->getMessage());
}


# ****************************************** #
# INSERT
#  - 現在時刻を挿入
# ****************************************** #

$stmt = $pdo -> prepare("INSERT INTO test_db.test_tbl (date) VALUES (:date)");
$stmt -> bindParam(':date', $date, PDO::PARAM_STR);
$date = date("Y/m/d H:i:s");
$stmt -> execute();


# ****************************************** #
# COUNT
# 直近の SQLによって作用した行数を返す
# [PHP: PDOStatement::rowCount - Manual]
#  (http://php.net/manual/ja/pdostatement.rowcount.php)
# ****************************************** #

$sql = "SELECT COUNT(*) FROM test_db.test_tbl";
if ($res = $pdo->query($sql)) {
  $count = $res->fetchColumn(); # COUNT(*)の結果を取得
  echo "行数は".$count."です<br>".PHP_EOL;
}


# ****************************************** #
# SELECT
#  - 全行を取得
#  - 全行の数を取得
#  - 全行を表示
# ****************************************** #
# クエリ実行
$stmt = $pdo->query('SELECT * from test_db.test_tbl');

# 一行毎に表示 (方法1)
foreach($stmt as $row) {
    echo "".$row["id"]." : ".$row["date"]."<br>".PHP_EOL;
}

# 一行毎に表示 (方法2. おまけ)
$stmt = $pdo->query('SELECT * from test_db.test_tbl');
while($row = $stmt -> fetch(PDO::FETCH_ASSOC)) {
        // echo "".$row["id"]." : ".$row["date"].PHP_EOL;
}


# ****************************************** #
# 終了
# ****************************************** #
$pdo = null;

?>
