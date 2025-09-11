SELECT distinct
s.name,
  o.name,
  o.create_date,
  o.modify_date,
  us.user_updates,
  us.user_scans,
  us.user_seeks,
  us.user_lookups
  
FROM sys.objects o
JOIN sys.schemas s ON s.schema_id = o.schema_id
join sys.dm_db_partition_stats ps ON ps.object_id=o.object_id
inner join sys.dm_db_index_usage_stats as us ON o.object_id=us.object_id
WHERE NOT EXISTS (SELECT 1
    FROM sys.sql_expression_dependencies sed
    WHERE sed.referenced_id = o.object_id
)
and ps.row_count=0
and type='U'
order by modify_date desc