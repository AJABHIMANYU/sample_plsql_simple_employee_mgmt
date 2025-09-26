-- test_api_operations.sql
-- Script to test API-equivalent operations for simple_employee_mgmt_pkg

SET SERVEROUTPUT ON;

DECLARE
  v_name employees.name%TYPE;
  v_salary employees.salary%TYPE;
  v_dept_id employees.department_id%TYPE;
BEGIN
  -- 1. Create Employee (POST /api/SimpleEmployeeMgmtPkgs/create-employee)
  DBMS_OUTPUT.PUT_LINE('Creating employee: John Doe, Salary = 75000, DeptId = 10');
  simple_employee_mgmt_pkg.create_employee('John Doe', 75000, 10);

  -- 2. Read Employee (GET /api/SimpleEmployeeMgmtPkgs/read-employee/2)
  DBMS_OUTPUT.PUT_LINE('Reading employee ID 2');
  BEGIN
    simple_employee_mgmt_pkg.read_employee(2, v_name, v_salary, v_dept_id);
    DBMS_OUTPUT.PUT_LINE('Employee 2: Name = ' || v_name || ', Salary = ' || v_salary || ', Dept = ' || v_dept_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error reading employee 2: ' || SQLERRM);
  END;

  -- 3. Update Employee (POST /api/SimpleEmployeeMgmtPkgs/update-employee)
  DBMS_OUTPUT.PUT_LINE('Updating employee ID 1: Name = John F. Doe, DeptId = 20');
  BEGIN
    simple_employee_mgmt_pkg.update_employee(1, 'John F. Doe', 20);
    DBMS_OUTPUT.PUT_LINE('Employee 1 updated successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error updating employee 1: ' || SQLERRM);
  END;

  -- 4. Delete Employee (POST /api/SimpleEmployeeMgmtPkgs/delete-employee/1)
  DBMS_OUTPUT.PUT_LINE('Deleting employee ID 1');
  BEGIN
    simple_employee_mgmt_pkg.delete_employee(1);
    DBMS_OUTPUT.PUT_LINE('Employee 1 deleted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error deleting employee 1: ' || SQLERRM);
  END;

  -- 5. Give Raise (POST /api/SimpleEmployeeMgmtPkgs/give-raise)
  DBMS_OUTPUT.PUT_LINE('Giving raise to employee ID 1: Amount = 5000, User = postman_admin');
  BEGIN
    simple_employee_mgmt_pkg.give_raise(1, 5000, 'postman_admin');
    DBMS_OUTPUT.PUT_LINE('Raise applied successfully for employee 1');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error giving raise to employee 1: ' || SQLERRM);
  END;

  -- Verify results
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Final state of employees table:');
  FOR rec IN (SELECT emp_id, name, salary, department_id FROM employees) LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.emp_id || ', Name: ' || rec.name || ', Salary: ' || rec.salary || ', Dept: ' || rec.department_id);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Final state of audit_log table:');
  FOR rec IN (SELECT log_id, emp_id, action, details, log_date, log_user FROM audit_log) LOOP
    DBMS_OUTPUT.PUT_LINE('Log ID: ' || rec.log_id || ', Emp ID: ' || rec.emp_id || ', Action: ' || rec.action || ', Details: ' || rec.details || ', User: ' || rec.log_user || ', Date: ' || TO_CHAR(rec.log_date, 'DD-MON-YY'));
  END LOOP;

  COMMIT;
END;
/
