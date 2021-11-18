insert into Control_Entregas_Usuarios
select top 1
	a.Id
	,'iomar.nava'
	,'omar.nava.1992'
	,a.Nivel
	,'Omar Nava'
	,0
	,'Control Documental Devoluciones'
	--,'Control Documental Facturas'
from Control_Entregas_Usuarios a
where 1 = 1
	and a.Id = 237
order by a.Id desc

select top 2
	*
	--delete a
from Control_Entregas_Usuarios a
where 1 = 1
	--and a.Id = 238
order by a.Id desc