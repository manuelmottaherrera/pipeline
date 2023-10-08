
SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET HEADING OFF;
SET ECHO OFF;
SET FEEDBACK OFF;
SET LONG 32767;
SET LINESIZE 32767;
SET TRIMSPOOL ON;

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
    
        FOR D IN (SELECT DISTINCT DEPARTAMENTO, MUNICIPIO FROM DIVIPOL ORDER BY DEPARTAMENTO, MUNICIPIO;) LOOP
            v_departamento := LPAD(D.DEPARTAMENTO, 2, '0');
            v_municipio := LPAD(D.MUNICIPIO, 3, '0');
            v_file_name := v_folder || v_departamento || v_municipio || 'c.sql';
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
            DBMS_OUTPUT.PUT_LINE('BEGIN');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE divipol (dipocons INT,dpto INT NOT NULL DEFAULT -1,mcpio INT NOT NULL DEFAULT -1,zona INT NOT NULL DEFAULT -1, puesto VARCHAR(2) NOT NULL DEFAULT ''''-1'''', tot_cc INT NOT NULL DEFAULT -1, descripcion VARCHAR (200), direccion VARCHAR (200), PRIMARY KEY (dipocons));'');');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(''CREATE TABLE censo (dipocons_puesto INT NOT NULL,mesa INT NOT NULL,cedula BIGINT NOT NULL,pri_nombre VARCHAR (60) NOT NULL,seg_nombre VARCHAR(60),pri_apellido VARCHAR(60) NOT NULL,seg_apellido VARCHAR(60),genero VARCHAR(12),fech_exp VARCHAR(60),PRIMARY KEY (cedula),CONSTRAINT fk_censo_divipol FOREIGN KEY (dipocons_puesto)REFERENCES divipol (dipocons));'');');
            DBMS_OUTPUT.PUT_LINE('END;');
            DBMS_OUTPUT.PUT_LINE('/');
            DBMS_OUTPUT.PUT_LINE('SPOOL OFF;');
            DBMS_OUTPUT.PUT_LINE('EXIT');

            v_file_name := v_folder || v_departamento || v_municipio || 'c_divipol.csv';
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
            DBMS_OUTPUT.PUT_LINE('FOR C IN (
SELECT 
    DISTINCT DM.DIPOCONS AS DIPOCONS, 
    D.DEPARTAMENTO AS dpto, 
    D.MUNICIPIO AS mcpio, 
    D.ZONA AS zona, 
    D.PUESTO as puesto, 
    DM.TOT_CC AS tot_cc, 
    DM.DESCRIPCION AS descripcion, 
    MAX(C.DIRECCION) as direccion 
FROM DIVIPOL D 
    JOIN DIVIMOVIL DM ON 
        D.DEPARTAMENTO=DM.DEPARTAMENTO AND 
        D.MUNICIPIO=DM.MUNICIPIO AND 
        D.ZONA=DM.ZONA AND 
        D.PUESTO=DM.PUESTO
    JOIN CENSO C ON
        C.DEPARTAMENTO=D.DEPARTAMENTO AND
        C.MUNICIPIO=D.MUNICIPIO AND
        C.ZONA=D.ZONA AND
        C.PUESTO=D.PUESTO
WHERE 
    D.DEPARTAMENTO=' || D.DEPARTAMENTO || ' AND 
    D.MUNICIPIO=' || D.MUNICIPIO ||'
ORDER BY DM.DIPOCONS) LOOP');
            DBMS_OUTPUT.PUT_LINE('v_stmt := c.DIPOCONS || '','' || c.dpto || '','' || c.mcpio || '','' || c.zona || '','' || LPAD(c.puesto, 2, ''0'') || '','' || c.tot_cc || '',"'' || CONVERTIR_CSV(c.descripcion) || ''","'' || CONVERTIR_CSV(c.direccion) || ''"'';');
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT.PUT_LINE(v_stmt);');
            DBMS_OUTPUT.PUT_LINE('END LOOP;');
            DBMS_OUTPUT.PUT_LINE('END;');
            DBMS_OUTPUT.PUT_LINE('/');
            DBMS_OUTPUT.PUT_LINE('SPOOL OFF;');
            DBMS_OUTPUT.PUT_LINE('EXIT');
            v_file_name := v_folder || v_departamento || v_municipio || 'c_censo.csv';
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
            DBMS_OUTPUT.PUT_LINE('FOR c IN (SELECT
    DISTINCT DM.DIPOCONS AS dipocons_puesto,
    C.MESA as mesa,
    OFUSCAR_CEDULA(C.CEDULA) AS cedula,
    ENCRIPTAR(C.PRIMER_NOMBRE) AS PRI_NOMBRE,
    ENCRIPTAR(C.SEGUNDO_NOMBRE) AS SEG_NOMBRE,
    ENCRIPTAR(C.PRIMER_APELLIDO) AS PRI_APELLIDO,
    ENCRIPTAR(C.SEGUNDO_APELLIDO) AS SEG_APELLIDO,
    CASE GENERO
        WHEN ''1'' THEN ''M''
        WHEN ''2'' THEN ''F''
        ELSE GENERO
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
WHERE D.DEPARTAMENTO=' || D.DEPARTAMENTO || ' AND D.MUNICIPIO=' || D.MUNICIPIO || ' ORDER BY DM.DIPOCONS) LOOP');
            DBMS_OUTPUT.PUT_LINE('v_stmt := c.dipocons_puesto || '',''
            || c.mesa || '',''
            || c.cedula || '',"''
            || CONVERTIR_CSV(c.pri_nombre) || ''","''
            || CONVERTIR_CSV(c.seg_nombre) || ''","''
            || CONVERTIR_CSV(c.pri_apellido) || ''","''
            || CONVERTIR_CSV(c.seg_apellido) || ''",''
            || c.genero || '',''
            || c.fech_exp;');
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