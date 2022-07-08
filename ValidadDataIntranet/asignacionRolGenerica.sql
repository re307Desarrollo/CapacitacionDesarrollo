--select 
--	c.[Name]
--from aspnetUsers a
--	left outer join aspnetUserRoles b
--	on b.userid = a.id
--	left outer join aspnetRoles c
--	on c.id = b.roleId
--where 1 = 1
--	and a.Nombres like '%Berenice%'
--	and c.[Name] like '%CD-LI:%'

select 
	a.Id
	,REPLACE(c.[Name],'CD-LD: ','')Nombre
	into #RolesCDLI
from aspnetUsers a
	left outer join aspnetUserRoles b
	on b.userid = a.id
	left outer join aspnetRoles c
	on c.id = b.roleId
where 1 = 1
	--and a.Nombres like '%Berenice%'
	and a.Email = 'flopezgo@televisa.com.mx'
	and c.[Name] like '%CD-LD:%'

--insert into AspNetUserRoles
select 
	--'1e73b0de-704d-417c-a196-3f279cbc95be'
	--,a.Id,
	REPLACE(a.[Name],'CD-LD: ','')Nombre
from AspNetRoles a
where 1 = 1
	and a.[Name] like '%CD-LD:%'
	and REPLACE(a.[Name] ,'CD-LD: ','') in (select b.Nombre from #RolesCDLI b)

drop table #RolesCDLI