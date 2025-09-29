-- trigger.sql
-- Triggers for employees table

-- Auto-assign emp_id using sequence if not provided
CREATE OR REPLACE TRIGGER employees_bi_trg
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF :NEW.emp_id IS NULL THEN
    :NEW.emp_id := employees_seq.NEXTVAL;
  END IF;
END;
/

-- Validate salary to prevent negative values
CREATE OR REPLACE TRIGGER employees_salary_check
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
  IF :NEW.salary < 0 THEN
    RAISE_APPLICATION_ERROR(-20007, 'Salary cannot be negative');
  END IF;
END;
/
