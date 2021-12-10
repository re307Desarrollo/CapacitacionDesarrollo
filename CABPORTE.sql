declare
	@IdOrdenFacturacionProcesar int = 0
	,@IdOrdenFacturacionProcesar_Detalle int = 0 
	--,@LetraSerie varchar(max) = 'A'

create table #Campote(
	campote varchar(max)
)
select --top 3
	a.Id
	,ISNULL(a.Serie,'SERIE') SERIE
	,isnull(a.Folio,'FOLIO') FOLIO
	,isnull(FORMAT( a.FechaC,'ddMMyyyyHHmmss'),'FECHA HORA COMPROBANTE') FECHAHORACOMP
	,ISNULL(b.Clave,'FO') FO
	,ISNULL(a.CondPago,'CONDPAGO') CONDPAGO
	,ISNULL(convert(varchar,a.SubTotal),'SUBTOTAL') SUBTOTAL
	,ISNULL(convert(varchar,a.Descuento),'DESCUENTO') DESCUENTO
	,ISNULL(c.Clave,'MON') MON
	,ISNULL(a.TipoCambio,'TIPOCAMBIO') TIPOCAMBIO
	,ISNULL(CONVERT(varchar,a.TotalFactura),'TOTFACTURA')TOTFACTURA
	,ISNULL(d.Clave,'T') T
	,ISNULL(e.Clave,'MET') MET
	,ISNULL(a.LugarExpedicion,'LUGAREXPEDICION') LUGAREXPEDICION
	,ISNULL(a.Confirmacion,'CONFI') CONFI
	--,'TI?' TI
	,ISNULL(a.RFC_E,'RFC_E') RFC_E
	,ISNULL(a.Nombre_E,'NOMBRE_E') NOMBRE_E
	,ISNULL(h.Clave,'REGIMEN') REGIMEN
	,ISNULL(a.RFC_R,'RFC_R') RFC_R
	,ISNULL(a.Nombre_R,'NOMBRE_R') NOMBRE_R
	,ISNULL(f.Clave,'RES') RES
	,ISNULL(a.NumRegIdTrib,'NUMREGIDTRI')NUMREGIDTRI
	,ISNULL(g.Clave,'USO_CFDI') USO_CFDI
	,ISNULL(CONVERT(VARCHAR,a.TOTIMPTRASLADADOS),'TOTIMPTRASLADADOS') TOTIMPTRASLADADOS
	,ISNULL(CONVERT(VARCHAR,a.TOTIMPRETENIDOS),'TOTIMPRETENIDOS') TOTIMPRETENIDOS
	,ISNULL(a.DESTINOBM,'DESTINOBM') DESTINOBM
	,convert(bit,0) Procesada
	into #Procesar_CAB
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
	on a.Maestro_OrdenFacturacion_ResidenciaFiscal_Id = f.Id
	left outer join Maestro_OrdenFacturacion_USOCFDI g
	on a.Maestro_OrdenFacturacion_USOCFDI_Id = g.Id
	left outer join Maestro_OrdenFacturacion_Regimen h
	on a.Maestro_OrdenFacturacion_Regimen_Id = h.Id
where 1 = 1
	and a.Id = 6
	--and a.IsProcessed is null
	--or a.IsProcessed = 0

--select * from #Procesar_CAB

while exists(select top 1 * from #Procesar_CAB a
			where 1 = 1
				and a.Procesada = 0)
begin
	set @IdOrdenFacturacionProcesar = (select top 1 a.Id from #Procesar_CAB a
										where 1 = 1
											and a.Procesada = 0)

	insert into #Campote
	select 
		'CABPORTE|'+a.SERIE+'|'+a.FOLIO+'|'+a.FECHAHORACOMP+
		'|'+a.FO+'|'+a.CONDPAGO+'|'+a.SUBTOTAL+'|'+a.DESCUENTO+
		'|'+a.MON+'|'+a.TIPOCAMBIO+'|'+a.TOTFACTURA+'|'+a.T+
		'|'+a.MET+'|'+a.LUGAREXPEDICION+'|'+a.CONFI+'|'+--a.TI+
		'|'+a.RFC_E+'|'+a.NOMBRE_E+'|'+a.REGIMEN+'|'+a.RFC_R+
		'|'+a.NOMBRE_R+'|'+a.RES+'|'+a.NUMREGIDTRI+'|'+a.USO_CFDI+
		'|'+a.TOTIMPTRASLADADOS+'|'+a.TOTIMPRETENIDOS+'|'+a.DESTINOBM
	from #Procesar_CAB a
	where 1 = 1
		and a.Id = @IdOrdenFacturacionProcesar

	select
		a.Id
		,a.OrdenFacturacion_CartaPorte_Cabecera_Id
		,ISNULL(a.UUID,'UUID') UUID
		into #Cabecera_CFDIsRelacionados
	from OrdenFacturacion_CartaPorte_Cabecera_CFDIsRelacionados a
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	order by a.Id

	insert into #Campote
	select 
		'CFDIREL|'+ a.UUID+'|TI'
	from #Cabecera_CFDIsRelacionados a
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	order by a.Id

	select
		a.Id
		,a.OrdenFacturacion_CartaPorte_Cabecera_Id
		,ISNULL(b.Clave,'CLAVE_PR') CLAVE_PR
		,ISNULL(a.NoIdentificacion,'NOIDENTIFICACION') NOIDENTIFICACION
		,ISNULL(CONVERT(varchar,a.Cantidad),'CANTIDAD') CANTIDAD
		,ISNULL(c.Clave,'CLA') CLA
		,ISNULL(a.Unidad_Medida,'UNIMED') UNIMED
		,ISNULL(a.Descripcion,'DESCIP') DESCIP
		,ISNULL(CONVERT(varchar,a.Valor_Unitario),'VALORUNIT') VALORUNIT
		,ISNULL(CONVERT(varchar,a.Importe),'IMPORTOTAL') IMPORTOTAL
		,ISNULL(CONVERT(varchar,a.BaseImpuesto),'BASEIMPUESTO') BASEIMPUESTO
		,ISNULL(d.Clave,'TIPOIMPUESTO') TIPOIMPUESTO
		,ISNULL(e.Clave,'FACTORIMPUESTO') FACTORIMPUESTO
		,ISNULL(CONVERT(varchar,a.PorcentajeImpuesto),'PORCENTAJEIMP') PORCENTAJEIMP
		,ISNULL(CONVERT(varchar,a.ImporteImpuesto),'IMPORTEIMPUESTO') IMPORTEIMPUESTO
		,ISNULL(f.Clave,'CALIFIMPUESTO') CALIFIMPUESTO
		,ISNULL(REPLACE(STUFF(
						(SELECT '*'  + g.Numero
						FROM OrdenFacturacion_CartaPorte_DetalleFactura_NumeroPedimento g
						WHERE g.OrdenFacturacion_CartaPorte_DetalleFactura_Id = a.Id
						FOR XML PATH('')),
						1, 2, ''),' ',''),'NUMPEDIMENTO') NUMPEDIMENTO
		,'CLAVEDELAPARTE' CLAVEDELAPARTE
		,'NUMEROIDENTILAPARTE' NUMEROIDENTILAPARTE
		,'CANTIDADPARTE' CANTIDADPARTE
		,'PARTEUNIDAD' PARTEUNIDAD
		,'DESCRIPCIONPARTE' DESCRIPCIONPARTE
		,convert(bit,0) Procesada
		into #Procesar_Detalle
	from OrdenFacturacion_CartaPorte_DetalleFactura a
		left outer join Maestro_OrdenFacturacion_ClaveProductoServicio b
		on a.Maestro_OrdenFacturacion_ClaveProductoServicio_Id = b.Id
		left outer join Maestro_OrdenFacturacion_ClaveUnidad c
		on a.Maestro_OrdenFacturacion_ClaveUnidad_Id = c.Id
		left outer join Maestro_OrdenFacturacion_TipoImpuesto d
		on a.Maestro_OrdenFacturacion_TipoImpuesto_Id = d.Id
		left outer join Maestro_OrdenFacturacion_FactorImpuesto e
		on a.Maestro_OrdenFacturacion_FactorImpuesto_Id = e.Id
		left outer join Maestro_OrdenFacturacion_CalificadorImpuesto f
		on a.Maestro_OrdenFacturacion_CalificadorImpuesto_Id = f.Id
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	order by a.Id

	while exists(select top 1 * from #Procesar_Detalle a
				where 1 = 1
					and a.Procesada = 0)
	begin
		set @IdOrdenFacturacionProcesar_Detalle = (select top 1 a.Id from #Procesar_Detalle a
													where 1 = 1
														and a.Procesada = 0)

		insert into #Campote
		select 
			'LINEAS|'+a.CLAVE_PR+'|'+a.NOIDENTIFICACION+'|'+a.CANTIDAD+
			'|'+a.CLA+'|'+a.UNIMED+'|'+a.DESCIP+'|'+a.VALORUNIT+'|'+a.IMPORTOTAL
		from #Procesar_Detalle a
		where 1 = 1
			and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
			and a.Id = @IdOrdenFacturacionProcesar_Detalle
		order by a.Id

		insert into #Campote
		select 
			'IMPUESTOSLINEAS|'+a.BASEIMPUESTO+'|'+a.TIPOIMPUESTO+'|'+a.FACTORIMPUESTO+
			'|'+a.PORCENTAJEIMP+'|'+a.IMPORTEIMPUESTO+'|'+a.CALIFIMPUESTO
		from #Procesar_Detalle a
		where 1 = 1
			and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
			and a.Id = @IdOrdenFacturacionProcesar_Detalle
		order by a.Id

		insert into #Campote
		select 
			'NUMPEDIMENTO|'+a.NUMPEDIMENTO
		from #Procesar_Detalle a
		where 1 = 1
			and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
			and a.Id = @IdOrdenFacturacionProcesar_Detalle
		order by a.Id

		insert into #Campote
		select 
			'LINEASPARES|'+'|'+'|'+'|'+'|'+'|'+'|'

		insert into #Campote
		select 
			'PARTESNUMADUANA|'

		insert into #Campote
		select 
			'LINEAS|'+'|'+'|'+'|'+'|'+'|'+'|'+'|'+'|'

		insert into #Campote
		select 
			'IMPUESTOSLINEAS|'+'|'+'|'+'|'+'|'+'|'

		insert into #Campote
		select 
			'NUMPEDIMENTO|'

		update a
			set
				a.Procesada = 1
		from #Procesar_Detalle a
		where 1 = 1
			and a.Id = @IdOrdenFacturacionProcesar_Detalle
			and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	end

	drop table #Cabecera_CFDIsRelacionados,#Procesar_Detalle

	update a
		set
			a.Procesada = 1
	from #Procesar_CAB a
	where 1 = 1
		and a.Id = @IdOrdenFacturacionProcesar

end

select * from #Campote

drop table #Procesar_CAB,#Campote