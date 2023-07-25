CREATE USER APLADMIN IDENTIFIED BY EqSnS2015;
CREATE USER TYSE_USER IDENTIFIED BY EqSnS2015;
GRANT ALL PRIVILEGES TO APLADMIN;
GRANT ALL PRIVILEGES TO TYSE_USER;
alter user tyse_user identified by EqSnS2015;


select * from dba_users where username = 'TYSE_USER';



sqlplus TYSE_USER/EqSnS2015@//172.17.0.1:1521/TYSE
docker cp /home/manuel/Documents/repo/tyse/Pruebas/PruebaBio/exp_infomin00.dmp oracle-19c-sd:/opt/oracle/admin/ORCLCDB/dpdump/014620083A9B0DD2E063020011ACD71F/


imp TYSE_USER/EqSnS2015@//172.17.0.1:1521/TYSE FULL=Y file=/opt/oracle/admin/ORCLCDB/dpdump/014620083A9B0DD2E063020011ACD71F/exp_infomin00.dmp