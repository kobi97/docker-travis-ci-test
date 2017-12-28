#! /bin/bash
php tools/generate_test_sql.php > docker/db-master/sql/my.master.init_test.sql
./init_environment.sh
sleep 5
php ./test_result_validate.php
