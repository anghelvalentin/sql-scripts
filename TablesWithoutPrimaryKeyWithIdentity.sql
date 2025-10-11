--Tables without primary key
SELECT OBJECT_SCHEMA_NAME( object_id ) as SchemaName, name AS TableName
FROM sys.tables
WHERE OBJECTPROPERTY(object_id,'tablehasprimaryKey') = 0 
ORDER BY SchemaName, TableName ;


-- Tables without primary key but with identity
SELECT OBJECT_SCHEMA_NAME( object_id ) as SchemaName, name AS TableName, OBJECT_SCHEMA_NAME( object_id )+'.'+name AS FullTableName
FROM sys.tables
WHERE OBJECTPROPERTY(object_id,'tablehasprimaryKey') = 0 and OBJECTPROPERTY(object_id,'TableHasIdentity') = 1
ORDER BY SchemaName, TableName ;

-- Tables without primary key but with identity, including if there are indexes on identity key
SELECT OBJECT_SCHEMA_NAME( t.object_id ) as SchemaName, t.name AS TableName, OBJECT_SCHEMA_NAME( t.object_id )+'.'+t.name AS FullTableName, c.name as NumeleColoaneiIdentity, STRING_AGG(i.name, ', ') as ColoanaFaceParteDinIndexii
FROM sys.tables t
inner join sys.columns c on c.object_id=t.object_id 
left join sys.index_columns ic on ic.object_id=t.object_id and ic.column_id=c.column_id and ic.index_column_id=1
left join sys.indexes i on i.object_id=ic.object_id and i.index_id=ic.index_id
WHERE OBJECTPROPERTY(t.object_id,'tablehasprimaryKey') = 0 and OBJECTPROPERTY(t.object_id,'TableHasIdentity') = 1 and c.is_identity=1 
group by OBJECT_SCHEMA_NAME( t.object_id ),t.name, OBJECT_SCHEMA_NAME(t.object_id )+'.'+t.name, c.name
ORDER BY SchemaName, TableName;
