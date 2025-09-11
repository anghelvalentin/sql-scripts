select DISTINCT schema_name(tab.schema_id) as [schema_name], 
    tab.[name] as table_name, ps.row_count 
from sys.tables tab
join sys.dm_db_partition_stats ps ON ps.object_id=tab.object_id
    left outer join sys.indexes pk
        on tab.object_id = pk.object_id 
        and pk.is_primary_key = 1
where pk.object_id is null
order by ps.row_count desc, schema_name(tab.schema_id) ,
    tab.[name]