select 
	a.cliente
	,a.folio
	,a.Codigo
	,a.CB
	,a.fecha
	,a.unidades
	,a.importe
	,a.cadena
	,a.Item
	,CONVERT(varchar,a.FechaSubida,20)FechaSubida
	,a.Sucursal
from Devoluciones_Chedraui_Reporte_Acumulado_porItem a
where 1 = 1
	and a.folio like '%6803620067%'
	or a.folio like '%6803574143%'