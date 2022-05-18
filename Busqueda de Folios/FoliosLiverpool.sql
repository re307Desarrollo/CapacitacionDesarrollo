declare
	@NC varchar(max) = '4209161332,4212337533,4209124110,4209065442,4210033773,4210959073,4210224014,4209750009,4211209932,4207849662,4209350186,4211325608,4209355755,4209225478,4210030419,4209481159,4209569832,4209074184,4210331632,4211198831,4209220825,4208566860,4210715148,4210351091,4207323375,4211201223,4210351046,4209422257,4208983134,4210178374,4209082722,4208273105,4207567366,4208897852,4209569708,4211207458,4210575602,4211206679,480903073142,'--'0111048140,0111048142,0138455148,0139452179,0112531694,0112531692,''0110546720,'

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

drop table #NCs
			,#SiEstan