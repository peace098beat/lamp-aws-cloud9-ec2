#
#   _____  ____          _______  __ ____________
#   <  /  |/  (_)___     / ____/ |/ // ____/ ____/
#   / / /|_/ / / __ \   / __/  |   // __/ / /     
#  / / /  / / / / / /  / /___ /   |/ /___/ /___   
# /_/_/  /_/_/_/ /_/  /_____//_/|_/_____/\____/   
#                    
# [概要]
#   1分毎にCRONによって実行されるシェルスクリプト
#


#!/bin/sh
set -eu

# 現在時刻を表示
date

# 1分毎にINSERT
php /home/ec2-user/environment/www/public/test_mysql_insert.php