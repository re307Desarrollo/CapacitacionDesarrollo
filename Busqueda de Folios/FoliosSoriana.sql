declare
	@NC varchar(max) = '35316,'


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

select * from Z_DV_Soriana a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.FechaSuida desc

select * from Z_DV_Soriana_LogDescarga a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.RowCreated_At desc

drop table #NCs
