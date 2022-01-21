create table #VentaWalmart(
	Fecha date
	,Unidades float
)

--BULK INSERT #VentaWalmart FROM 'H:\Desarrollo\AuditoriaVenta\8.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
BULK INSERT #VentaWalmart FROM 'H:\Desarrollo\AuditoriaVenta\11.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
BULK INSERT #VentaWalmart FROM 'H:\Desarrollo\AuditoriaVenta\12-21.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
BULK INSERT #VentaWalmart FROM 'H:\Desarrollo\AuditoriaVenta\01-22.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);

select 
	a.Fecha
	,SUM(a.Unidades)Unidades
	into #Z_VE_Walmart
from Z_VE_Walmart a
where 1 = 1
	and a.Fecha >= '2021-11-01'
	--and a.Fecha < '2021-10-01'
group by a.Fecha

select 
	a.Fecha FechaBD
	,b.Fecha Portal
	,a.Unidades UnidadesBD
	,b.Unidades UnidadesPortal
	,case
		when (a.Unidades - b.Unidades)=0 then 'Sin diferencia'
		when (a.Unidades - b.Unidades)>0 then convert(varchar,(a.Unidades - b.Unidades))
		when (a.Unidades - b.Unidades)<0 then convert(varchar,(a.Unidades - b.Unidades))
	end Diferencia
from #Z_VE_Walmart a
	left outer join #VentaWalmart b
	on b.Fecha = a.Fecha
where 1 = 1
order by a.Fecha desc

--select * from #VentaWalmart a

drop table #VentaWalmart, 
			#Z_VE_Walmart--, #Distinct_VentaWalmart