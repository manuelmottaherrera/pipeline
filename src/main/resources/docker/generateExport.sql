SET SERVEROUTPUT ON
SET VERIFY OFF
SET HEADING OFF
SET ECHO OFF

SPOOL exportToSqlite.sql

DECLARE
   v_stmt CLOB;
BEGIN
   FOR c IN (SELECT PIN, PK31, PK32, PK33, PK34, PK35, PK36, PK37, PK38, PK39, PK40, PK291 FROM INFOMIN00) LOOP
      v_stmt := 'INSERT INTO INFOMIN00 (PIN, PK31, PK32, PK33, PK34, PK35, PK36, PK37, PK38, PK39, PK40, PK291) VALUES (' || CHR(10) ||
        '''' || c.PIN || ''', ' || CHR(10) ||
        '''' || c.PK31 || ''', ' || CHR(10) ||
        '''' || c.PK32 || ''', ' || CHR(10) ||
        '''' || c.PK33 || ''', ' || CHR(10) ||
        '''' || c.PK34 || ''', ' || CHR(10) ||
        '''' || c.PK35 || ''', ' || CHR(10) ||
        '''' || c.PK36 || ''', ' || CHR(10) ||
        '''' || c.PK37 || ''', ' || CHR(10) ||
        '''' || c.PK38 || ''', ' || CHR(10) ||
        '''' || c.PK39 || ''', ' || CHR(10) ||
        '''' || c.PK40 || ''', ' || CHR(10) ||
        '''' || c.PK291 || ''');';
      DBMS_OUTPUT.PUT_LINE(v_stmt);
   END LOOP;
END;
/

SPOOL OFF
EXIT

