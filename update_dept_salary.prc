CREATE OR REPLACE PROCEDURE update_dept_salary(p_dept_id IN NUMBER, p_raise_percentage IN NUMBER) IS
BEGIN
  IF p_raise_percentage < 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Raise percentage cannot be negative');
  END IF;
  UPDATE employees
  SET salary = salary * (1 + p_raise_percentage / 100)
  WHERE department_id = p_dept_id;
  COMMIT;
END update_dept_salary;
/
