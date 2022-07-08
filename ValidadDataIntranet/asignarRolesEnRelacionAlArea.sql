select
	a.Id
	,a.Email
	,a.Nombres
from AspNetUsers a
	left outer join Maestro_Areas b
	on b.Id = a.Maestro_AreasId
where 1 = 1
	and b.Nombre = 'Distribución'
	and a.EmailConfirmed = 1
	and exists (select*from AspNetUserRoles c
					left outer join AspNetRoles d
					on c.RoleId = d.Id
				where 1 = 1
					and c.UserId = a.Id
					and d.[Name] like '%Seguimiento%'
				)