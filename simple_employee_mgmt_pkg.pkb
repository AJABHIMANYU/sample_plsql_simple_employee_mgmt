CREATE OR REPLACE PACKAGE BODY simple_employee_mgmt_pkg AS
  -- Private procedure to log actions
  PROCEDURE log_action(p_emp_id IN NUMBER, p_action IN VARCHAR2, p_details IN VARCHAR2, p_user IN VARCHAR2) IS
  BEGIN
    INSERT INTO audit_log (log_id, emp_id, action, details, log_date, log_user)
    VALUES (audit_log_seq.NEXTVAL, p_emp_id, p_action, p_details, SYSDATE, p_user);
    COMMIT;
  END log_action;

  PROCEDURE create_employee(p_name IN VARCHAR2, p_salary IN NUMBER, p_dept_id IN NUMBER) IS
    v_emp_id NUMBER;
  BEGIN
    v_emp_id := employees_seq.NEXTVAL;
    INSERT INTO employees (emp_id, name, salary, department_id)
    VALUES (v_emp_id, p_name, p_salary, p_dept_id);
    log_action(v_emp_id, 'CREATE', 'Created employee ' || p_name || ' with salary ' || p_salary, USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20004, 'Error creating employee: ' || SQLERRM);
  END create_employee;

  PROCEDURE read_employee(p_emp_id IN NUMBER, p_name OUT VARCHAR2, p_salary OUT NUMBER, p_dept_id OUT NUMBER) IS
  BEGIN
    SELECT name, salary, department_id
    INTO p_name, p_salary, p_dept_id
    FROM employees
    WHERE emp_id = p_emp_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20002, 'Employee ID ' || p_emp_id || ' not found');
  END read_employee;

  PROCEDURE update_employee(p_emp_id IN NUMBER, p_name IN VARCHAR2, p_dept_id IN NUMBER) IS
  BEGIN
    UPDATE employees
    SET name = p_name, department_id = p_dept_id
    WHERE emp_id = p_emp_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Employee ID ' || p_emp_id || ' not found');
    END IF;
    log_action(p_emp_id, 'UPDATE', 'Updated name to ' || p_name || ' and department to ' || p_dept_id, USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20005, 'Error updating employee: ' || SQLERRM);
  END update_employee;

  PROCEDURE delete_employee(p_emp_id IN NUMBER) IS
  BEGIN
    DELETE FROM employees WHERE emp_id = p_emp_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Employee ID ' || p_emp_id || ' not found');
    END IF;
    log_action(p_emp_id, 'DELETE', 'Deleted employee', USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20006, 'Error deleting employee: ' || SQLERRM);
  END delete_employee;

  PROCEDURE give_raise(p_emp_id IN NUMBER, p_raise_amount IN NUMBER, p_user IN VARCHAR2 DEFAULT USER) IS
    v_name employees.name%TYPE;
    v_current_salary employees.salary%TYPE;
  BEGIN
    IF p_raise_amount < 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Raise amount cannot be negative');
    END IF;
    SELECT name, salary INTO v_name, v_current_salary
    FROM employees WHERE emp_id = p_emp_id FOR UPDATE;
    UPDATE employees SET salary = salary + p_raise_amount WHERE emp_id = p_emp_id;
    log_action(p_emp_id, 'RAISE', 'Raised salary for ' || v_name || ' by ' || p_raise_amount, p_user);
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      log_action(p_emp_id, 'ERROR', 'Employee ID ' || p_emp_id || ' not found', p_user);
      RAISE_APPLICATION_ERROR(-20002, 'Employee ID ' || p_emp_id || ' not found');
  END give_raise;

  FUNCTION calculate_bonus(p_emp_id IN NUMBER) RETURN NUMBER IS
    v_salary employees.salary%TYPE;
    v_bonus NUMBER;
  BEGIN
    SELECT salary INTO v_salary FROM employees WHERE emp_id = p_emp_id;
    v_bonus := LEAST(v_salary * 0.10, 5000);
    RETURN v_bonus;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
  END calculate_bonus;
END simple_employee_mgmt_pkg;
/
