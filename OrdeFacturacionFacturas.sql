declare
	@IdOrdenFacturacion_Documentos_Procesar int = 0

while exists(select top 1 * from OrdenFacturacion_Documentos a
			 where 1 = 1
				and a.IsProcessed = 0
			)
begin
	set @IdOrdenFacturacion_Documentos_Procesar = (select top 1 a.Id from OrdenFacturacion_Documentos a
													 where 1 = 1
														and a.IsProcessed = 0
													)

	

	update a
		set
			a.IsProcessed = 1
	from OrdenFacturacion_Documentos a
	where 1 = 1
		and a.Id = @IdOrdenFacturacion_Documentos_Procesar
end

select * from OrdenFacturacion_Documentos

return
update a
	set
		a.IsProcessed = 0
from OrdenFacturacion_Documentos a

--truncate table OrdenFacturacion_Documentos

--select top 1000
--	a.*
--	into #Control_Entregas_Concentrado
--from Control_Entregas_Concentrado a
--	left outer join E_Carta_de_Rutas b
--	on a.No_Cliente = b.No_Cliente
--where 1 = 1
--	and a.Tipo_Documento = 'Factura'
--	and a.Operador_Logistico like '%CEDI GDL%'
--	--and b.Zona like 'CEDI GDL%'

--insert into OrdenFacturacion_Documentos
--select top 10
--	null
--	,a.No_Cliente
--	,a.Docto_Num
--	,a.Tipo_Documento
--	,'LD'
--	,0
--from #Control_Entregas_Concentrado a
--group by 
--	a.No_Cliente
--	,a.Docto_Num
--	,a.Tipo_Documento



--drop table #Control_Entregas_Concentrado