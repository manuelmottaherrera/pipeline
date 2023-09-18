CREATE USER APLADMIN IDENTIFIED BY EqSnS2015;
GRANT ALL PRIVILEGES TO APLADMIN;
DROP USER APLADMIN CASCADE;

CREATE USER TYSE_USER IDENTIFIED BY EqSnS2015;
GRANT ALL PRIVILEGES TO TYSE_USER;
GRANT DBA TO TYSE_USER;
GRANT DATAPUMP_IMP_FULL_DATABASE TO TYSE_USER;
sqlplus TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE

alter user tyse_user identified by EqSnS2015;

select * from dba_users where username = 'TYSE_USER';


podman exec -it oracle-19-3 sqlplus TYSE/EqSnS2015:@//127.0.0.1:1521/ORCLCDB
sqlplus TYSE_USER/EqSnS2015@//oracle-19-3:1521/TYSE
sqlplus TYSE_USER/EqSnS2015@//oracle-19-3-p:1521/TYSE
sqlplus $PIPELINE_USER_DB/$PIPELINE_PASS_DB@//$PIPELINE_IP_DB:$PIPELINE_PORT_DB/$PIPELINE_SCHEMA_DB
sqlplus system/EqSnS2015@//localhost:1521/XE
sqlplus SYS/EqSnS2015@//127.0.0.1:1521/TYSE as SYSDBA
;
SELECT DIRECTORY_NAME, DIRECTORY_PATH FROM DBA_DIRECTORIES WHERE DIRECTORY_NAME = 'DMP_INPUT';


sqlplus PDB_ADMIN/EqSnS2015@//127.0.0.1:1521/TYSE
docker cp /home/manuel/Documents/repo/tyse/Pruebas/PruebaBio/exp_infomin00.dmp oracle-19c-sd:/opt/oracle/admin/ORCLCDB/dpdump/014620083A9B0DD2E063020011ACD71F/

sqlplus -S TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE @/home/manuel/pipelineDirectory/sqlDirectory/generateExport.sql
/usr/lib/oracle/21/client64/bin/sqlplus -S TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE @/home/manuel/pipelineDirectory/sqlDirectory/generateExport.sql
sqlplus -S TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE @generateDbCenso.sql

imp APLADMIN/EqSnS2015@//127.0.0.1:1521/TYSE FULL=Y file=/opt/oracle/admin/ORCLCDB/dpdump/014620083A9B0DD2E063020011ACD71F/exp_infomin00.dmp
imp TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE FULL=Y file=/home/manuel/Documents/repo/tyse/Pruebas/PruebaBio/exp_infomin00.dmp
imp TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE file=/home/manuel/Documents/repo/tyse/Pruebas/PruebaBio/exp_infomin00.dmp fromuser=APLADMIN touser=TYSE_USER


expdp TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE tables=INFOMIN00 directory=/home/manuel/pipelineDirectory/sqlDirectory/ content=DATA_ONLY sqlfile=export.sql

exp TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE file=/home/manuel/pipelineDirectory/sqlDirectory/export.dmp tables=INFOMIN00 rows=y
imp TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE file=/home/manuel/pipelineDirectory/sqlDirectory/export.dmp fromuser=TYSE_USER touser=TYSE_USER show=y > /home/manuel/pipelineDirectory/sqlDirectory/export.sql
imp TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE file=/home/manuel/Documents/repo/tyse/Pruebas/PruebaBio/exp_infomin00.dmp fromuser=APLADMIN touser=TYSE_USER show=y > /home/manuel/pipelineDirectory/sqlDirectory/export.sql

sqlldr TYSE_USER/EqSnS2015@//127.0.0.1:1521/TYSE control=censo.ctl data=censo.txt
6017463478
+5715141546

sqlite3 APLADMIN.db
.read ./export.sql

WE8ISO8859P1