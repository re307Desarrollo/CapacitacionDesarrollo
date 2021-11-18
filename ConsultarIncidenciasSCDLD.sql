select 'Matriz_Seguimiento_Control_Documental_LD_IsIssue_First_Filter_Log' 
select 
e.Den_Comer [Operador Logístico]
,a.Oracle
,a.Documento
,c.[Name] Motivo
,d.Nombres + ' ' + d.ApellidoPaterno + ' ' + d.ApellidoMaterno [Nombre Usuario]
,convert(varchar,a.RowCreated_At,20) [Fecha y Hora ]
from Matriz_Seguimiento_Control_Documental_LD_IsIssue_First_Filter_Log a
		left outer join Matriz_IsIssue_Catalogo c
		on a.Matriz_IsIssue_CatalogoId = c.Id
		left outer join AspNetUsers_Alternative d 
		on a.UserId = d.Id
	left outer join E_Carta_de_Rutas e
	on a.Oracle = e.No_Cliente
	where 1 = 1
		--and Documento = @documento
	order by a.RowCreated_At desc,a.Oracle,a.Documento asc
select 'Matriz_Seguimiento_Control_Documental_LD_IsIssue_Reversed_Log'
select
e.Den_Comer [Operador Logístico]
,a.Oracle
,a.Documento
,c.[Name] Motivo
,d.Nombres + ' ' + d.ApellidoPaterno + ' ' + d.ApellidoMaterno [Nombre Usuario]
,convert(varchar,a.RowCreated_At,20) [Fecha y Hora ]
from Matriz_Seguimiento_Control_Documental_LD_IsIssue_Reversed_Log a
	left outer join Matriz_IsIssue_Catalogo c
	on a.Matriz_IsIssue_CatalogoId = c.Id
	left outer join AspNetUsers_Alternative d 
	on a.UserId = d.Id
	left outer join E_Carta_de_Rutas e
	on a.Oracle = e.No_Cliente
where 1 = 1
	--and Documento = @documento
order by a.RowCreated_At desc,a.Oracle,a.Documento asc