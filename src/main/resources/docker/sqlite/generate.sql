-- Encoding: ISO-8859-1
SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET HEADING OFF;
SET ECHO OFF;
SET FEEDBACK OFF;
SET LONG 32767;
SET LINESIZE 32767;
SET TRIMSPOOL ON;


CREATE OR REPLACE FUNCTION OFUSCAR_CEDULA (CEDULA IN NUMBER) RETURN NUMBER IS
    CEDULA_OFUSCADA NUMBER;
BEGIN
    CEDULA_OFUSCADA := (CEDULA * 1024) + 698;
    
    RETURN CEDULA_OFUSCADA;
END OFUSCAR_CEDULA;
/
CREATE OR REPLACE FUNCTION encriptar(p_input VARCHAR2) RETURN VARCHAR2 IS
    v_encrypted VARCHAR2(32767); -- Tamaño máximo para VARCHAR2 en PL/SQL
    v_char CHAR(1);
    TYPE t_char_map IS TABLE OF CHAR INDEX BY PLS_INTEGER;
    v_ori t_char_map;
    v_sin t_char_map;
    v_index PLS_INTEGER;
BEGIN
    -- Inicializar arrays
    IF p_input IS NULL THEN
        RETURN NULL;
    END IF;

    v_ori(1) := 'A'; v_sin(1) := 'R';
    v_ori(2) := 'B'; v_sin(2) := 'H';
    v_ori(3) := 'C'; v_sin(3) := 'Ñ';
    v_ori(4) := 'D'; v_sin(4) := 'A';
    v_ori(5) := 'E'; v_sin(5) := 'S';
    v_ori(6) := 'F'; v_sin(6) := 'W';
    v_ori(7) := 'G'; v_sin(7) := 'M';
    v_ori(8) := 'H'; v_sin(8) := 'B';
    v_ori(9) := 'I'; v_sin(9) := 'U';
    v_ori(10) := 'J'; v_sin(10) := 'Z';
    v_ori(11) := 'K'; v_sin(11) := 'T';
    v_ori(12) := 'L'; v_sin(12) := 'L';
    v_ori(13) := 'M'; v_sin(13) := 'G';
    v_ori(14) := 'N'; v_sin(14) := 'V';
    v_ori(15) := 'Ñ'; v_sin(15) := 'X';
    v_ori(16) := 'O'; v_sin(16) := 'Y';
    v_ori(17) := 'P'; v_sin(17) := 'N';
    v_ori(18) := 'Q'; v_sin(18) := 'I';
    v_ori(19) := 'R'; v_sin(19) := 'D';
    v_ori(20) := 'S'; v_sin(20) := 'E';
    v_ori(21) := 'T'; v_sin(21) := 'K';
    v_ori(22) := 'U'; v_sin(22) := 'Q';
    v_ori(23) := 'V'; v_sin(23) := 'C';
    v_ori(24) := 'W'; v_sin(24) := 'F';
    v_ori(25) := 'X'; v_sin(25) := 'O';
    v_ori(26) := 'Y'; v_sin(26) := 'P';
    v_ori(27) := 'Z'; v_sin(27) := 'J';

    FOR i IN 1..LENGTH(p_input) LOOP
        v_char := SUBSTR(p_input, i, 1);
        v_index := NULL;
        
        FOR j IN 1..27 LOOP
            IF v_char = v_ori(j) THEN
                v_index := j;
                EXIT;
            END IF;
        END LOOP;
        
        IF v_index IS NOT NULL THEN
            v_encrypted := v_encrypted || v_sin(v_index);
        ELSE
            v_encrypted := v_encrypted || v_char;
        END IF;
    END LOOP;

    RETURN v_encrypted;
END encriptar;
/



SPOOL generateAllSql.sql
DECLARE
    v_departamento VARCHAR2(2);
    v_municipio VARCHAR2(3);
    v_zona VARCHAR(2);
    v_puesto VARCHAR(2);
    v_file_name VARCHAR2(30);
    v_total_cedulas NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('SET SERVEROUTPUT ON;');
    DBMS_OUTPUT.PUT_LINE('SET VERIFY OFF;');
    DBMS_OUTPUT.PUT_LINE('SET HEADING OFF;');
    DBMS_OUTPUT.PUT_LINE('SET ECHO OFF;');
    DBMS_OUTPUT.PUT_LINE('SET LONG 32767;');
    DBMS_OUTPUT.PUT_LINE('SET LINESIZE 32767;');
    DBMS_OUTPUT.PUT_LINE('SET FEEDBACK OFF;');
    DBMS_OUTPUT.PUT_LINE('SET TRIMSPOOL ON;');
    FOR D IN (select DISTINCT DEPARTAMENTO, DEPARTAMENTO_DESCRIPCION from DIVIPOL ORDER BY DEPARTAMENTO) LOOP
        v_departamento := LPAD(D.DEPARTAMENTO, 2, '0');
        --DIVIMOVIL DPTO
        INSERT INTO DIVIMOVIL (  DEPARTAMENTO,                DESCRIPCION) 
                       VALUES (D.DEPARTAMENTO, D.DEPARTAMENTO_DESCRIPCION);
        COMMIT;
        FOR M IN (SELECT DISTINCT MUNICIPIO, MUNICIPIO_DESCRIPCION FROM DIVIPOL WHERE DEPARTAMENTO=D.DEPARTAMENTO ORDER BY MUNICIPIO) LOOP
            v_municipio := LPAD(M.MUNICIPIO, 3, '0');
            --DIVIMOVIL MCPIO
            INSERT INTO DIVIMOVIL ( DEPARTAMENTO,   MUNICIPIO,        DESCRIPCION)
                        VALUES   (D.DEPARTAMENTO, M.MUNICIPIO, M.MUNICIPIO_DESCRIPCION);
            COMMIT;
            
            v_file_name := 'db/' || v_departamento || v_municipio || 'hj.sql';
            DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
            DBMS_OUTPUT.PUT_LINE('DECLARE');
            DBMS_OUTPUT.PUT_LINE('v_stmt CLOB;');
            DBMS_OUTPUT.PUT_LINE('BEGIN');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE INFOMIN00 (PIN BIGINT NOT NULL, pri_nombre VARCHAR(60) NOT NULL, seg_nombre VARCHAR(60), pri_apellido VARCHAR(60) NOT NULL, seg_apellido VARCHAR(60), genero VARCHAR(12), fech_exp VARCHAR(60),dipocons_puesto INT, mesa INT, PK31 BLOB, PK32 BLOB, PK33 BLOB, PK34 BLOB, PK35 BLOB, PK36 BLOB, PK37 BLOB, PK38 BLOB, PK39 BLOB, PK40 BLOB, PK291 BLOB, CONSTRAINT INFOMIN00_IDX1 PRIMARY KEY (PIN));'');');
            DBMS_OUTPUT.PUT_LINE('FOR c IN (
SELECT 
    OFUSCAR_CEDULA(J.CEDULA) AS PIN, 
    ENCRIPTAR(C.PRIMER_NOMBRE) AS PRI_NOMBRE, 
    ENCRIPTAR(C.SEGUNDO_NOMBRE) AS SEG_NOMBRE, 
    ENCRIPTAR(C.PRIMER_APELLIDO) AS PRI_APELLIDO, 
    ENCRIPTAR(C.SEGUNDO_APELLIDO) AS SEG_APELLIDO, 
    CASE C.GENERO 
        WHEN 1 THEN ''M'' 
        WHEN 2 THEN ''F'' 
        ELSE ''OTRO'' 
    END AS GENERO, 
    C.FECHA_EXPEDICION AS FECH_EXP,
    D.DIPOCONS AS DIPOCONS_PUESTO, 
    C.MESA AS MESA, 
    I.PK31 AS PK31, 
    I.PK32 AS PK32, 
    I.PK33 AS PK33, 
    I.PK34 AS PK34, 
    I.PK35 AS PK35, 
    I.PK36 AS PK36, 
    I.PK37 AS PK37, 
    I.PK38 AS PK38, 
    I.PK39 AS PK39, 
    I.PK40 AS PK40, 
    I.PK291 AS PK291
FROM INFOMIN00 I 
    JOIN JURADOS J 
        ON  TO_NUMBER(I.PIN)=J.CEDULA 
    JOIN CENSO C 
        ON J.CEDULA = C.CEDULA
    JOIN DIVIMOVIL D 
        ON C.DEPARTAMENTO = D.DEPARTAMENTO AND 
        C.MUNICIPIO = D.MUNICIPIO AND 
        C.ZONA = D.ZONA AND 
        C.PUESTO = D.PUESTO
WHERE 
    C.DEPARTAMENTO=' || D.DEPARTAMENTO || ' AND 
    C.MUNICIPIO=' || M.MUNICIPIO || '
ORDER BY D.DIPOCONS) LOOP');
            DBMS_OUTPUT.PUT_LINE('v_stmt := ''INSERT INTO INFOMIN00 (PIN, PRI_NOMBRE, SEG_NOMBRE, PRI_APELLIDO, SEG_APELLIDO, GENERO, FECH_EXP, DIPOCONS_PUESTO, MESA, PK31, PK32, PK33, PK34, PK35, PK36, PK37, PK38, PK39, PK40, PK291) VALUES ('' || c.PIN || '', '''''' || c.PRI_NOMBRE || '''''', '''''' || c.SEG_NOMBRE || '''''', '''''' || c.PRI_APELLIDO || '''''', '''''' || c.SEG_APELLIDO || '''''', '''''' || c.GENERO || '''''', '''''' || c.FECH_EXP || '''''', ''|| c.DIPOCONS_PUESTO || '', '' || c.MESA || '', '' || CHR(10) ||  '''''''' || REPLACE(c.PK31, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK32, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK33, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK34, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK35, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK36, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK37, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK38, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK39, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK40, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  '''''''' || REPLACE(c.PK291, '''''''', '''''''''''') || '''''');'';');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
            DBMS_OUTPUT.PUT_LINE('END LOOP;');
            DBMS_OUTPUT.PUT_LINE('END;');
            DBMS_OUTPUT.PUT_LINE('/');
            DBMS_OUTPUT.PUT_LINE('SPOOL OFF;');
            FOR Z IN (SELECT DISTINCT ZONA FROM DIVIPOL WHERE DEPARTAMENTO = D.DEPARTAMENTO AND MUNICIPIO = M.MUNICIPIO ORDER BY ZONA) LOOP
                v_zona := LPAD(Z.ZONA, 2, '0');
                --DIVIMOVIL ZONA
                INSERT INTO DIVIMOVIL ( DEPARTAMENTO,   MUNICIPIO,   ZONA,       DESCRIPCION)
                            VALUES   (D.DEPARTAMENTO, M.MUNICIPIO, Z.ZONA, 'ZONA ' || v_zona);
                COMMIT;
                FOR P IN (SELECT DISTINCT PUESTO, PUESTO_DESCRIPCION FROM DIVIPOL WHERE DEPARTAMENTO = D.DEPARTAMENTO AND MUNICIPIO = M.MUNICIPIO AND ZONA = Z.ZONA ORDER BY PUESTO) LOOP
                    v_puesto := LPAD(P.PUESTO, 2, '0');
                    SELECT COUNT(CEDULA) INTO v_total_cedulas FROM CENSO WHERE DEPARTAMENTO = D.DEPARTAMENTO AND MUNICIPIO = M.MUNICIPIO AND ZONA = Z.ZONA AND PUESTO = P.PUESTO;
                    --DIVIMOVIL PUESTO
                    INSERT INTO DIVIMOVIL ( DEPARTAMENTO,   MUNICIPIO,   ZONA,                                                                                   PUESTO,          DESCRIPCION,          TOT_CC)
                                VALUES   (D.DEPARTAMENTO, M.MUNICIPIO, Z.ZONA, CASE WHEN REGEXP_LIKE(P.PUESTO, '^[0-9]$') THEN P.PUESTO ELSE LPAD(P.PUESTO, 2, '0') END, P.PUESTO_DESCRIPCION, v_total_cedulas);
                    COMMIT;
                    v_file_name := 'db/' || v_departamento || v_municipio || v_zona || v_puesto || 'h.sql';
                    DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
                    DBMS_OUTPUT.PUT_LINE('DECLARE');
                    DBMS_OUTPUT.PUT_LINE('v_stmt CLOB;');
                    DBMS_OUTPUT.PUT_LINE('BEGIN');
                    DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE INFOMIN00 (PIN BIGINT NOT NULL, PK31 BLOB, PK32 BLOB, PK33 BLOB, PK34 BLOB, PK35 BLOB, PK36 BLOB, PK37 BLOB, PK38 BLOB, PK39 BLOB, PK40 BLOB, PK291 BLOB, CONSTRAINT INFOMIN00_IDX1 PRIMARY KEY (PIN));'');');
                    DBMS_OUTPUT.PUT_LINE('FOR c IN (SELECT OFUSCAR_CEDULA(C.CEDULA) AS PIN, PK31 AS PK31, PK32 AS PK32, PK33 AS PK33, PK34 AS PK34, PK35 AS PK35, PK36 AS PK36, PK37 AS PK37, PK38 AS PK38, PK39 AS PK39, PK40 AS PK40, PK291 AS PK291 FROM INFOMIN00 I JOIN CENSO C ON I.PIN = LPAD(TO_CHAR(C.CEDULA), 10, ''0'') WHERE C.DEPARTAMENTO = ' || D.DEPARTAMENTO || ' AND MUNICIPIO = ' || M.MUNICIPIO || ' AND ZONA = ' || Z.ZONA || ' AND PUESTO = ''' || P.PUESTO ||''') LOOP');
                    DBMS_OUTPUT.PUT_LINE('v_stmt := ''INSERT INTO INFOMIN00 (PIN, PK31, PK32, PK33, PK34, PK35, PK36, PK37, PK38, PK39, PK40, PK291) VALUES (''
                    || c.PIN || '', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK31, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK32, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK33, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK34, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK35, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK36, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK37, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK38, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK39, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK40, '''''''', '''''''''''') || '''''', '' || CHR(10) ||  ''''''''
                    || REPLACE(c.PK291, '''''''', '''''''''''') || '''''');'';');
                    DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
                    DBMS_OUTPUT.PUT_LINE('END LOOP;');
                    DBMS_OUTPUT.PUT_LINE('END;');
                    DBMS_OUTPUT.PUT_LINE('/');
                    DBMS_OUTPUT.PUT_LINE('SPOOL OFF;');
                END LOOP;
            END LOOP;
            v_file_name := 'db/' || v_departamento || v_municipio || 'c.sql';
            DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
            DBMS_OUTPUT.PUT_LINE('DECLARE');
            DBMS_OUTPUT.PUT_LINE('BEGIN');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE divipol (dipocons INT,dpto INT NOT NULL DEFAULT -1,mcpio INT NOT NULL DEFAULT -1,zona INT NOT NULL DEFAULT -1, puesto VARCHAR(2) NOT NULL DEFAULT ''''-1'''', tot_cc INT NOT NULL DEFAULT -1, descripcion VARCHAR (200), direccion VARCHAR (200), PRIMARY KEY (dipocons));'');');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE censo (dipocons_puesto INT NOT NULL,mesa INT NOT NULL,cedula BIGINT NOT NULL,pri_nombre VARCHAR (60) NOT NULL,seg_nombre VARCHAR(60),pri_apellido VARCHAR(60) NOT NULL,seg_apellido VARCHAR(60),genero VARCHAR(12),fech_exp VARCHAR(60),PRIMARY KEY (cedula),CONSTRAINT fk_censo_divipol FOREIGN KEY (dipocons_puesto)REFERENCES divipol (dipocons));'');');
            DBMS_OUTPUT.PUT_LINE('END;');
            DBMS_OUTPUT.PUT_LINE('/');
            DBMS_OUTPUT.PUT_LINE('SPOOL OFF;');
            
            
            v_file_name := 'db/' || v_departamento || v_municipio || 'c_divipol.csv';
            DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
            DBMS_OUTPUT.PUT_LINE('DECLARE');
            DBMS_OUTPUT.PUT_LINE('v_stmt CLOB;');
            DBMS_OUTPUT.PUT_LINE('BEGIN');
            DBMS_OUTPUT.PUT_LINE('FOR C IN (SELECT DM.DIPOCONS AS DIPOCONS, D.DEPARTAMENTO AS dpto, D.MUNICIPIO AS mcpio, D.ZONA AS zona, D.PUESTO as puesto, DM.TOT_CC AS tot_cc, DM.DESCRIPCION AS descripcion, D.PUESTO_DESCRIPCION as direccion FROM DIVIPOL D JOIN DIVIMOVIL DM ON D.DEPARTAMENTO=DM.DEPARTAMENTO AND D.MUNICIPIO=DM.MUNICIPIO AND D.ZONA=DM.ZONA AND D.PUESTO=DM.PUESTO WHERE D.DEPARTAMENTO=' || D.DEPARTAMENTO || ' AND D.MUNICIPIO=' || M.MUNICIPIO ||') LOOP');
            DBMS_OUTPUT.PUT_LINE('v_stmt := c.DIPOCONS || '','' || c.dpto || '','' || c.mcpio || '','' || c.zona || '','' || LPAD(c.puesto, 2, ''0'') || '','' || c.tot_cc || '','' || REPLACE(c.descripcion, '''''''', '''''''''''') || '','' || REPLACE(c.direccion, '''''''', '''''''''''');');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
            DBMS_OUTPUT.PUT_LINE('END LOOP;');
            DBMS_OUTPUT.PUT_LINE('END;');
            DBMS_OUTPUT.PUT_LINE('/');
            DBMS_OUTPUT.PUT_LINE('SPOOL OFF;');
            v_file_name := 'db/' || v_departamento || v_municipio || 'c_censo.csv';
            DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
            DBMS_OUTPUT.PUT_LINE('DECLARE');
            DBMS_OUTPUT.PUT_LINE('v_stmt CLOB;');
            DBMS_OUTPUT.PUT_LINE('BEGIN');
            DBMS_OUTPUT.PUT_LINE('FOR c IN (SELECT 
    DISTINCT DM.DIPOCONS AS dipocons_puesto, 
    C.MESA as mesa, 
    OFUSCAR_CEDULA(C.CEDULA) AS cedula, 
    ENCRIPTAR(C.PRIMER_NOMBRE) AS PRI_NOMBRE, 
    ENCRIPTAR(C.SEGUNDO_NOMBRE) AS SEG_NOMBRE, 
    ENCRIPTAR(C.PRIMER_APELLIDO) AS PRI_APELLIDO, 
    ENCRIPTAR(C.SEGUNDO_APELLIDO) AS SEG_APELLIDO, 
    CASE GENERO 
        WHEN 1 THEN ''M'' 
        WHEN 2 THEN ''F'' 
        ELSE ''OTRO'' 
    END AS GENERO, 
    C.FECHA_EXPEDICION AS FECH_EXP 
FROM CENSO C 
    JOIN DIVIPOL D 
        ON C.DEPARTAMENTO = D.DEPARTAMENTO AND 
        C.MUNICIPIO = D.MUNICIPIO AND 
        C.ZONA = D.ZONA AND 
        C.PUESTO = D.PUESTO
    JOIN DIVIMOVIL DM
        ON C.DEPARTAMENTO = DM.DEPARTAMENTO AND
        C.MUNICIPIO = DM.MUNICIPIO AND
        C.ZONA = DM.ZONA AND
        C.PUESTO = DM.PUESTO
WHERE D.DEPARTAMENTO=' || D.DEPARTAMENTO || ' AND D.MUNICIPIO=' || M.MUNICIPIO || ' ORDER BY DM.DIPOCONS) LOOP');
            DBMS_OUTPUT.PUT_LINE('v_stmt := c.dipocons_puesto || '','' 
            || c.mesa || '','' 
            || c.cedula || '','' 
            || REPLACE(c.pri_nombre, '''''''', '''''''''''') || '','' 
            || REPLACE(c.seg_nombre, '''''''', '''''''''''') || '',''
            || REPLACE(c.pri_apellido, '''''''', '''''''''''') || '',''
            || REPLACE(c.seg_apellido, '''''''', '''''''''''') || '','' 
            || c.genero || '',''
            || c.fech_exp;');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
            DBMS_OUTPUT.PUT_LINE('END LOOP;');
            DBMS_OUTPUT.PUT_LINE('END;');
            DBMS_OUTPUT.PUT_LINE('/');
            DBMS_OUTPUT.PUT_LINE('SPOOL OFF;');
        END LOOP;
    END LOOP;
    v_file_name := 'db/' || 'divimovil.txt';
    DBMS_OUTPUT.PUT_LINE('SET LINESIZE 75');
    DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
    DBMS_OUTPUT.PUT_LINE('DECLARE');
    DBMS_OUTPUT.PUT_LINE('v_stmt CLOB;');
    DBMS_OUTPUT.PUT_LINE('BEGIN');
    FOR DIVIMOVIL IN (SELECT DIPOCONS, DEPARTAMENTO, MUNICIPIO, ZONA, PUESTO, DESCRIPCION, TOT_CC FROM DIVIMOVIL ORDER BY DIPOCONS) LOOP
        DBMS_OUTPUT.PUT_LINE('v_stmt := LPAD(' || DIVIMOVIL.DIPOCONS|| ', 6, ''0'') || LPAD(' || DIVIMOVIL.DEPARTAMENTO || ', 3, CHR(32)) || ' || CASE WHEN DIVIMOVIL.MUNICIPIO IS NULL THEN 'LPAD(''-1'', 3, CHR(32))' ELSE 'LPAD(' || DIVIMOVIL.MUNICIPIO || ', 3, CHR(32))' END || ' || ' || CASE WHEN DIVIMOVIL.ZONA IS NULL THEN 'LPAD(''-1'', 3, CHR(32))' ELSE 'LPAD(' || DIVIMOVIL.ZONA ||', 3, CHR(32))' END || ' || ' || CASE WHEN DIVIMOVIL.PUESTO IS NULL THEN 'LPAD(''-1'', 3, CHR(32))' ELSE 'CHR(32) || ' || CASE WHEN REGEXP_LIKE(DIVIMOVIL.PUESTO, '^[0-9]$') THEN DIVIMOVIL.PUESTO ELSE 'LPAD('''|| DIVIMOVIL.PUESTO ||''', 2, ''0'')' END END || ' || RPAD(''' || DIVIMOVIL.DESCRIPCION || ''', 50, CHR(32)) || ' || CASE WHEN DIVIMOVIL.TOT_CC IS NULL THEN '''-00001''' ELSE 'LPAD(' || DIVIMOVIL.TOT_CC || ', 6, ''0'')' END || ';');
        DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('END;');
    DBMS_OUTPUT.PUT_LINE('/');
    DBMS_OUTPUT.PUT_LINE('SPOOL OFF;');
    DBMS_OUTPUT.PUT_LINE('EXIT');
END;
/
SPOOL OFF
EXIT