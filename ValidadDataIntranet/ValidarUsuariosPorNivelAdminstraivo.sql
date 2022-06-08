select 
	a.ApellidoPaterno+' '+a.ApellidoMaterno+' '+a.Nombres Nombre
	,a.Email
	,(case a.EmailConfirmed
		when 1 then 'Activo'
		when 0 then 'Inactivo'
	end) Acceso
from AspNetUsers a
	left outer join AspNetUserRoles b
	on a.Id = b.UserId
	left outer join AspNetRoles c
	on b.RoleId = c.Id
where 1 = 1
	and c.[Name] = 'Solicitud de Servicio y Facturación a Editores - Facturación'
	and a.Email not in ('admin@mail.com'
						,'adesarrollo124@outlook.com'
						,'csototr@televisa.com.mx'
						,'Rsanchez@televisa.com.mx'
						,'mayragbojorges@gmail.com'
						,'mfhernandezl@televisa.com.mx'
						,'entidad1@mail.com'
						)
order by a.EmailConfirmed desc