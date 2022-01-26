create table #DetalleSolicitados(
	NotaCargo varchar(max)
	,Oracle int
	,RazonSocial varchar(max)
)

BULK INSERT #DetalleSolicitados FROM 'H:\Desarrollo\Devolucion Sanborns\detalleDevolucionSolicitados.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);

--select * from #DetalleSolicitados

select 
	a.NUM_TIENDA
	,a.ORACLE
	,a.Razon_Social
	,a.Sucursal
	,a.Denominación
	,a.Estado
	,a.Población
	,a.UPC
	,a.CODIGO
	,a.TITULO
	,a.EDITOR
	,a.FOLIO
	,a.FECHA_DEV
	,a.UNIDADES_DEV
	,a.PRECIO_DEV
	,a.TOTAL_DEV
	,a.[IMPORTE CABECERO]
	,a.VARIACION
	,a.Item
from Devoluciones_Sanborns_Reporte_Acumulado_porItem a
where 1 = 1
	and exists (select * from #DetalleSolicitados b
				where 1 =1
					and a.ORACLE = b.Oracle
					and a.FOLIO = b.NotaCargo
				)
order by a.ORACLE desc, a.FechaSubida desc

drop table 
	#DetalleSolicitados