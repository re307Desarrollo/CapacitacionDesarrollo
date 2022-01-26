create table #FoliosSolicitados(
	Folio varchar(max)
)

BULK INSERT #FoliosSolicitados FROM 'H:\Desarrollo\Devolucion Sanborns\FoliosSolicitados.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);

select * from #FoliosSolicitados

select * from Z_DV_Sanborns a
where 1 = 1
	--and a.Sucursal in ('1064','1130','1135')
	--and CONVERT(date,a.FechaSubida) >= '2022-01-01'
	--and CONVERT(date,a.FechaSubida) <= CONVERT(date,GETDATE())
	and a.Devolucion in (select a.Folio from #FoliosSolicitados a)
order by a.FechaSubida desc, convert(int,a.Sucursal) desc

select * from Z_DV_Sanborns_DescargaIncompleta a
where 1 = 1
	--and a.Sucursal in ('1064','1130','1135')
	--and CONVERT(date,a.FechaSubida) >= '2022-01-01'
	--and CONVERT(date,a.FechaSubida) <= CONVERT(date,GETDATE())
	and a.Devolucion in (select a.Folio from #FoliosSolicitados a)
order by a.FechaSubida desc, convert(int,a.Sucursal) desc


drop table 
	#FoliosSolicitados