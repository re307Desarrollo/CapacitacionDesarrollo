create table #VentaCF(
	Fecha date,
RET varchar(max),
STR_ID int,
UPC varchar(max),
Venta_U int,
Venta_$ float,
Inventario varchar(max),

)

--BULK INSERT #VentaWalmart FROM 'H:\Desarrollo\AuditoriaVenta\8.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
BULK INSERT #VentaCF FROM 'H:\Desarrollo\Venta CityFresko\CIF_D202202_6.csv' WITH (FIELDTERMINATOR= ',',FIRSTROW = 2);



	--Fecha que Vamos a extraer la informacion 
	select distinct A.FECHA
	into #data
	from Z_VE_Cityfresko A
	where 1=1
	and A.FECHA in (select distinct Fecha from #VentaCF)


	--Eliminamos 
	delete a from Z_VE_CityFresko a
	where 1=1
	and a.FECHA in(select * from #data)

insert into Z_VE_CityFresko
select 
	'VENT'
	,a.Fecha
	,'1'
	,a.STR_ID
	,a.UPC
	,a.Venta_U
	,a.Venta_$
	,1
from #VentaCF a
where 1 = 1
	and a.Venta_U is not null
	and a.UPC is not null
order by a.Fecha desc

select a.Fecha,SUM(a.Venta_U)piezas,SUM(a.Venta_$)venta from #VentaCF a
where 1 = 1
group by a.Fecha
order by a.Fecha desc


select a.Fecha,SUM(a.CANTIDAD)piezas,SUM(a.VENTA)venta from Z_VE_Cityfresko a
where 1 = 1
	and a.FECHA in (select b.Fecha from #VentaCF b)
group by a.Fecha
order by a.Fecha desc

select * from Z_VE_Cityfresko

--drop table #VentaCF