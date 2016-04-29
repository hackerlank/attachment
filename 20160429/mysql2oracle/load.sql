-- sqlplus /nolog
-- connect meta_store/paic1234@JZTEST

@hive-schema-1.1.0.oracle.sql
Commit;
ALTER SESSION ENABLE PARALLEL DML;

BEGIN FOR c IN (SELECT c.owner, c.table_name, c.constraint_name FROM user_constraints c, user_tables t WHERE c.table_name = t.table_name AND c.status = 'ENABLED' AND NOT (t.iot_type IS NOT NULL AND c.constraint_type = 'P') ORDER BY c.constraint_type DESC) LOOP dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" disable constraint ' || c.constraint_name);
  END LOOP;
END;
/


@data2.sql
BEGIN FOR c IN (SELECT c.owner, c.table_name, c.constraint_name FROM user_constraints c, user_tables t WHERE c.table_name = t.table_name AND c.status = 'DISABLED' ORDER BY c.constraint_type) LOOP dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" enable constraint ' || c.constraint_name);
  END LOOP;
END;
/
Commit;
Exit;
