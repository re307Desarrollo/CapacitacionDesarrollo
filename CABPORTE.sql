declare
	@IdOrdenFacturacionProcesar int = 0
	,@IdOrdenFacturacionProcesar_Detalle int = 0 
	,@LetraSerie varchar(max) = 'A'

create table #Campote(
	campote varchar(max)
)

select 
	a.Id
	,convert(bit,0) Procesada
	into #Procesar
from OrdenFacturacion_CartaPorte_Cabecera a

while exists(select top 1 * from #Procesar a
			where 1 = 1
				and a.Procesada = 0)
begin

	set @IdOrdenFacturacionProcesar = (select top 1 a.Id from #Procesar a
										where 1 = 1
											and a.Procesada = 0)

	--select 'AsignacionCab de '+convert(varchar,@IdOrdenFacturacionProcesar)
	insert into #Campote
	select 
		'CABPORTE|'+@LetraSerie+a.Serie+
		'|'+ISNULL(a.Folio,'FOLIO')+'|'+isnull(FORMAT( a.FechaC,'ddMMyyyyHHmmss'),'F/HCOMPROBANTE')+
		'|'+b.Clave+'|'+ISNULL(a.CondPago,'')+'|'+ISNULL(convert(varchar,a.SubTotal),'')+
		'|'+ISNULL(convert(varchar,a.Descuento),'')+'|'+c.Clave+'|'+isnull(a.TipoCambio,'TIPOCAMBIO')+
		'|'+ISNULL(convert(varchar,a.TotalFactura),'')+'|'+d.Clave+'|'+e.Clave+'|'+isnull(a.LugarExpedicion,'')+
		'|'+ISNULL(a.Confirmacion,'')+'|TI?|'+ISNULL(a.RFC_E,'')+'|'+ISNULL(a.Nombre_E,'')+'|'+isnull(f.Clave,'')+
		'|'+ISNULL(a.NumRegIdTrib,'')+'|'+g.Clave+'|'+ISNULL(convert(varchar,a.TOTIMPTRASLADADOS),'	')+
		'|'+ISNULL(convert(varchar,a.TOTIMPRETENIDOS),'')+'|'+isnull(a.DESTINOBM,'')
	from OrdenFacturacion_CartaPorte_Cabecera a
		left outer join Maestro_OrdenFacturacion_FormaPago b
		on a.Maestro_OrdenFacturacion_FormaPago_Id = b.Id
		left outer join Maestro_OrdenFacturacion_Moneda c
		on a.Maestro_OrdenFacturacion_Moneda_Id = c.Id
		left outer join Maestro_OrdenFacturacion_TipoComprobante d
		on a.Maestro_OrdenFacturacion_TipoComprobante_Id = d.Id
		left outer join Maestro_OrdenFacturacion_MetodoPago e
		on a.Maestro_OrdenFacturacion_MetodoPago_Id = e.Id
		left outer join Maestro_OrdenFacturacion_ResidenciaFiscal f
		on a.Maestro_OrdenFacturacion_Regimen_Id = f.Id
		left outer join Maestro_OrdenFacturacion_USOCFDI g
		on a.Maestro_OrdenFacturacion_USOCFDI_Id = g.Id
	where 1 = 1
		and a.Id = @IdOrdenFacturacionProcesar


	--select 'AsignacionCab de CFDIREL '+convert(varchar,@IdOrdenFacturacionProcesar)

	insert into #Campote
	select 
		'CFDIREL|'+convert(varchar,a.UUID)+'|TI?'
	from OrdenFacturacion_CartaPorte_CFDIsRelacionados a
		left outer join Maestro_OrdenFacturacion_TipoRelacion b
		on a.Maestro_OrdenFacturacion_TipoRelacion_Id = b.Id
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

	select 
		a.Id
		,a.OrdenFacturacion_CartaPorte_Cabecera_Id
		,convert(bit,0) Procesada
		into #Procesar_Detalle
	from OrdenFacturacion_CartaPorte_DetalleFactura a
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

	while exists(select top 1 * from #Procesar_Detalle a
				where 1 = 1
					and a.Procesada = 0)
	begin
		set @IdOrdenFacturacionProcesar_Detalle = (select top 1 a.Id from #Procesar_Detalle a
													where 1 = 1
														and a.Procesada = 0)
		insert into #Campote
		select 
			'LINEAS|'+b.Clave+'|'+a.NoIdentificacion+'|'+convert(varchar,a.Cantidad)+'|'+c.Clave+
			'|'+isnull(a.Unidad_Medida,'')+'|'+a.Descripcion+'|'+CONVERT(varchar,a.Valor_Unitario)
		from OrdenFacturacion_CartaPorte_DetalleFactura a
			left outer join Maestro_OrdenFacturacion_ClaveProductoServicio b
			on a.Maestro_OrdenFacturacion_ClaveProductoServicio_Id = b.Id
			left outer join Maestro_OrdenFacturacion_ClaveUnidad c
			on a.Maestro_OrdenFacturacion_ClaveUnidad_Id = c.Id
		where 1 = 1
			and a.Id = @IdOrdenFacturacionProcesar_Detalle
			and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

		--select 
		--	'IMPUESTOSLINEAS|'+a.BaseImpuesto+'|'+b.Clave+'|'
		--from OrdenFacturacion_CartaPorte_DetalleFactura a
		--	left outer join Maestro_OrdenFacturacion_TipoImpuesto b
		--	on a.Maestro_OrdenFacturacion_TipoImpuesto_Id = b.Id
		--	left outer join Maestro_Ordenfact
		--where 1 = 1
		--	and a.Id = @IdOrdenFacturacionProcesar_Detalle
		--	and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

		insert into #Campote values
		('IMPUESTOSLINEAS|20|002|Tasa|0.160000|3.2|T')

		insert into #Campote values
		('NUMPEDIMENTO|10 47 3807 8003832*10 47 3807 8003832*10 47 3807 8003832')

		update a
			set
				a.Procesada = 1
		from #Procesar_Detalle a
		where 1 = 1
			and a.Id = @IdOrdenFacturacionProcesar_Detalle
			and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

	end

	drop table #Procesar_Detalle

	update a
		set
			a.Procesada = 1
	from #Procesar a
	where 1 = 1
		and a.Id = @IdOrdenFacturacionProcesar
		
end

select * from #Campote

drop table #Campote,#Procesar--,#Procesar_Detalle

return
select * from OrdenFacturacion_CartaPorte_Cabecera
select * from OrdenFacturacion_CartaPorte_DetalleFactura
select * from OrdenFacturacion_CartaPorte_CFDIsRelacionados

select REPLACE(REPLACE(convert(varchar,GETDATE(),20),'-',''),':','')
select FORMAT( GETDATE(),'ddMMyyyyHHmmss')

insert into OrdenFacturacion_CartaPorte_CFDIsRelacionados
select 
	1
	,3
	,3
	,'6a66df3b-c91b-477c-9b54-e6b11ca624fc'
	,GETDATE()