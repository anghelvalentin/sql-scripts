CREATE TABLE TEST.ExecutionPlansHistory
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CaptureDate DATETIME DEFAULT GETDATE(),
    ObjectName SYSNAME,
    ObjectType NVARCHAR(50),
    QueryText NVARCHAR(MAX),
    QueryPlan XML
);

INSERT INTO TEST.ExecutionPlansHistory ( ObjectName, ObjectType,QueryText, QueryPlan)
SELECT 
    OBJECT_NAME(st.objectid, st.dbid) AS ObjectName,
    cp.objtype AS ObjectType,
    st.text AS QueryText,
    qp.query_plan AS QueryPlan
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
WHERE cp.objtype = 'Proc' -- only procs
  AND st.objectid IS NOT NULL
  and st.dbid=DB_ID()
