CREATE proc [dbo].[find] @text varchar(255), @ProcNameLike varchar(255) = '%'
as 
begin
                select distinct [schema] = schema_name(b.schema_id), b.name, b.type, a.id from syscomments a, sys.objects b where a.id = b.object_id
                and b.type <>'U' and upper(a.text) like '%'+upper(@text)+'%' and b.name like @ProcNameLike
end
