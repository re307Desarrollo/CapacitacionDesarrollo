/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [ORACLE] Oracle
      ,[FOLIO] Folio
      ,[Lote] Lote_Incorrecto
      ,[Lote_Correcto] Lote_Correcto
      ,[FechaCaptura]
      ,[Usuario]
      ,[Bitacora]
  FROM [Global].[dbo].[Control_Entregas_Devoluciones_LotesDuplicados]
  where 1 = 1
       and FechaCaptura = '2021-08-03'
order by Oracle asc, Folio asc
