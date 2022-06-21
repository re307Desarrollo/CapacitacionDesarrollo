﻿declare 
	@NC varchar(max) = '212453,188168,'


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

select * from Z_DV_CityFresko a
where 1 = 1
	and a.FOLIO in (select * from #NCs)

select * from ControlDocumental_LI a
where 1 = 1
	and a.Folio in (select * from #NCs)

select * from ControlDocumental_LI_Detalle a
where 1 = 1
		and a.ControlDocumental_LI_Id in (
							select a.id from ControlDocumental_LI a
							where 1 = 1
								and a.Folio in (select * from #NCs)
								)
		and a.Importe_Total is null
		and a.Importe_Unitario is null

select * from Z_DV_CityFresko_Relacion_UPC_Importes a
where 1 = 1
	and a.UPC in (select a.CB from ControlDocumental_LI_Detalle a
					where 1 = 1
					and a.ControlDocumental_LI_Id in (
							select a.id from ControlDocumental_LI a
							where 1 = 1
								and a.Folio in (select * from #NCs)
								)
					and a.Importe_Total is null
					and a.Importe_Total is null
					)

drop table #NCs