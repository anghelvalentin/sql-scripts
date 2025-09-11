declare @DBID int;
SELECT @DBID=DB_ID('UBISQL_COL_NEW')

select * FROM sys.dm_db_index_physical_stats(@DBID, NULL,NULL, NULL, 'LIMITED') ddips
where ddips.avg_fragmentation_in_percent>0
ORDER BY ddips.avg_fragmentation_in_percent desc

-- if the fragmentation is lower than 30%, then you can only reorganize(online) instead of rebuild