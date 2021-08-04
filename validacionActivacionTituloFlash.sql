/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[IsFlashActive]
      ,[Titulo]
      ,[Editor]
  FROM [Global].[dbo].[Maestro_Productos_FlashActivo]
  where 1 = 1
    and Id = '34128511'


    return


    update a
    set a.IsFlashActive = 1
        from [Maestro_Productos_FlashActivo] a
        where 1 = 1
    and Id = '34128511'
 




