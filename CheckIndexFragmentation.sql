declare @DBID int;
SELECT @DBID=DB_ID('YOUR DB NAME')

select * FROM sys.dm_db_index_physical_stats(@DBID, NULL,NULL, NULL, 'LIMITED') ddips
where ddips.avg_fragmentation_in_percent>0
ORDER BY ddips.avg_fragmentation_in_percent desc

-- if the fragmentation is lower than 30%, then you can only reorganize(online) instead of rebuild


SELECT dbschemas.[name] as 'Schema',
dbtables.[name] as 'Table',
dbindexes.[name] as 'Index',
indexstats.avg_fragmentation_in_percent,
indexstats.page_count*8/1024 as 'IndexSizeMB'
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID() and indexstats.avg_fragmentation_in_percent>30 and indexstats.index_type_desc='NONCLUSTERED INDEX'
order by IndexSizeMB desc
