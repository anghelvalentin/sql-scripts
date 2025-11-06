
-- tabele cu peste 1000 de randuri care au mai multi indexi sau la fel ca numarul de coloane
select SCHEMA_NAME(o.schema_id)+'.'+o.name,ps.row_count, COUNT(DISTINCT c.name) As NumarColoane, COUNT(DISTINCT i.name) as NumarIndexi FROm sys.indexes i
inner join sys.objects o on i.object_id=o.object_id
inner join sys.columns c on o.object_id=c.object_id
inner join sys.dm_db_partition_stats ps on ps.object_id=o.object_id
where o.type='U' and ps.row_count>1000
group by SCHEMA_NAME(o.schema_id)+'.'+o.name , ps.row_count
HAVING  COUNT(DISTINCT c.name) <=COUNT(DISTINCT i.name) and COUNT(DISTINCT i.name)>2


-- tabele cu peste 10 randuri care au peste 5 indexi, ordonate descrescator
select SCHEMA_NAME(o.schema_id)+'.'+o.name,ps.row_count, COUNT(DISTINCT i.name) as NumarIndexi FROm sys.indexes i
inner join sys.objects o on i.object_id=o.object_id
inner join sys.dm_db_partition_stats ps on ps.object_id=o.object_id
where o.type='U' and ps.row_count>1
group by SCHEMA_NAME(o.schema_id)+'.'+o.name , ps.row_count
HAVING  COUNT(DISTINCT i.name)>5
order by NumarIndexi desc

-- tabelele ordonate dupar numarul de randuri si cati indexi au fiecare
select SCHEMA_NAME(o.schema_id)+'.'+o.name,ps.row_count, COUNT(DISTINCT i.name) as NumarIndexi FROm sys.indexes i
inner join sys.objects o on i.object_id=o.object_id
inner join sys.dm_db_partition_stats ps on ps.object_id=o.object_id
where o.type='U' and ps.row_count>1000
group by SCHEMA_NAME(o.schema_id)+'.'+o.name , ps.row_count
order by ps.row_count desc