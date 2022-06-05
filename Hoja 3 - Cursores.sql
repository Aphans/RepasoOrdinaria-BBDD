--EJ1

CREATE OR REPLACE PROCEDURE EJ1 (p_departamento number)
AS
    CURSOR C_1 IS SELECT APELLIDO,SALARIO,OFICIO FROM EMPLE WHERE DEPT_NO = p_departamento;
    v_contador number:=0;
    v_sumaSalarios number:=0;
BEGIN
    FOR v_1 IN C_1 LOOP
        DBMS_OUTPUT.PUT_LINE('Apellido:'||v_1.APELLIDO);
        DBMS_OUTPUT.PUT_LINE('Salario:'||v_1.SALARIO);
        DBMS_OUTPUT.PUT_LINE('Oficio:'||v_1.OFICIO);
        v_contador:=v_contador+1;
       v_sumaSalarios:=v_sumaSalarios+v_1.SALARIO;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Cantidad de empleados:'||v_contador);
    DBMS_OUTPUT.PUT_LINE('La suma de sus salarios es:'||v_sumaSalarios);
END;

BEGIN
EJ1(10);
END;

--EJ2

CREATE OR REPLACE PROCEDURE EJ2 (p_oficio varchar,p_porcentaje number)
AS
    e_exception exception;
    v_mensaje varchar2(50):=' ';
    CURSOR C_2 IS SELECT APELLIDO,SALARIO FROM EMPLE WHERE OFICIO = p_oficio;
    v_salarioPorcentaje number(10,2):=0;
BEGIN
    IF(p_oficio IS NULL OR p_porcentaje IS NULL) THEN  
        v_mensaje:='Los parametros no pueden ser nulos';
        RAISE e_exception;
    END IF;
    IF(p_porcentaje NOT between 0 AND 100) THEN
        v_mensaje:='El porcentaje debe estar entre 0 y 100';
        RAISE e_Exception;
    END IF;
    FOR v_2 IN C_2 LOOP
        DBMS_OUTPUT.PUT_LINE('Apellido:'||v_2.APELLIDO);
        DBMS_OUTPUT.PUT_LINE('Salario:'||v_2.SALARIO);
        v_salarioPorcentaje:=v_2.SALARIO+(v_2.SALARIO/100)*p_porcentaje;
        DBMS_OUTPUT.PUT_LINE('Salario+Porcentaje:'||v_salarioPorcentaje);
    END LOOP;
EXCEPTION
WHEN e_exception THEN
    DBMS_OUTPUT.PUT_LINE(v_mensaje);
END;

BEGIN
EJ2('EMPLEADO',20);
END;

--EJ3
