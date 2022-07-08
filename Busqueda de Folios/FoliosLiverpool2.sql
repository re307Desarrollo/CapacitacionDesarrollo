create table #BuscarFolios(
	Cliente varchar(max)
	,Folio varchar(max)
)

--BULK INSERT #VentaWalmart FROM 'H:\Desarrollo\AuditoriaVenta\8.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
BULK INSERT #BuscarFolios FROM 'H:\Desarrollo\Devoluciones Liverpool\BusquedaFolios.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 2);

select * from #BuscarFolios

--select distinct a.NroReferen from Z_DV_Liverpool a
--where 1 = 1
--	and a.NroReferen in (select a.Folio from #BuscarFolios a)

--select * from Z_DV_Liverpool a
--where 1 = 1
--	and a.NroReferen in (select a.Folio from #BuscarFolios a)

select distinct a.cliente, a.folio from Devoluciones_Liverpool_Reporte_Acumulado_porItem a
where 1 = 1
	and exists (select * from #BuscarFolios b
				where 1 = 1
					and b.Folio = a.folio
					and b.Cliente = a.cliente
				)

select 
	a.cliente
	,a.Sucursal
	,a.folio
	,a.Codigo
	,a.CB
	,a.fecha
	,a.unidades
	,a.importe
from Devoluciones_Liverpool_Reporte_Acumulado_porItem a
where 1 = 1
	and exists (select * from #BuscarFolios b
				where 1 = 1
					and b.Folio = a.folio
					and b.Cliente = a.cliente
				)

drop table #BuscarFolios