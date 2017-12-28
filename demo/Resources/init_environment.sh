echo "1. remove all docker images"
docker rmi -f db-master db-slave db-slave-slave
docker rm -f db-master db-slave db-slave-slave
echo "2. run all docker"
docker build -t db-master docker/db-master
docker build -t db-slave docker/db-slave
docker build -t db-slave-slave docker/db-slave-slave
docker run -p 3306:3306  --name db-master -e MYSQL_ROOT_PASSWORD=1234 -d db-master
docker run -p 3307:3306 --name db-slave --link db-master:master -e MYSQL_ROOT_PASSWORD=1234 -d db-slave
docker run -p 3308:3306  --name db-slave-slave --link db-slave:slave -e MYSQL_ROOT_PASSWORD=1234 -d db-slave-slave
sleep 12;
echo "3. start db-master";
docker exec -it db-master bash -c "mysql -uroot -p1234 < temp/my.master.sql"
sleep 4;
echo "4. start db-slave";
docker exec -it db-slave bash -c "mysql -uroot -p1234 < temp/my.slave.sql"
sleep 4;
echo "5. start db-slave-slave";
docker exec -it db-slave-slave bash -c "mysql -uroot -p1234 < temp/my.slave-slave.sql"
sleep 2;
echo "6. start db-master init sql";
docker exec -it db-master bash -c "mysql -uroot -p1234 < temp/my.master.init_test.sql"
