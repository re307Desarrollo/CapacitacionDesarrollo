declare
	@NC varchar(max) = '44973,39142,27928,9765,102417,16255,'
	,@Oracle varchar(max) = '190355,50141,192467,192976,1890367,191380,';

create table #NCs(
	NC varchar(max)
	,Oracle int
)

while( LEN(@NC)>1)
begin
	insert into #NCs
	select
		SUBSTRING(@NC,0,CHARINDEX(',',@NC,0))
		,CONVERT(int,SUBSTRING(@Oracle,0,CHARINDEX(',',@Oracle,0)))

	set @NC = SUBSTRING(@NC,CHARINDEX(',',@NC,0)+1,LEN(@NC))
	set @Oracle = SUBSTRING(@Oracle,CHARINDEX(',',@Oracle,0)+1,LEN(@Oracle))
end

select * from #NCs

select * from ControlDocumental_LI a
where 1 = 1
	and exists (select * from #NCs b
				where 1 = 1
					and b.NC = a.Folio
					and b.Oracle = a.Oracle)

select * from ControlDocumental_LI_Detalle a
where 1 = 1
	and a.ControlDocumental_LI_Id in (select a.Id from ControlDocumental_LI a
										where 1 = 1
											and exists (select * from #NCs b
														where 1 = 1
															and b.NC = a.Folio
															and b.Oracle = a.Oracle))

drop table #NCs
return
--27928

select * from ControlDocumental_LI a
where 1 = 1
	and folio = '27928'