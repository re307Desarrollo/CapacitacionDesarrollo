select distinct * from ControlDocumental_LI a
where 1 = 1
	and a.Oracle = 92374

select distinct a.Folio,a.Oracle from ControlDocumental_LI a
where 1 = 1
	and a.Oracle = 92374

select * from ControlDocumental_LI a
where 1 = 1
	and a.Oracle = 92374
	and a.Folio = '187024'

update a 
	set a.Oracle = 150168
from ControlDocumental_LI a
where 1 = 1
	and a.Oracle = 92374
	and a.Folio = '187024'
	
	select top 1000 * from ControlDocumental_LI_Detalle