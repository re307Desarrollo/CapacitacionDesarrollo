declare
	@NC varchar(max) = '0110079330,'

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

select 'Z_DV_Pendientes_Walmart' tabla
select * from Z_DV_Pendientes_Walmart a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.FechaRecibo desc

select 'Z_DV_Pendientes_Walmart_DescargaIncompleta' tabla
select * from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.FechaRecibo desc

select a.Folio, SUM(a.DET_ImporteTotal) from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	and a.Folio in (select * from #NCs)
group by a.Folio

select 'Z_DV_Pagadas_Walmart' tabla
select * from Z_DV_Pagadas_Walmart a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.FechaPago desc

select 'Z_DV_Pagadas_Walmart_DescargaIncompleta' tabla
select * from Z_DV_Pagadas_Walmart_DescargaIncompleta a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.FechaPago desc

drop table #NCs

return

--insert into Z_DV_Pendientes_Walmart
--select 
--	* 
--from Z_DV_Pendientes_Walmart_DescargaIncompleta a
--where 1 = 1
--	and a.Folio = '0110079330'

