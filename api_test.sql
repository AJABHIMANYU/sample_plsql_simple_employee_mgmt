-- test_api_operations.sql
-- Script to test API-equivalent operations for simple_employee_mgmt_pkg
-- Modified to ensure all operations succeed without errors, test all components, and demonstrate multiple employees

SET SERVEROUTPUT ON;

DECLARE
  v_name employees.name%TYPE;
  v_salary employees.salary%TYPE;
  v_dept_id employees.department_id%TYPE;
  v_bonus NUMBER;
  v_count NUMBER;
BEGIN
  -- 1. Create Employee (POST /api/SimpleEmployeeMgmtPkgs/create-employee)
  DBMS_OUTPUT.PUT_LINE('Creating employee: John Doe, Salary = 75000, DeptId = 10');
  BEGIN
    simple_employee_mgmt_pkg.create_employee('John Doe', 75000, 10);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error creating employee John Doe: ' || SQLERRM);
  END;

  -- 1b. Create Second Employee (POST /api/SimpleEmployeeMgmtPkgs/create-employee)
  DBMS_OUTPUT.PUT_LINE('Creating employee: Jane Smith, Salary = 80000, DeptId = 20');
  BEGIN
    simple_employee_mgmt_pkg.create_employee('Jane Smith', 80000, 20);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error creating employee Jane Smith: ' || SQLERRM);
  END;

  -- 2. Read Employee (GET /api/SimpleEmployeeMgmtPkgs/read-employee/1)
  DBMS_OUTPUT.PUT_LINE('Reading employee ID 1');
  BEGIN
    simple_employee_mgmt_pkg.read_employee(1, v_name, v_salary, v_dept_id);
    DBMS_OUTPUT.PUT_LINE('Employee 1: Name = ' || v_name || ', Salary = ' || v_salary || ', Dept = ' || v_dept_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error reading employee 1: ' || SQLERRM);
  END;

  -- 3. Update Employee (POST /api/SimpleEmployeeMgmtPkgs/update-employee)
  DBMS_OUTPUT.PUT_LINE('Updating employee ID 2: Name = Jane S. Smith, DeptId = 30');
  BEGIN
    simple_employee_mgmt_pkg.update_employee(2, 'Jane S. Smith', 30);
    DBMS_OUTPUT.PUT_LINE('Employee 2 updated successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error updating employee 2: ' || SQLERRM);
  END;

  -- 4. Give Raise (POST /api/SimpleEmployeeMgmtPkgs/give-raise)
  DBMS_OUTPUT.PUT_LINE('Giving raise to employee ID 1: Amount = 5000, User = postman_admin');
  BEGIN
    simple_employee_mgmt_pkg.give_raise(1, 5000, 'postman_admin');
    DBMS_OUTPUT.PUT_LINE('Raise applied successfully for employee 1');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error giving raise to employee 1: ' || SQLERRM);
  END;

  -- 5. Delete Employee (POST /api/SimpleEmployeeMgmtPkgs/delete-employee/2)
  DBMS_OUTPUT.PUT_LINE('Deleting employee ID 2');
  BEGIN
    simple_employee_mgmt_pkg.delete_employee(2);
    DBMS_OUTPUT.PUT_LINE('Employee 2 deleted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error deleting employee 2: ' || SQLERRM);
  END;

  -- 6. Test update_dept_salary procedure (POST /api/SimpleEmployeeMgmtPkgs/update-dept-salary)
  DBMS_OUTPUT.PUT_LINE('Updating dept 10 salary by 10%');
  BEGIN
    update_dept_salary(10, 10);
    DBMS_OUTPUT.PUT_LINE('Dept 10 salaries updated successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error updating dept 10 salaries: ' || SQLERRM);
  END;

  -- 7. Test get_dept_count function
  v_count := get_dept_count(10);
  DBMS_OUTPUT.PUT_LINE('Employee count in Dept 10: ' || v_count);

  -- 8. Test calculate_bonus function
  v_bonus := simple_employee_mgmt_pkg.calculate_bonus(1);
  DBMS_OUTPUT.PUT_LINE('Calculated bonus for employee 1: ' || v_bonus);

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
END;
/
