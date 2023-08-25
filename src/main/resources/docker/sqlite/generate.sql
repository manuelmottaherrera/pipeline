SET SERVEROUTPUT ON
SET VERIFY OFF
SET HEADING OFF
SET ECHO OFF
SET FEEDBACK OFF
SET LONG 32767
SET LINESIZE 1000


SPOOL generateAllSql.sql
DECLARE
    v_departamento VARCHAR2(2);
    v_municipio VARCHAR2(3);
    v_zona VARCHAR(2);
    v_puesto VARCHAR(2);
    v_file_name VARCHAR2(17);
    v_divimovil CLOB := NULL;
    v_divicons NUMBER := 0;
    v_total_cedulas NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('SET SERVEROUTPUT ON');
    DBMS_OUTPUT.PUT_LINE('SET VERIFY OFF');
    DBMS_OUTPUT.PUT_LINE('SET HEADING OFF');
    DBMS_OUTPUT.PUT_LINE('SET ECHO OFF');
    DBMS_OUTPUT.PUT_LINE('SET LONG 32767');
    DBMS_OUTPUT.PUT_LINE('SET FEEDBACK OFF');
    FOR D IN (select DISTINCT DEPARTAMENTO, DEPARTAMENTO_NOMBRE from CENSO ORDER BY DEPARTAMENTO) LOOP
        v_departamento := LPAD(D.DEPARTAMENTO, 2, '0');
        v_divicons := v_divicons + 1;
        v_divimovil := NVL(v_divimovil, '') || 'v_stmt := LPAD(' || v_divicons|| ', 6, ''0'') || RPAD(' || D.DEPARTAMENTO || ', 3, CHR(32)) || RPAD(''-1'', 3, CHR(32))  || RPAD(''-1'', 2, CHR(32))  || RPAD(''-1'', 2, CHR(32)) || RPAD(''' || D.DEPARTAMENTO_NOMBRE || ''', 50, CHR(32)) || LPAD(''-1'', 6, CHR(32));' || CHR(10) || 'DBMS_OUTPUT.PUT_LINE(v_stmt);' || CHR(10);
        FOR M IN (SELECT DISTINCT MUNICIPIO, MUNICIPIO_NOMBRE FROM CENSO WHERE DEPARTAMENTO=D.DEPARTAMENTO ORDER BY MUNICIPIO) LOOP
            v_municipio := LPAD(M.MUNICIPIO, 3, '0');
            v_divicons := v_divicons + 1;
            v_divimovil := v_divimovil || 'v_stmt := LPAD(' || v_divicons|| ', 6, ''0'') || RPAD(' || D.DEPARTAMENTO || ', 3, CHR(32)) || RPAD(' || M.MUNICIPIO || ', 3, CHR(32))  || RPAD(''-1'', 2, CHR(32))  || RPAD(''-1'', 2, CHR(32)) || RPAD(''' || M.MUNICIPIO_NOMBRE || ''', 50, CHR(32)) || LPAD(''-1'', 6, CHR(32));' || CHR(10) || 'DBMS_OUTPUT.PUT_LINE(v_stmt);' || CHR(10);
            v_file_name := 'db/' || v_departamento || v_municipio || 'c.sql';
            DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
            DBMS_OUTPUT.PUT_LINE('DECLARE');
            DBMS_OUTPUT.PUT_LINE('v_stmt CLOB;');
            DBMS_OUTPUT.PUT_LINE('BEGIN');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE divipol (dipocons INT,dpto INT NOT NULL DEFAULT -1,mcpio INT NOT NULL DEFAULT -1,zona INT NOT NULL DEFAULT -1, puesto VARCHAR(2) NOT NULL DEFAULT ''''-1'''', tot_cc INT NOT NULL DEFAULT -1, descripcion VARCHAR (200), direccion VARCHAR (200), PRIMARY KEY (dipocons));'');');
            DBMS_OUTPUT.PUT_LINE('FOR C IN (SELECT DIPOCONS, DEPARTAMENTO AS dpto, MUNICIPIO AS mcpio, ZONA AS zona, PUESTO as puesto, NULL AS tot_cc, DESCRIPCION AS descripcion, DIRECCION as direccion FROM DIVIPOL WHERE DEPARTAMENTO=' || D.DEPARTAMENTO || ' AND MUNICIPIO=' || M.MUNICIPIO ||') LOOP');
            DBMS_OUTPUT.PUT_LINE('v_stmt := ''INSERT INTO divipol (dipocons, dpto, mcpio, zona, puesto, tot_cc, descripcion, direccion) VALUES (''  || c.DIPOCONS || '', '' || c.dpto || '', '' || c.mcpio || '', '' || c.zona || '', '''''' || LPAD(c.puesto, 2, ''0'') || '''''', ''''-1'''', '''''' || REPLACE(c.descripcion, '''''''', '''''''''''') || '''''', '''''' || REPLACE(c.direccion, '''''''', '''''''''''') || '''''');'';');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
            DBMS_OUTPUT.PUT_LINE('END LOOP;');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE censo (dipocons_puesto INT NOT NULL,mesa INT NOT NULL,cedula BIGINT NOT NULL,pri_nombre VARCHAR (60) NOT NULL,seg_nombre VARCHAR(60),pri_apellido VARCHAR(60) NOT NULL,seg_apellido VARCHAR(60),genero VARCHAR(12),fech_exp VARCHAR(60),PRIMARY KEY (cedula),CONSTRAINT fk_censo_divipol FOREIGN KEY (dipocons_puesto)REFERENCES divipol (dipocons));'');');
            DBMS_OUTPUT.PUT_LINE('FOR C IN (SELECT DISTINCT D.DIPOCONS AS dipocons_puesto, C.MESA as mesa, C.CEDULA, C.PRIMER_NOMBRE AS PRI_NOMBRE, C.SEGUNDO_NOMBRE AS SEG_NOMBRE, C.PRIMER_APELLIDO AS PRI_APELLIDO, C.SEGUNDO_APELLIDO AS SEG_APELLIDO, CASE GENERO WHEN 1 THEN ''M'' WHEN 2 THEN ''F'' ELSE ''OTRO'' END AS GENERO, FECHA_EXPEDICION AS FECH_EXP FROM CENSO C INNER JOIN DIVIPOL D ON C.DEPARTAMENTO = D.DEPARTAMENTO AND C.MUNICIPIO = D.MUNICIPIO AND C.ZONA = D.ZONA AND C.PUESTO = D.PUESTO WHERE D.DEPARTAMENTO=' || D.DEPARTAMENTO || ' AND D.MUNICIPIO=' || M.MUNICIPIO || ' ORDER BY dipocons_puesto) LOOP');
            DBMS_OUTPUT.PUT_LINE('v_stmt := ''INSERT INTO censo (dipocons_puesto, mesa, cedula, pri_nombre, seg_nombre, pri_apellido, seg_apellido, genero, fech_exp) VALUES (''  || c.dipocons_puesto || '', '' 
            || c.mesa || '', '' 
            || c.cedula || '', '''''' 
            || REPLACE(c.pri_nombre, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.seg_nombre, '''''''', '''''''''''') || '''''', ''''''
            || REPLACE(c.pri_apellido, '''''''', '''''''''''') || '''''', ''''''
            || REPLACE(c.seg_apellido, '''''''', '''''''''''') || '''''', '''''' 
            || c.genero || '''''', ''''''
            || c.fech_exp || '''''');'';');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
            DBMS_OUTPUT.PUT_LINE('END LOOP;');
            DBMS_OUTPUT.PUT_LINE('END;');
            DBMS_OUTPUT.PUT_LINE('/');
            DBMS_OUTPUT.PUT_LINE('SPOOL OFF');
            v_file_name := 'db/' || v_departamento || v_municipio || 'hj.sql';
            DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
            DBMS_OUTPUT.PUT_LINE('DECLARE');
            DBMS_OUTPUT.PUT_LINE('v_stmt CLOB;');
            DBMS_OUTPUT.PUT_LINE('BEGIN');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE INFOMIN00 (PIN BIGINT NOT NULL, pri_nombre VARCHAR(60) NOT NULL, seg_nombre VARCHAR(60), pri_apellido VARCHAR(60) NOT NULL, seg_apellido VARCHAR(60), genero VARCHAR(12), fech_exp VARCHAR(60),dipocons_puesto INT, mesa INT, PK31 BLOB, PK32 BLOB, PK33 BLOB, PK34 BLOB, PK35 BLOB, PK36 BLOB, PK37 BLOB, PK38 BLOB, PK39 BLOB, PK40 BLOB, PK291 BLOB, CONSTRAINT INFOMIN00_IDX1 PRIMARY KEY (PIN));'');');
            DBMS_OUTPUT.PUT_LINE('FOR c IN (SELECT I.PIN, J.NOMBRES AS PRI_NOMBRE, NULL AS SEG_NOMBRE, J.APELLIDOS AS PRI_APELLIDO, NULL AS SEG_APELLIDO, CASE C.GENERO WHEN 1 THEN ''M'' WHEN 2 THEN ''F'' ELSE ''OTRO'' END AS GENERO, C.FECHA_EXPEDICION AS FECH_EXP,
            D.DIPOCONS AS DIPOCONS_PUESTO, C.MESA, I.PK31, I.PK32, I.PK33, I.PK34, I.PK35, I.PK36, I.PK37, I.PK38, I.PK39, I.PK40, I.PK291
            FROM INFOMIN00 I 
            JOIN JURADOS J ON  I.PIN=J.CEDULA 
            JOIN CENSO C ON J.CEDULA = C.CEDULA
            JOIN DIVIPOL D ON C.DEPARTAMENTO = D.DEPARTAMENTO AND C.MUNICIPIO = D.MUNICIPIO AND C.ZONA = D.ZONA AND C.PUESTO = D.PUESTO
            WHERE C.DEPARTAMENTO=' || D.DEPARTAMENTO || ' AND C.MUNICIPIO=' || M.MUNICIPIO || ') LOOP');
            DBMS_OUTPUT.PUT_LINE('v_stmt := ''INSERT INTO INFOMIN00 (PIN, PRI_NOMBRE, SEG_NOMBRE, PRI_APELLIDO, SEG_APELLIDO, GENERO, FECH_EXP, DIPOCONS_PUESTO, MESA, PK31, PK32, PK33, PK34, PK35, PK36, PK37, PK38, PK39, PK40, PK291) VALUES (''
            || c.PIN || '', '''''' 
            || c.PRI_NOMBRE || '''''', '''''' 
            || c.SEG_NOMBRE || '''''', '''''' 
            || c.PRI_APELLIDO || '''''', '''''' 
            || c.SEG_APELLIDO || '''''', '''''' 
            || c.GENERO || '''''', '''''' 
            || c.FECH_EXP || '''''', ''
            || c.DIPOCONS_PUESTO || '', '' 
            || c.MESA || '', '''''' 
            || REPLACE(c.PK31, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK32, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK33, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK34, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK35, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK36, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK37, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK38, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK39, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK40, '''''''', '''''''''''') || '''''', '''''' 
            || REPLACE(c.PK291, '''''''', '''''''''''') || '''''');'';');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
            DBMS_OUTPUT.PUT_LINE('END LOOP;');
            DBMS_OUTPUT.PUT_LINE('END;');
            DBMS_OUTPUT.PUT_LINE('/');
            DBMS_OUTPUT.PUT_LINE('SPOOL OFF');
            FOR Z IN (SELECT DISTINCT ZONA FROM CENSO WHERE DEPARTAMENTO = D.DEPARTAMENTO AND MUNICIPIO = M.MUNICIPIO ORDER BY ZONA) LOOP
                v_zona := LPAD(Z.ZONA, 2, '0');
                v_divicons := v_divicons + 1;
                v_divimovil := v_divimovil || 'v_stmt := LPAD(' || v_divicons|| ', 6, ''0'') || RPAD(' || D.DEPARTAMENTO || ', 3, CHR(32)) || RPAD(' || M.MUNICIPIO || ', 3, CHR(32))  || RPAD(' || Z.ZONA ||', 2, CHR(32))  || RPAD(''-1'', 2, CHR(32)) || RPAD(''ZONA ' || v_zona || ''', 50, CHR(32)) || LPAD(''-1'', 6, CHR(32));' || CHR(10) || 'DBMS_OUTPUT.PUT_LINE(v_stmt);' || CHR(10);
                FOR P IN (SELECT DISTINCT PUESTO, PUESTO_DESCRIPCION FROM CENSO WHERE DEPARTAMENTO = D.DEPARTAMENTO AND MUNICIPIO = M.MUNICIPIO AND ZONA = Z.ZONA ORDER BY PUESTO) LOOP
                    v_puesto := LPAD(P.PUESTO, 2, '0');
                    v_divicons := v_divicons + 1;
                    SELECT COUNT(CEDULA) INTO v_total_cedulas FROM CENSO WHERE DEPARTAMENTO = D.DEPARTAMENTO AND MUNICIPIO = M.MUNICIPIO AND ZONA = Z.ZONA AND PUESTO = P.PUESTO;
                    v_divimovil := v_divimovil || 'v_stmt := LPAD(' || v_divicons|| ', 6, ''0'') || RPAD(' || D.DEPARTAMENTO || ', 3, CHR(32)) || RPAD(' || M.MUNICIPIO || ', 3, CHR(32))  || RPAD(' || Z.ZONA ||', 2, CHR(32))  || RPAD(' || P.PUESTO ||', 2, CHR(32)) || RPAD(''' || P.PUESTO_DESCRIPCION || ''', 50, CHR(32)) || LPAD(''' || v_total_cedulas || ''', 6, ''0'');' || CHR(10) || 'DBMS_OUTPUT.PUT_LINE(v_stmt);' || CHR(10);
                    v_file_name := 'db/' || v_departamento || v_municipio || v_zona || v_puesto || 'h.sql';
                    DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
                    DBMS_OUTPUT.PUT_LINE('DECLARE');
                    DBMS_OUTPUT.PUT_LINE('v_stmt CLOB;');
                    DBMS_OUTPUT.PUT_LINE('BEGIN');
                    DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE INFOMIN00 (PIN BIGINT NOT NULL, PK31 BLOB, PK32 BLOB, PK33 BLOB, PK34 BLOB, PK35 BLOB, PK36 BLOB, PK37 BLOB, PK38 BLOB, PK39 BLOB, PK40 BLOB, PK291 BLOB, CONSTRAINT INFOMIN00_IDX1 PRIMARY KEY (PIN));'');');
                    DBMS_OUTPUT.PUT_LINE('FOR c IN (SELECT PIN, PK31, PK32, PK33, PK34, PK35, PK36, PK37, PK38, PK39, PK40, PK291 FROM INFOMIN00 I JOIN CENSO C ON I.PIN = C.CEDULA WHERE C.DEPARTAMENTO = ' || D.DEPARTAMENTO || ' AND MUNICIPIO = ' || M.MUNICIPIO || ' AND ZONA = ' || Z.ZONA || ' AND PUESTO = ' || P.PUESTO ||') LOOP');
                    DBMS_OUTPUT.PUT_LINE('v_stmt := ''INSERT INTO INFOMIN00 (PIN, PK31, PK32, PK33, PK34, PK35, PK36, PK37, PK38, PK39, PK40, PK291) VALUES (''
                    || c.PIN || '', ''''''
                    || REPLACE(c.PK31, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK32, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK33, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK34, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK35, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK36, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK37, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK38, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK39, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK40, '''''''', '''''''''''') || '''''', ''''''
                    || REPLACE(c.PK291, '''''''', '''''''''''') || '''''');'';');
                    DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
                    DBMS_OUTPUT.PUT_LINE('END LOOP;');
                    DBMS_OUTPUT.PUT_LINE('END;');
                    DBMS_OUTPUT.PUT_LINE('/');
                    DBMS_OUTPUT.PUT_LINE('SPOOL OFF');
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
    v_file_name := 'db/' || 'divimovil.txt';
    DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
    DBMS_OUTPUT.PUT_LINE('DECLARE');
    DBMS_OUTPUT.PUT_LINE('v_stmt CLOB;');
    DBMS_OUTPUT.PUT_LINE('BEGIN');
    DBMS_OUTPUT.PUT_LINE(v_divimovil);
    DBMS_OUTPUT.PUT_LINE('END;');
    DBMS_OUTPUT.PUT_LINE('/');
    DBMS_OUTPUT.PUT_LINE('SPOOL OFF');
    DBMS_OUTPUT.PUT_LINE('EXIT');
END;
/
SPOOL OFF
EXIT