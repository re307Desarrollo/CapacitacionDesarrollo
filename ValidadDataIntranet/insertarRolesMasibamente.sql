declare 
	@UserId varchar(max) = '0ae3b52c-0dd9-48ec-af14-b8b1aa8e738b'

insert into AspNetUserRoles
select 
	@UserId
	,a.Id
from AspNetRoles a
where 1 = 1
	and a.[Name] like '%CD-LI:%'
	and not exists (select * from AspNetUserRoles c
					where 1 = 1
						and c.UserId = @UserId
						and c.RoleId = a.Id)

return
	select 
		* 
	from AspNetUsers a
		left outer join Maestro_Areas b
		on a.Maestro_AreasId = b.Id
	where 1 = 1
		--and b.Nombre = 'Mesa de Control'
		and a.Email like '%entidad1%'
		and a.EmailConfirmed = 1