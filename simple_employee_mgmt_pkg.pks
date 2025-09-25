CREATE OR REPLACE PACKAGE simple_employee_mgmt_pkg AS
  -- Create a new employee
  PROCEDURE create_employee(p_name IN VARCHAR2, p_salary IN NUMBER, p_dept_id IN NUMBER);

  -- Read employee details
  PROCEDURE read_employee(p_emp_id IN NUMBER, p_name OUT VARCHAR2, p_salary OUT NUMBER, p_dept_id OUT NUMBER);

  -- Update employee details (name and department)
  PROCEDURE update_employee(p_emp_id IN NUMBER, p_name IN VARCHAR2, p_dept_id IN NUMBER);

  -- Delete an employee
  PROCEDURE delete_employee(p_emp_id IN NUMBER);

  -- Give a raise to an employee
  PROCEDURE give_raise(p_emp_id IN NUMBER, p_raise_amount IN NUMBER, p_user IN VARCHAR2 DEFAULT USER);
  
  -- Calculate bonus for an employee
  FUNCTION calculate_bonus(p_emp_id IN NUMBER) RETURN NUMBER;
END simple_employee_mgmt_pkg;
/
