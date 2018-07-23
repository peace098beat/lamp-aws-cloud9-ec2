<?php
 /******************************************************************************
       __            __      __  __    __         __        
      / /____  _____/ /_    / /_/ /_  / /  ____  / /_  ____ 
     / __/ _ \/ ___/ __/   / __/ __ \/ /  / __ \/ __ \/ __ \
    / /_/  __(__  ) /_    / /_/ /_/ / /_ / /_/ / / / / /_/ /
    \__/\___/____/\__/____\__/_.___/_/(_) .___/_/ /_/ .___/ 
                    /_____/            /_/         /_/      
 * 
 * test_tbl.php
 * 
 * 
 * [参考]
 * [PHPでPDOを使ってMySQLに接続 - Qiita](https://qiita.com/tabo_purify/items/2575a58c54e43cd59630)
 * 
 * ***************************************************************************/


# DBに接続
#  - host: localhost
#  - db: test_db
#  - table: test_tbl
#  - user: test_user
#  - pass: jogpass098

try {
    $pdo = new PDO('mysql:host=localhost;dbname=test_db','test_user','jogpass098');
} catch (PDOException $e) {
    exit('データベース接続失敗。'.$e->getMessage());
}


# INSERT
#  - 現在時刻を挿入

$date = date("Y/m/d H:i:s");
$stmt = $pdo -> prepare("INSERT INTO test_db.test_tbl (date) VALUES (:date)");
$stmt -> bindParam(':date', $date, PDO::PARAM_STR);
$stmt -> execute();


# SELECT
#  - 全行を取得
#  - 全行の数を取得
#  - 全行を表示

$stmt = $pdo->query('SELECT * from test_db.test_tbl');
$count = count($stmt); // 要素数をカウント

// 一行毎に表示
foreach($stmt as $row) {
    echo "".$row["id"]." : ".$row["date"].PHP_EOL;
}

// 一行毎に表示
$stmt = $pdo->query('SELECT * from test_db.test_tbl');
while($row = $stmt -> fetch(PDO::FETCH_ASSOC)) {
        echo "".$row["id"]." : ".$row["date"].PHP_EOL;
}


# 終了

$pdo = null;

?>


