
--EJ1
CREATE OR REPLACE PROCEDURE EJ1 (p_precio number,p_porcentaje number)
AS
e_error exception;
BEGIN
    IF p_porcentaje NOT BETWEEN 0 AND 100 THEN
        RAISE e_error;
    END IF;
    p_precio:=p_precio+(p_precio/100)*p_porcentaje;
EXCEPTION
WHEN e_error THEN
    DBMS_OUTPUT.PUT_LINE('El porcentaje debe estar entre 0 y 100');
END;

--EJ2
CREATE OR REPLACE PROCEDURE EJ2 (NUM1  NUMBER, NUM2  NUMBER)
AS
BEGIN
    FOR CONT IN NUM1..NUM2 LOOP
        IF MOD(CONT,2)=0 THEN
            DBMS_OUTPUT.PUT_LINE(CONT);
        END IF;
    END LOOP;
END;

--EJ3

CREATE OR REPLACE PROCEDURE EJ3(p_number number)
AS
BEGIN
    FOR i IN 0..10 LOOP
        DBMS_OUTPUT.PUT_LINE(i*p_number);
    END LOOP;
END;

BEGIN
EJ3(2);
END;


--EJ4

CREATE OR REPLACE PROCEDURE EJ4(p_fecha date)
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_NUMBER(TO_CHAR(p_fecha,'YYYY')));
END;

BEGIN
ej4('08/01/2000');
END;

--EJ5

CREATE OR REPLACE FUNCTION EJ5(p_date1 date,p_date2 date)
RETURN NUMBER
AS
v_diferencia number;
BEGIN
    IF(p_date1>p_date2) THEN
      v_diferencia:=TO_NUMBER(TO_CHAR(p_date1,'YYYY'))-(TO_NUMBER(TO_CHAR(p_date2,'YYYY')));
    ELSE
        v_diferencia:=(TO_NUMBER(TO_CHAR(p_date2,'YYYY'))-(TO_NUMBER(TO_CHAR(p_date1,'YYYY'))));
    END IF;
    RETURN v_diferencia;
END;

DECLARE
v_diferencia number;
BEGIN
v_diferencia:=EJ5('08-01-2000','04-06-2022');
DBMS_OUTPUT.PUT_LINE(v_diferencia);
END;

--EJ6

CREATE OR REPLACE FUNCTION EJ6
RETURN NUMBER
AS
v_trienios number(3);
BEGIN
    v_trienios:=EJ5('08-01-2000','04-06-2022')/3;
    RETURN v_trienios;
END;

DECLARE
v_trienios number;
BEGIN
    v_trienios:=EJ6;
    DBMS_OUTPUT.PUT_LINE(v_trienios);
END;

--EJ7

CREATE OR REPLACE FUNCTION EJ7(p_cadena varchar2)
RETURN varchar2
AS
v_cadena varchar2(50);
BEGIN
    v_cadena:=UPPER(p_cadena);
    FOR i IN 1..length(v_cadena) LOOP
        IF SUBSTR(p_cadena,i,1) NOT BETWEEN 'A' AND 'Z' THEN
        v_cadena:=REPLACE(p_cadena,SUBSTR(v_cadena,i,1),' ');
        END IF; 
    END LOOP;
    RETURN v_cadena;
END;

DECLARE
v_cadena varchar2(50);
BEGIN
    v_cadena:=EJ7('CARAME%O');
    DBMS_OUTPUT.PUT_LINE(v_cadena);
END;

--EJ8

CREATE OR REPLACE FUNCTION EJ8(p_apellido varchar2)
RETURN varchar2
AS
v_fechaAlta EMPLE.FECHA_ALT%TYPE;
BEGIN
    SELECT TO_CHAR(FECHA_ALT) INTO v_fechaAlta FROM EMPLE WHERE UPPER(APELLIDO)=UPPER(p_apellido);
    RETURN v_fechaAlta;
END;

DECLARE
v_fechaAlta date;
BEGIN
v_fechaAlta:=EJ8('ARROYO');
DBMS_OUTPUT.PUT_LINE(v_fechaAlta);
END;

--EJ9

CREATE OR REPLACE PROCEDURE EJ9(p_apellido varchar2,p_oficio varchar2)
AS
v_existe number;
v_antiguoOficio EMPLE.OFICIO%TYPE;
v_nuevoOficio EMPLE.OFICIO%TYPE;
BEGIN
    SELECT COUNT(*)INTO v_existe FROM EMPLE WHERE UPPER(APELLIDO)=UPPER(p_apellido);
    IF(v_existe>0) THEN
    SELECT OFICIO INTO v_antiguoOficio FROM EMPLE WHERE UPPER(APELLIDO) = UPPER(p_apellido);
    UPDATE EMPLE SET OFICIO = p_oficio WHERE UPPER(APELLIDO)=UPPER(p_apellido);
    SELECT OFICIO INTO v_nuevoOficio FROM EMPLE WHERE UPPER(APELLIDO) = UPPER(p_apellido);
    END IF;
    DBMS_OUTPUT.PUT_LINE('Antiguo oficio:'||v_antiguoOficio);
    DBMS_OUTPUT.PUT_LINE('Oficio nuevo:'||v_nuevoOficio);
END;

BEGIN
EJ9('ARROYO','PESCADERO');
END;


--EJ10
CREATE OR REPLACE PROCEDURE EJ10(p_departamento number)
AS
v_salarioMinimo EMPLE.SALARIO%TYPE;
v_salarioMaximo EMPLE.SALARIO%TYPE;
v_salarioMedio EMPLE.SALARIO%TYPE;
BEGIN
    SELECT MIN(SALARIO),MAX(SALARIO),AVG(SALARIO) INTO v_salarioMinimo,v_salarioMaximo,v_salarioMedio FROM EMPLE WHERE DEPT_NO=p_departamento;
    DBMS_OUTPUT.PUT_LINE('SALARIO MÍNIMO:'||v_salarioMinimo);
    DBMS_OUTPUT.PUT_LINE('SALARIO MÁXIMO:'||v_salarioMaximo);
    DBMS_OUTPUT.PUT_LINE('SALARIO MEDIO:'||v_salarioMedio);
END;

BEGIN
EJ10(20);
END;

--EJ11

CREATE OR REPLACE PROCEDURE EJ11(p_serieTitulo varchar2)
AS
v_codigo SERIE.SERIE_ID%TYPE;
v_existe number;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM SERIE WHERE UPPER(SERIE_TITULO)=UPPER(p_serieTitulo);
    IF(v_existe=1) THEN
    SELECT SERIE_ID INTO v_codigo FROM SERIE WHERE UPPER(SERIE_TITULO)=UPPER(p_serieTitulo);
    DBMS_OUTPUT.PUT_LINE(v_codigo);
    END IF;
END;

BEGIN
EJ10('The wire');
END;

--EJ12

CREATE OR REPLACE PROCEDURE EJ12 (p_codigo varchar2)
AS
v_numeroCapitulos number;
v_existe number;
e_error exception;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM SERIE WHERE SERIE_ID = p_codigo;
    IF(v_existe>0) THEN
        SELECT DECODE(COUNT(*),0,0,COUNT(*)) INTO v_numeroCapitulos FROM CAPITULO
        LEFT JOIN SERIE ON CAPITULO.SERIE_ID = SERIE.SERIE_ID 
        WHERE CAPITULO.SERIE_ID = p_codigo;
        DBMS_OUTPUT.PUT_LINE('Número de capitulos:'||v_numeroCapitulos);
    ELSE
        RAISE e_error;
    END IF;
EXCEPTION 
WHEN e_error THEN
DBMS_OUTPUT.PUT_LINE('La serie introducida no existe');
END;

BEGIN
EJ12('KLLNG1');
END

--EJ13

CREATE OR REPLACE FUNCTION EJ13 (p_codigo varchar2)
RETURN NUMBER
AS
v_numeroCapitulos number;
v_existe number;
e_error exception;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM SERIE WHERE SERIE_ID = p_codigo;
    IF(v_existe>0) THEN
        SELECT DECODE(COUNT(*),0,0,COUNT(*)) INTO v_numeroCapitulos FROM CAPITULO
        LEFT JOIN SERIE ON CAPITULO.SERIE_ID = SERIE.SERIE_ID 
        WHERE CAPITULO.SERIE_ID = p_codigo;
    ELSE
        RAISE e_error;
    END IF;
    RETURN v_numeroCapitulos;
EXCEPTION 
WHEN e_error THEN
DBMS_OUTPUT.PUT_LINE('La serie introducida no existe');
END;

DECLARE
v_numeroCapitulos number;
BEGIN
v_numeroCapitulos:=EJ13('KLLNG2');
DBMS_OUTPUT.PUT_LINE('Número de capitulos:'||v_numeroCapitulos);
END
;

--EJ15

CREATE OR REPLACE PROCEDURE EJ15(p_nombre varchar2)
AS
v_existe number;
v_personajes number;
e_noExiste exception;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM ACTOR WHERE UPPER(ACTOR_NOMBRE)=UPPER(p_nombre);
    IF(v_existe>0) THEN
    SELECT DECODE(COUNT(*),0,0,COUNT(*)) INTO v_personajes FROM REPARTO
        LEFT JOIN ACTOR ON REPARTO.ACTOR_ID = ACTOR.ACTOR_ID;
      DBMS_OUTPUT.PUT_LINE('Número de personajes que interpreta:'||v_personajes);
    ELSE 
        RAISE e_noExiste;
    END IF;
EXCEPTION
WHEN e_noExiste THEN    
    DBMS_OUTPUT.PUT_LINE('El actor no existe');
END;

BEGIN 
EJ15('Sidse Babett Knudsen');
END;

--EJ16

CREATE OR REPLACE PROCEDURE EJ16 (p_departamento number,p_porcentaje number)
AS
v_emp EMPLE.EMP_NO%TYPE;
v_media EMPLE.SALARIO%TYPE;
v_salario EMPLE.SALARIO%TYPE;
e_exception exception;
BEGIN
    SELECT EMP_NO INTO v_emp FROM EMPLE WHERE SALARIO = (SELECT MIN(SALARIO) FROM EMPLE WHERE DEPT_NO = p_departamento);
    SELECT SALARIO INTO v_salario FROM EMPLE WHERE EMP_NO = v_emp;
    SELECT AVG(SALARIO) INTO v_media FROM EMPLE WHERE DEPT_NO = p_departamento;
    IF((v_salario+(v_salario/100)*p_porcentaje)<v_media) THEN
        UPDATE EMPLE SET SALARIO = v_salario+(v_salario/100)*p_porcentaje WHERE EMP_NO=v_emp;
    ELSE
        RAISE e_exception;
    END IF;
EXCEPTION
WHEN e_exception THEN
DBMS_OUTPUT.PUT_LINE('El salario a subir supera la media del departamento');
END;

BEGIN
EJ16(10,104444);
END;

--EJ17

CREATE OR REPLACE PROCEDURE EJ17(p_emp number)
AS
BEGIN
    DELETE EMPLE WHERE EMP_NO = p_emp;
END;

BEGIN
EJ17(7902);
END;

--EJ18