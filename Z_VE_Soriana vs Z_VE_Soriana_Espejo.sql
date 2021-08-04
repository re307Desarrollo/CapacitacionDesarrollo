--drop table #Fechas_y_Banderas
select distinct Fecha, Bandera
into #Fechas_y_Banderas
from Z_VE_Soriana
where 1 = 1
	and Fecha >= '2021-01-01'
order by Fecha asc, Bandera asc

insert into #Fechas_y_Banderas
select distinct Fecha, Bandera
from Z_VE_Soriana_Espejo a
where 1 = 1
	and Fecha >= '2021-01-01'
	and not exists (select distinct Fecha, Bandera from #Fechas_y_Banderas b
		where 1 = 1
			and a.Fecha = b.Fecha
			and a.Bandera = b.Bandera)
order by Fecha asc, Bandera asc

--drop table #Z_VE_Soriana
select distinct Fecha, Bandera, sum(Unidades) Unidades
into #Z_VE_Soriana
from Z_VE_Soriana
where 1 = 1
	and Fecha >= '2021-01-01'
group by
	Fecha, Bandera
order by Fecha asc, Bandera asc

--drop table #Z_VE_Soriana_Espejo
select distinct Fecha, Bandera, sum(Unidades) Unidades
into #Z_VE_Soriana_Espejo
from Z_VE_Soriana_Espejo
where 1 = 1
	and Fecha >= '2021-01-01'
group by
	Fecha, Bandera
order by Fecha asc, Bandera asc

--select * from #Z_VE_Soriana_Espejo
--order by Fecha, Bandera


select 
	 a.* 
	,b.Unidades as Unidades_Z_VE_Soriana
	,c.Unidades as Unidades_Z_VE_Soriana_Espejo
from #Fechas_y_Banderas a
	
	left outer join #Z_VE_Soriana b
	on a.Fecha = b.Fecha
	and a.Bandera = b.Bandera

	left outer join #Z_VE_Soriana_Espejo c
	on a.Fecha = c.Fecha
	and a.Bandera = c.Bandera
where 1 = 1
order by Fecha asc, Bandera asc


drop table #Fechas_y_Banderas,#Z_VE_Soriana,#Z_VE_Soriana_Espejo