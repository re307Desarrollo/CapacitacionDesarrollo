create table #Venta(mes varchar(max),
	nombre_pedido varchar(max),
	precio_del_producto varchar(max),
	Titulo_del_producto varchar(max),
	variante_sku varchar(max),
	pedidos varchar(max),
	Ventas_brutas varchar(max),
	devoluciones varchar(max),
	las_ventas_netas varchar(max),
	ventas_totales varchar(max),
	Cantidad_neta varchar(max),
	cantidad_de_articulo_devuelto varchar(max)
)

BULK INSERT #Venta FROM 'H:\Desarrollo\ventas _2020-10-01_2022-02-27.txt' WITH (CODEPAGE = 1252,FIELDTERMINATOR= '	',FIRSTROW = 2);

--select * from #Venta

select 
	 a.mes
	 ,REPLACE(a.nombre_pedido,'#','')nombre_pedido
	 ,convert(float,REPLACE(REPLACE(replace(replace(REPLACE(REPLACE(a.precio_del_producto,'$',''),'-','0'),'"',''),'"',''),' ',''),',','')) precio_del_producto
	 ,a.Titulo_del_producto
	 ,a.variante_sku
	 ,CONVERT(int,a.pedidos) pedidos
	 ,convert(float,REPLACE(REPLACE(replace(replace(REPLACE(REPLACE(a.Ventas_brutas,'$',''),'-','0'),'"',''),'"',''),' ',''),',','')) Ventas_brutas
	 ,convert(float,REPLACE(REPLACE(replace(replace(REPLACE(REPLACE(a.devoluciones,'$',''),'-','0'),'"',''),'"',''),' ',''),',','')) devoluciones
	 ,convert(float,REPLACE(REPLACE(replace(replace(REPLACE(REPLACE(a.las_ventas_netas,'$',''),'-','0'),'"',''),'"',''),' ',''),',','')) las_ventas_netas
	 ,convert(float,REPLACE(REPLACE(replace(replace(REPLACE(REPLACE(a.ventas_totales,'$',''),'-','0'),'"',''),'"',''),' ',''),',','')) ventas_totales
	 ,CONVERT(int,a.Cantidad_neta) Cantidad_neta
	 ,CONVERT(int,a.cantidad_de_articulo_devuelto) cantidad_de_articulo_devuelto
	 into #limpiar
from #Venta a

select * from #limpiar

drop table #Venta,#limpiar