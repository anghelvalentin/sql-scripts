SET NOCOUNT ON
DECLARE @SchemaName NVARCHAR(128)
DECLARE @ObjectName NVARCHAR(128)
DECLARE @FullObjectName NVARCHAR(258)
DECLARE @Script NVARCHAR(MAX)

-- Cursor to iterate through the objects
DECLARE ObjectCursor CURSOR FOR
SELECT [schema], [name]
FROM (
    VALUES 
('Schema1','Procedure1'),
('Schema2','Procedure2')
) AS ObjectList([schema], [name])

OPEN ObjectCursor

FETCH NEXT FROM ObjectCursor INTO @SchemaName, @ObjectName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @FullObjectName = QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
    SET @Script = ''

    BEGIN TRY
        -- Collect the script using sp_helptext
        --INSERT INTO #TempScript
        EXEC sp_helptext @FullObjectName

        --SELECT @Script = @Script + Text FROM #TempScript

        -- Print or Save the script
        PRINT '-- Object: ' + @FullObjectName
        --PRINT @Script
        PRINT 'GO'
    END TRY
    BEGIN CATCH
        PRINT 'Error generating script for ' + @FullObjectName
    END CATCH

    FETCH NEXT FROM ObjectCursor INTO @SchemaName, @ObjectName
END

CLOSE ObjectCursor
DEALLOCATE ObjectCursor