-- Create employees table
CREATE TABLE employees (
  emp_id NUMBER PRIMARY KEY,
  name VARCHAR2(100) NOT NULL,
  salary NUMBER(10,2) DEFAULT 0,
  department_id NUMBER
);

-- Create audit_log table
CREATE TABLE audit_log (
  log_id NUMBER PRIMARY KEY,
  emp_id NUMBER,
  action VARCHAR2(50),
  details VARCHAR2(500),
  log_date DATE DEFAULT SYSDATE,
  log_user VARCHAR2(50)
);

-- Create sequence for audit_log.log_id
CREATE SEQUENCE audit_log_seq START WITH 1 INCREMENT BY 1;
