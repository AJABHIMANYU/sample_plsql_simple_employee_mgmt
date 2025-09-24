CREATE OR REPLACE FUNCTION get_dept_count(p_dept_id IN NUMBER) RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM employees
  WHERE department_id = p_dept_id;
  RETURN v_count;
END get_dept_count;
/
