declare
	@NC varchar(max) = '4215333907,4214498218,'

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


select * from Z_DV_Liverpool a
where 1 = 1
	and a.NroReferen in (select b.NC from #NCs b)


select distinct a.NroReferen, a.FechaCreac from Z_DV_Liverpool a
where 1 = 1
	and a.NroReferen in (select b.NC from #NCs b)
order by a.FechaCreac desc

select a.NroReferen into #SiEstan from Z_DV_Liverpool a
where 1 = 1
	and a.NroReferen in (select b.NC from #NCs b)
order by a.FechaCreac desc

select distinct a.NC from #NCs a
where 1 = 1
	and a.NC not in (select b.NroReferen from #SiEstan b)

select * from ControlDocumental_LI a
where 1 = 1
	and a.Folio in (select b.NC from #NCs b)

drop table #NCs
			,#SiEstan