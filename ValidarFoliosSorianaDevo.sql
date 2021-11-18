﻿create table #FoliosSorianSolicitados_Limpia(
	Folio varchar(max)
	,Fecha varchar(max)
	,Sucursal varchar(max)
	,Importe_Cabecero varchar(max)
	,Total_Dent varchar(max)
	,CB varchar(max)
	,Unidades int
	,CostoB varchar(max)
	,CostoN varchar(max)
)
BULK INSERT #FoliosSorianSolicitados_Limpia FROM 'H:\Desarrollo\FoliosSoriana.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);

select 
	a.Folio
	,a.Fecha
	,a.Sucursal
	,REPLACE(a.Importe_Cabecero,'-á','') Importe_Cabecero
	,a.Unidades
	,convert(float,REPLACE(REPLACE(a.CostoB,'$',''),',','')) CostoB
	,convert(float,REPLACE(REPLACE(a.CostoN,'$',''),',','')) CostoN
	into #FoliosSorianSolicitados
from #FoliosSorianSolicitados_Limpia a

select 
	 a.Folio
	 ,a.Fecha
	 ,a.Sucursal
	 ,a.Importe_Cabecero
	 ,sum(a.Unidades) Total_Unidades
	 ,sum(a.CostoN) Importe_Detalle
	 into #FoliosSorianaSolicitados
from #FoliosSorianSolicitados a
group by 
	 a.Folio
	 ,a.Fecha
	 ,a.Sucursal
	 ,a.Importe_Cabecero

--select 
--	* 
--from #FoliosSorianaSolicitados a

select  
	 a.Folio
	 ,a.FechaDev
	 ,a.Sucursal
	 ,a.Importe_Cab
	 ,sum(a.Cantidad) Total_Unidades
	 ,sum(convert(float,REPLACE(REPLACE(a.CostoN,'$',''),',',''))) Importe_Detalle
	 into #Z_DV_Soriana
from Z_DV_Soriana a
where 1 = 1
	and exists(
		select 
			* 
		from #FoliosSorianaSolicitados b
		where 1 = 1
			and a.Folio = b.Folio
			and a.FechaCalculo = b.Fecha
			and a.Sucursal = b.Sucursal
	)
group by 
	 a.Folio
	 ,a.FechaDev
	 ,a.Sucursal
	 ,a.Importe_Cab

--select * from #Z_DV_Soriana

select distinct
	a.Folio
	,a.sucursal
	,a.importe_Cab
	,a.ImporteDetalle
	into #Z_DV_Soriana_DescargaIncompleta_
from Z_DV_Soriana_DescargaIncompleta_ a
where 1 = 1
	and exists(
		select 
			* 
		from #FoliosSorianaSolicitados b
		where 1 = 1
			and a.Folio = b.Folio
			and a.Sucursal = b.sucursal
	)

--select * from #Z_DV_Soriana_DescargaIncompleta_

select 
	a.Folio
	,a.Sucursal 
	,a.Fecha
	,a.Total_Unidades
	,a.Importe_Cabecero
	,a.Importe_Detalle
	,case
		when b.Folio is not null then 'Esta en Z_DV_Soriana'
		when c.Folio is not null then 'Z_DV_Soriana_DescargaIncompleta_'
		else 'No esta'
	end Se_Encontro_En
	,case
		when b.Folio is not null then b.Folio
		when c.Folio is not null then c.Folio
		else 'No esta'
	end Folio_Tabla
	,case
		when b.Folio is not null then b.Sucursal
		when c.Folio is not null then c.sucursal
		else 'No esta'
	end Sucursal_Tabla
	,case
		when b.Folio is not null then b.FechaDev
		when c.Folio is not null then 'No cuenta con Fecha'
		else 'No esta'
	end FechaDev_Tabla
	,case
		when b.Folio is not null then convert(varchar,b.Total_Unidades)
		when c.Folio is not null then 'No cuenta con Unidades'
		else 'No esta'
	end Total_Unidades_Tabla
	,case
		when b.Folio is not null then b.Importe_Cab
		when c.Folio is not null then c.importe_Cab
		else 'No esta'
	end Importe_Cab_Tabla
	,case
		when b.Folio is not null then convert(varchar,b.Importe_Detalle)
		when c.Folio is not null then c.ImporteDetalle
		else 'No esta'
	end Importe_Detalle_Tabla
from #FoliosSorianaSolicitados a
	left outer join #Z_DV_Soriana b
	on a.Folio = b.Folio
	and a.Sucursal = b.Sucursal
	left outer join #Z_DV_Soriana_DescargaIncompleta_ c
	on a.Folio = c.Folio
	and a.Sucursal = c.sucursal
where 1 = 1


drop table #FoliosSorianSolicitados_Limpia,
			#FoliosSorianSolicitados,
			#FoliosSorianaSolicitados,
			#Z_DV_Soriana,
			#Z_DV_Soriana_DescargaIncompleta_