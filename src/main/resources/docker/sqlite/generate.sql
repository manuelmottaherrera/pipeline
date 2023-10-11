
SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET HEADING OFF;
SET ECHO OFF;
SET FEEDBACK OFF;
SET LONG 32767;
SET LINESIZE 32767;
SET TRIMSPOOL ON;

CREATE OR REPLACE FUNCTION CONVERTIR(p_valor IN VARCHAR2) RETURN VARCHAR2 AS

BEGIN
    IF p_valor IS NULL OR p_valor = '' OR p_valor = '' THEN
        RETURN 'NULL';
    ELSE
        RETURN '''' || REPLACE(p_valor, '''', '''''') || '''';
    END IF;
END CONVERTIR;
/
CREATE OR REPLACE FUNCTION CONVERTIR_CSV(p_valor IN VARCHAR2) RETURN VARCHAR2 AS
BEGIN
    IF p_valor IS NULL OR p_valor = '' THEN
        RETURN NULL;
    END IF;
    RETURN p_valor;
END CONVERTIR_CSV;
/
CREATE OR REPLACE FUNCTION OFUSCAR_CEDULA (CEDULA IN NUMBER) RETURN NUMBER IS
    CEDULA_OFUSCADA NUMBER;
BEGIN
    CEDULA_OFUSCADA := (CEDULA * 1024) + 698;

    RETURN CEDULA_OFUSCADA;
END OFUSCAR_CEDULA;
/
CREATE OR REPLACE FUNCTION encriptar(p_input VARCHAR2) RETURN VARCHAR2 IS
    v_encrypted VARCHAR2(32767);
    v_char CHAR(1);
    TYPE t_char_map IS TABLE OF CHAR INDEX BY PLS_INTEGER;
    v_ori t_char_map;
    v_sin t_char_map;
    v_index PLS_INTEGER;
BEGIN
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
    v_folder VARCHAR2(10) := 'db/';
BEGIN
    
        FOR D IN (SELECT DISTINCT DEPARTAMENTO, MUNICIPIO FROM DIVIPOL ORDER BY DEPARTAMENTO, MUNICIPIO) LOOP
            v_departamento := LPAD(D.DEPARTAMENTO, 2, '0');
            v_municipio := LPAD(D.MUNICIPIO, 3, '0');
            v_file_name := v_folder || v_departamento || v_municipio || 'hj.sql';
            DBMS_OUTPUT.PUT_LINE('SPOOL ' || v_file_name);
            DBMS_OUTPUT.PUT_LINE('SET SERVEROUTPUT ON;');
            DBMS_OUTPUT.PUT_LINE('SET VERIFY OFF;');
            DBMS_OUTPUT.PUT_LINE('SET HEADING OFF;');
            DBMS_OUTPUT.PUT_LINE('SET ECHO OFF;');
            DBMS_OUTPUT.PUT_LINE('SET LONG 32767;');
            DBMS_OUTPUT.PUT_LINE('SET LINESIZE 32767;');
            DBMS_OUTPUT.PUT_LINE('SET FEEDBACK OFF;');
            DBMS_OUTPUT.PUT_LINE('SET TRIMSPOOL ON;');
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
        WHEN ''1'' THEN ''M''
        WHEN ''2'' THEN ''F''
        ELSE C.GENERO
    END AS GENERO,
    C.FECHA_EXPEDICION AS FECH_EXP,
    D.DIPOCONS AS DIPOCONS_PUESTO,
    J.MESA AS MESA,
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
FROM INFOMIN00_JURADOS I
    JOIN JURADOS J
        ON  TO_NUMBER(I.PIN)=J.CEDULA
    JOIN CENSO_SQLITE C
        ON J.CEDULA = C.CEDULA
    JOIN DIVIMOVIL D
        ON J.DEPARTAMENTO = D.DEPARTAMENTO AND
        J.MUNICIPIO = D.MUNICIPIO AND
        J.ZONA = D.ZONA AND
        J.PUESTO = D.PUESTO
WHERE
    C.DEPARTAMENTO=' || D.DEPARTAMENTO || ' AND
    C.MUNICIPIO=' || D.MUNICIPIO || '
ORDER BY D.DIPOCONS) LOOP');
            DBMS_OUTPUT.PUT_LINE('v_stmt := ''INSERT INTO INFOMIN00 (PIN, PRI_NOMBRE, SEG_NOMBRE, PRI_APELLIDO, SEG_APELLIDO, GENERO, FECH_EXP, DIPOCONS_PUESTO, MESA, PK31, PK32, PK33, PK34, PK35, PK36, PK37, PK38, PK39, PK40, PK291) VALUES ('' || c.PIN || '', '' || CONVERTIR(c.PRI_NOMBRE) || '', '' || CONVERTIR(c.SEG_NOMBRE) || '', '' || CONVERTIR(c.PRI_APELLIDO) || '', '' || CONVERTIR(c.SEG_APELLIDO) || '', '''''' || c.GENERO || '''''', '''''' || c.FECH_EXP || '''''', ''|| c.DIPOCONS_PUESTO || '', '' || c.MESA || '', '' || CHR(10) || CONVERTIR(c.PK31) || '', '' || CHR(10) || CONVERTIR(c.PK32) || '', '' || CHR(10) || CONVERTIR(c.PK33) || '', '' || CHR(10) || CONVERTIR(c.PK34) || '', '' || CHR(10) || CONVERTIR(c.PK35) || '', '' || CHR(10) || CONVERTIR(c.PK36) || '', '' || CHR(10) || CONVERTIR(c.PK37) || '', '' || CHR(10) || CONVERTIR(c.PK38) || '', '' || CHR(10) || CONVERTIR(c.PK39) || '', '' || CHR(10) || CONVERTIR(c.PK40) || '', '' || CHR(10) || CONVERTIR(c.PK291) || '');'';');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
            DBMS_OUTPUT.PUT_LINE('END LOOP;');
            DBMS_OUTPUT.PUT_LINE('END;');
            DBMS_OUTPUT.PUT_LINE('/');
            DBMS_OUTPUT.PUT_LINE('SPOOL OFF;');
            DBMS_OUTPUT.PUT_LINE('EXIT');
        END LOOP;
END;
/
SPOOL OFF
EXIT