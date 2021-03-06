<?php
/******************************************************************************
       __            __                   __            __        
      / /____  _____/ /_   _      _____  / /_    ____  / /_  ____ 
     / __/ _ \/ ___/ __/  | | /| / / _ \/ __ \  / __ \/ __ \/ __ \
    / /_/  __(__  ) /_    | |/ |/ /  __/ /_/ / / /_/ / / / / /_/ /
    \__/\___/____/\__/____|__/|__/\___/_.___(_) .___/_/ /_/ .___/ 
                    /_____/                  /_/         /_/       
 * 
 * [概要]
 * 	Apacheにてweb画面を表示する
 * 
 * [ファイル名]
 *  test_web.php
 * 
 * [内容]
 *  PHP関数で現在日時を取得して表示する （PHPが動いていることを確認したいので） 	
 *   画面 ⇒ 「 現在の時刻は xx:xx:xx です」
 *   ※test_web.phpを開いた時の日時が表示されればいい。
 *   画面上でリアルタイムで日時が動く必要は無い
 * 
 * 
 * [参考]
 *   [PHPでPDOを使ってMySQLに接続 - Qiita]
 *   (https://qiita.com/tabo_purify/items/2575a58c54e43cd59630)
 * 
 * ***************************************************************************/
 
 
$now = date("Y/m/d H:i:s");

print_r("<h1>test_web.php</h1>");
print_r("<p>概要: Apacheにてweb画面を表示する</p>");
print_r("<p>現在の時刻は<b>".$now."</b>です</p>");

?>
