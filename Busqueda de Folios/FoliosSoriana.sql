declare
	@NC varchar(max) = '102417,'


create table #NCs(
	NC varchar(max)
)

while( LEN(@NC)>1)
begin
	insert into #NCs
	select
		SUBSTRING(@NC,0,CHARINDEX(',',@NC,0))

	set @NC = SUBSTRING(@NC,CHARINDEX(',',@NC,0)+1,LEN(@NC))
end

select 'Z_DV_Soriana' tabla
select * from Z_DV_Soriana a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.FechaSuida desc

select 'Z_DV_Soriana_Agrupada' tabla
select --top 1000
	a.Folio
	,a.Sucursal
	,a.FechaDev
	,COUNT(a.Descripcion) Total_Subido
	,SUM(CONVERT(float,REPLACE(REPLACE(REPLACE(a.CostoN,'$',''),',',''),'"','')))Total_Detalle
	,a.Importe_Cab
	,a.FechaSuida
from Z_DV_Soriana a
where 1 = 1
	and a.Folio in (select * from #NCs)
group by a.Folio
	,a.Sucursal
	,a.Importe_Cab
	,a.FechaDev
	,a.FechaSuida
order by a.FechaSuida desc

select 'Z_DV_Soriana_LogDescarga' tabla
select distinct a.Folio from Z_DV_Soriana_LogDescarga a
where 1 = 1
	and a.Folio in (select * from #NCs)
--order by a.RowCreated_At desc

select * from Z_DV_Soriana_LogDescarga a
where 1 = 1
	and a.Folio = '102417'

drop table #NCs
