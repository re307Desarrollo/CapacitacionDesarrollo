insert into Control_Entregas_Usuarios
select top 1
	a.Id+1
	,'allan.hernadez'
	,'allan.hernadez.2000'
	,a.Nivel
	,'ALLAN JAIR HERNANDEZ CAMACHO'
	,0
	--,'Control Documental Devoluciones'
	,'Control Documental Facturas'
from Control_Entregas_Usuarios a
where 1 = 1
	and a.Id = 238
order by a.Id desc

select top 2
	*
	--delete a
from Control_Entregas_Usuarios a
where 1 = 1
	and a.Id = 239
order by a.Id desc

select
	a.Nombre
	,a.Usuario
	,a.Contraseña
	--delete a
from Control_Entregas_Usuarios a
where 1 = 1
	and a.Id in (238,239)
	and a.Tipo_Documento = 'Control Documental Devoluciones'
order by a.Id desc