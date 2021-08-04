declare
	@FechaSubida date = DATEADD(dd,0,GETDATE())--'2020-10-13'

select 
	* 
from Subidas_Log
where 1 = 1
and SP LIKE '%Devoluciones%'
and convert(date,[Ultima_Actualización]) = @FechaSubida
--and Tabla like '%7ELEVEN%'
order by Ultima_Actualización 
return

select 
	* 
from Subidas_Log
where 1 = 1
and SP LIKE '%Devoluciones%'
order by Ultima_Actualización desc