
--EJ1

-- EJ1 FIRST METHOD
CREATE OR REPLACE PROCEDURE ej1(p_departamento number,p_porcentaje number)
AS
    CURSOR c_1 IS SELECT SALARIO FROM EMPLE WHERE DEPT_NO = p_departamento FOR UPDATE;
    BEGIN
        FOR v_1 IN c_1 LOOP
        UPDATE EMPLE SET SALARIO = SALARIO+(SALARIO/100)*p_porcentaje WHERE CURRENT OF c_1;
        END LOOP;
    END;
    
BEGIN
ej1(20,30);
END;

--EJ1 SECOND METHOD

CREATE OR REPLACE PROCEDURE ej1(p_departamento number,p_porcentaje number)
AS
    CURSOR c_1 IS SELECT SALARIO,ROWID FROM EMPLE WHERE DEPT_NO = p_departamento FOR UPDATE;
    BEGIN
        FOR v_1 IN c_1 LOOP
        UPDATE EMPLE SET SALARIO = SALARIO+(SALARIO/100)*p_porcentaje WHERE ROWID = v_1.ROWID;
        END LOOP;
    END;
    
BEGIN
ej1(20,30);
END;

--EJ2

CREATE OR REPLACE PROCEDURE ej_2(p_departamento number,p_importe number,p_porcentaje number)
AS
    CURSOR c_2 IS SELECT SALARIO FROM EMPLE WHERE DEPT_NO = p_departamento FOR UPDATE; 
    v_contador number:=0;
    BEGIN
        FOR v_2 IN c_2 LOOP
            IF(p_importe>((v_2.SALARIO/100)*p_porcentaje)) THEN
              UPDATE EMPLE SET SALARIO = SALARIO+p_importe WHERE CURRENT OF c_2;
            ELSE
                UPDATE EMPLE SET SALARIO = SALARIO+(SALARIO/100)*p_porcentaje WHERE CURRENT OF c_2;
            END IF;
        v_contador:=v_contador+1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Número de filas actualizadas:'||v_contador);
    END;
    
BEGIN
ej2(10,10,20);
END;

--EJ3

CREATE OR REPLACE PROCEDURE ej_2(p_oficio varchar2)
AS
    CURSOR c_2 IS SELECT SALARIO FROM EMPLE WHERE OFICIO = p_oficio AND SALARIO < (SELECT AVG(SALARIO) FROM EMPLE WHERE OFICIO = p_oficio) FOR UPDATE; 
    v_diferencia number;
    v_salarioMedio EMPLE.SALARIO%TYPE;
    e_error exception;
    v_contador number:=0;
    v_existe number;
    BEGIN
        SELECT COUNT(*)INTO v_existe FROM EMPLE WHERE OFICIO = p_oficio;
        IF(v_existe>0) THEN
            SELECT AVG(SALARIO) INTO v_salarioMedio FROM EMPLE WHERE OFICIO = p_oficio;
            FOR v_2 IN c_2 LOOP
            v_diferencia:=v_salarioMedio-v_2.SALARIO;
            UPDATE EMPLE SET SALARIO = SALARIO+(v_diferencia/100)*50 WHERE CURRENT OF c_2;
            v_contador:=v_contador+1;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('Número de filas actualizadas:'||v_contador);
        ELSE
            RAISE e_error;
        END IF;
    EXCEPTION
    WHEN e_error THEN
        DBMS_OUTPUT.PUT_LINE('Oficio no encontrado');    
    END;
    
BEGIN
ej_2('a');
END;