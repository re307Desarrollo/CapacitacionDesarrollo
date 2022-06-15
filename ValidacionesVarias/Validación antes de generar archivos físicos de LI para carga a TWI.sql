/****** Script for SelectTopNRows command from SSMS  ******/
declare
	@FechaConsulta date = DATEADD(dd,-1,GETDATE())

select @FechaConsulta [Fecha Consulta]
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
       and FechaCaptura = @FechaConsulta
order by Oracle asc, Folio asc
