CREATE OR REPLACE PACKAGE simple_employee_mgmt_pkg AS
  -- Give a raise to an employee
  PROCEDURE give_raise(p_emp_id IN NUMBER, p_raise_amount IN NUMBER, p_user IN VARCHAR2 DEFAULT USER);
  
  -- Calculate bonus for an employee
  FUNCTION calculate_bonus(p_emp_id IN NUMBER) RETURN NUMBER;
END simple_employee_mgmt_pkg;
/
