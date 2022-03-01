create table #VentaHEB(
	Fecha date,
RET varchar(max),
STR_ID varchar(max),
UPC varchar(max),
Venta_U int,
Venta_$ varchar(max),
Inventario varchar(max),

)

--BULK INSERT #VentaWalmart FROM 'H:\Desarrollo\AuditoriaVenta\8.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
BULK INSERT #VentaHEB FROM 'H:\Desarrollo\Venta HEB\HEB_D202201_2.csv' WITH (FIELDTERMINATOR= ',',FIRSTROW = 2);

insert into Z_VT_HEB
select 
	a.Fecha
	,a.STR_ID Sucursal
	,a.UPC  CodigoBarras
	,null
	,convert(varchar,convert(float,a.Venta_$)/a.Venta_U) PrecioPromedio
	,a.Venta_$ Ventas
	,a.Venta_U UnidadesVendidas
	,a.Inventario
	,'1'
	,GETDATE()
from #VentaHEB a
where 1 = 1
	and a.Fecha = '2022-01-25'

select * from Z_VT_HEB a
where 1 = 1
	and a.Fecha = '2022-01-26'

--drop table #VentaHEB
--drop table #Z_VT_HEB_CB_Desc