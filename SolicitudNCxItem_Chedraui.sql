select 
	a.cliente
	,a.folio
	,a.Codigo
	,a.CB
	,a.unidades
	,a.importe
	,a.cadena
	,a.Item
	,convert(varchar,a.FechaSubida,20)FechaSubida
	,a.Sucursal
from Devoluciones_Chedraui_Reporte_Acumulado_porItem a
where 1 = 1
	and a.folio like '%6803767120%'
		--or a.folio like '%6803803798%'
	and a.cliente  = '300131'