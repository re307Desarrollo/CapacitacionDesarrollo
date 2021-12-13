﻿declare
	@IdOrdenFacturacionProcesar int = 0
	,@IdOrdenFacturacionProcesar_Detalle int = 0
	,@IdOrdenFacturacionProcesar_cPORTE_Ubicacion int = 0
	,@IdOrdenFacturacionProcesar_Cabecera_AutoTransporteFederal int = 0
	,@IdOrdenFacturacion int = 7
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
	,ISNULL(i.Clave,'TIPOIMPUESTO') TIPOIMPUESTO
	,ISNULL(j.Clave,'FACTORIMPUESTO') FACTORIMPUESTO
	,ISNULL(CONVERT(varchar,CONVERT(decimal(10,4),a.PorcentajeImpuesto)),'PORCENTAJEIMPUESTO') PORCENTAJEIMPUESTO
	,ISNULL(CONVERT(VARCHAR,a.ImporteImpuesto),'IMPORTEIMPUESTO') IMPORTEIMPUESTO
	,ISNULL(k.Clave,'T') TT
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
	left outer join Maestro_OrdenFacturacion_TipoImpuesto i
	on a.Maestro_OrdenFacturacion_TipoImpuesto_Id = i.Id
	left outer join Maestro_OrdenFacturacion_FactorImpuesto j
	on a.Maestro_OrdenFacturacion_FactorImpuesto_Id = j.Id
	left outer join Maestro_OrdenFacturacion_CalificadorImpuesto k
	on a.Maestro_OrdenFacturacion_CalificadorImpuesto_Id = k.Id
	left outer join OrdenFacturacion_CartaPorte_Cabecera_ComplementoCartaPorte l
	on l.OrdenFacturacion_CartaPorte_Cabecera_Id = a.Id
where 1 = 1
	and a.Id = @IdOrdenFacturacion
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
		'|'+a.MET+'|'+a.LUGAREXPEDICION+'|'+a.CONFI+'|'+
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
		,ISNULL(b.Clave,'TI') TI
		into #Cabecera_CFDIsRelacionados
	from OrdenFacturacion_CartaPorte_Cabecera_CFDIsRelacionados a
		left outer join Maestro_OrdenFacturacion_TipoRelacion b
		on a.Maestro_OrdenFacturacion_TipoRelacion_Id = b.Id
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	order by a.Id

	insert into #Campote
	select 
		'CFDIREL|'+ a.UUID+'|'+a.TI
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
		,ISNULL(CONVERT(varchar,CONVERT(decimal(10,4),a.PorcentajeImpuesto)),'PORCENTAJEIMP') PORCENTAJEIMP
		,ISNULL(CONVERT(varchar,a.ImporteImpuesto),'IMPORTEIMPUESTO') IMPORTEIMPUESTO
		,ISNULL(f.Clave,'CALIFIMPUESTO') CALIFIMPUESTO
		,ISNULL(REPLACE(STUFF(
						(SELECT '*'  + g.Numero
						FROM OrdenFacturacion_CartaPorte_DetalleFactura_NumeroPedimento g
						WHERE g.OrdenFacturacion_CartaPorte_DetalleFactura_Id = a.Id
						FOR XML PATH('')),
						1, 2, ''),' ',''),'NUMPEDIMENTO') NUMPEDIMENTO
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
			'LINEASPARTES|'+'|'+'|'+'|'+'|'+'|'+'|'

		insert into #Campote
		select 
			'PARTESNUMADUANA|'

		update a
			set
				a.Procesada = 1
		from #Procesar_Detalle a
		where 1 = 1
			and a.Id = @IdOrdenFacturacionProcesar_Detalle
			and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	end

	drop table #Cabecera_CFDIsRelacionados,#Procesar_Detalle

	insert into #Campote
	select 
		'IMPUESTOS|'+a.TIPOIMPUESTO+'|'+a.FACTORIMPUESTO+'|'+a.PORCENTAJEIMPUESTO+
		'|'+a.IMPORTEIMPUESTO+'|'+a.TT
	from #Procesar_CAB a
	where 1 = 1
		and a.Id = @IdOrdenFacturacionProcesar

	select 
		a.Id
		,a.OrdenFacturacion_CartaPorte_Cabecera_Id
		,ISNULL(b.Clave,'VERSION') VERSIONC
		,ISNULL(c.Clave,'SALEMERCANCIA') SALEMERCANCIA
		,ISNULL(d.Clave,'ENTRADASALIDA') ENTRADASALIDA
		,ISNULL(e.Clave,'VIAENTRADASALIDA') VIAENTRADASALIDA
		,ISNULL(CONVERT(varchar,a.TotalDistanciaRecorrida),'DISTRECORRIDACPORTE') DISTRECORRIDACPORTE
		,ISNULL(f.Clave,'CLAVETRANSPORTE') CLAVETRANSPORTE
		,ISNULL(g.Pais,'PAISORIGEN') PAISORIGEN
		into #Cabecera_ComplementoCartaPorte
	from OrdenFacturacion_CartaPorte_Cabecera_ComplementoCartaPorte a
		left outer join Maestro_OrdenFacturacion_Version b
		on a.Maestro_OrdenFacturacion_Version_Id = b.Id
		left outer join Maestro_OrdenFacturacion_TransporteInternacional c
		on a.Maestro_OrdenFacturacion_TransporteInternacional_Id = c.Id
		left outer join Maestro_OrdenFacturacion_EntradaSalidaMercancia d
		on a.Maestro_OrdenFacturacion_EntradaSalidaMercancia_Id = d.Id
		left outer join Maestro_OrdenFacturacion_ViaEntradaSalida e
		on a.Maestro_OrdenFacturacion_ViaEntradaSalida_Id = e.Id
		left outer join Maestro_OrdenFacturacion_ViaEntradaSalida f
		on a.Maestro_OrdenFacturacion_ViaEntradaSalida_Id_ClaveTransporte = f.Id
		left outer join CartaPorte_Pais g
		on a.CartaPorte_Pais_Id = g.Id
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	order by a.Id

	insert into #Campote
	select 
		'CPORTE|'+a.VERSIONC+'|'+a.SALEMERCANCIA+'|'+a.ENTRADASALIDA+
		'|'+a.VIAENTRADASALIDA+'|'+a.DISTRECORRIDACPORTE+'|'+a.CLAVETRANSPORTE+
		'|'+a.PAISORIGEN
	from #Cabecera_ComplementoCartaPorte a
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

	drop table #Cabecera_ComplementoCartaPorte
	
	select 
		a.Id
		,a.OrdenFacturacion_CartaPorte_Cabecera_Id
		,ISNULL(b.Clave,'TIPOESTACION') TIPOESTACION
		,ISNULL(CONVERT(varchar,a.DistanciaRecorrida),'DISTRECORRIDA') DISTRECORRIDA
		,ISNULL(a.Id_Origen,'IDORIGEN') IDORIGEN
		,ISNULL(a.Referencia_Origen,'RESIDENCIAFISCALREMI') RESIDENCIAFISCALREMI
		,ISNULL(c.Clave_Identificacion,'NUMESTACIONREMI') NUMESTACIONREMI
		,ISNULL(a.NombreEstacion_Origen,'NOMBREESTACIONREMI') NOMBREESTACIONREMI
		,ISNULL(d.Clave,'NAVEGACIONTRAFICOREMI') NAVEGACIONTRAFICOREMI
		,ISNULL(FORMAT( a.FechaHoraSalida_Origen,'ddMMyyyyHHmmss'),'FECHAHORADESALIDA') FECHAHORADESALIDA
		,ISNULL(a.Id_Origen,'IDDESTINO') IDDESTINO
		,ISNULL(e.Pais,'RESIDENCIAFISCALDESTINO') RESIDENCIAFISCALDESTINO
		,ISNULL(f.Clave_Identificacion,'NUMESTACIONDESTINATARIO') NUMESTACIONDESTINATARIO
		,ISNULL(a.NombreEstacion_Destino,'NOMBREESTACIONDESTINATARIO') NOMBREESTACIONDESTINATARIO
		,ISNULL(g.Clave,'NAVEGACIONTRAFICODESTINO') NAVEGACIONTRAFICODESTINO
		,ISNULL(FORMAT( a.FechaHoraLlegada_Destino,'ddMMyyyyHHmmss'),'FECHAHORADELLEGADA') FECHAHORADELLEGADA
		,ISNULL(a.Calle_Destino,'CALLE') CALLE
		,ISNULL(a.NumeroExterior_Destino,'NUMEXT') NUMEXT
		,ISNULL(a.NumeroInterior_Destino,'NUMINT') NUMINT
		,ISNULL(h.Clave,'COLONIACLAVE') COLONIACLAVE
		,ISNULL(ii.Clave,'LOCALIDAD') LOCALIDAD
		,ISNULL(a.RFC_Destino,'RFC') RFC
		,ISNULL(i.Clave,'MUNICIPIO') MUNICIPIO
		,ISNULL(j.c_Estado,'ESTADO') ESTADO
		,ISNULL(e.Pais,'PAIS') PAIS
		,ISNULL(k.Codigo_Postal,'CODIGOPOSTAL') CODIGOPOSTAL
		,ISNULL(l.Clave,'TIPOUBICACION') TIPOUBICACION
		,convert(bit,0) Procesada
		into #ComplementoCartaPorte_Ubicacion
	from OrdenFacturacion_CartaPorte_Cabecera_ComplementoCartaPorte_Ubicacion a
		left outer join Maestro_OrdenFacturacion_TipoEstacion b
		on a.Maestro_OrdenFacturacion_TipoEstacion_Id = b.Id
		left outer join CartaPorte_Estaciones c
		on a.CartaPorte_Estado_Id_Origen = c.Id
		left outer join Maestro_OrdenFacturacion_NavegacionTrafico d
		on a.Maestro_OrdenFacturacion_NavegacionTrafico_Id_Origen = d.Id
		left outer join CartaPorte_Pais e
		on a.CartaPorte_Pais_Id_Destino = e.Id
		left outer join CartaPorte_Estaciones f
		on a.CartaPorte_Estado_Id_Destino = f.Id
		left outer join Maestro_OrdenFacturacion_NavegacionTrafico g
		on a.Maestro_OrdenFacturacion_NavegacionTrafico_Id_Destino = g.Id
		left outer join CartaPorte_Colonia h
		on a.CartaPorte_Colonia_Id_Destino = h.Id
		left outer join CartaPorte_Localidad ii
		on a.CartaPorte_Localidad_Id_Destino = ii.Id
		left outer join CartaPorte_Municipio i
		on a.CartaPorte_Municipio_Id_Destino = i.Id
		left outer join CartaPorte_Estado j
		on a.CartaPorte_Estado_Id_Destino = j.Id
		left outer join CartaPorte_CodigoPostal k
		on a.CartaPorte_CodigoPostal_Id_Destino = k.Id
		left outer join Maestro_OrdenFacturacion_TipoUbicacion l
		on a.Maestro_OrdenFacturacion_TipoUbicacion_Id_Destino = l.Id
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	
	while exists(select top 1 * from #ComplementoCartaPorte_Ubicacion a
				where 1 = 1
					and a.Procesada = 0		
				)
	begin
		
		set @IdOrdenFacturacionProcesar_cPORTE_Ubicacion = (select top 1 a.Id from #ComplementoCartaPorte_Ubicacion a
													where 1 = 1
														and a.Procesada = 0)

		insert into #Campote
		select 
			'CPORTEUBIC|'+a.TIPOESTACION+'|'+a.DISTRECORRIDA+'|'+a.IDORIGEN+
			'|'+a.RESIDENCIAFISCALREMI+'|'+a.NUMESTACIONREMI+'|'+a.NOMBREESTACIONREMI+
			'|'+a.NAVEGACIONTRAFICOREMI+'|'+a.FECHAHORADESALIDA+'|'+a.IDDESTINO+
			'|'+a.RESIDENCIAFISCALDESTINO+'|'+a.NUMESTACIONDESTINATARIO+
			'|'+a.NOMBREESTACIONDESTINATARIO+'|'+a.NAVEGACIONTRAFICODESTINO+
			'|'+a.FECHAHORADELLEGADA+'|'+a.CALLE+'|'+a.NUMEXT+'|'+a.NUMINT+
			'|'+a.COLONIACLAVE+'|'+a.LOCALIDAD+'|'+a.RFC+'|'+a.MUNICIPIO+
			'|'+a.ESTADO+'|'+a.PAIS+'|'+a.CODIGOPOSTAL+'|'+a.TIPOUBICACION
		from #ComplementoCartaPorte_Ubicacion a
		where 1 = 1
			and a.Id = @IdOrdenFacturacionProcesar_cPORTE_Ubicacion
			and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

		update a
			set
				a.Procesada = 1
		from #ComplementoCartaPorte_Ubicacion a
		where 1 = 1
			and a.Id = @IdOrdenFacturacionProcesar_cPORTE_Ubicacion
			and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

	end

	select 
		a.OrdenFacturacion_CartaPorte_Cabecera_Id
		,ISNULL(CONVERT(varchar,SUM(c.Unit_Weight)),'PESOBRUTOTOTAL')PESOBRUTOTOTAL
		,ISNULL(null,'UNIDADDEPESO')UNIDADDEPESO
		,ISNULL(CONVERT(varchar,SUM(c.Unit_Weight)),'PESONETOTOTAL')PESONETOTOTAL
		,ISNULL(CONVERT(varchar,SUM(a.Cantidad)),'NUMTOTALMERCA')NUMTOTALMERCA
		,ISNULL(null,'CARGOPORTASACION')CARGOPORTASACION
		into #Procesar_Detalle_Group_CPORTEMERCAS
	from OrdenFacturacion_CartaPorte_DetalleFactura a
		left outer join Programa_Circulacion_Completo b
		on a.NoIdentificacion = b.Codigo_Barras COLLATE Modern_Spanish_CI_AS
		left outer join Maestro_Productos_Dimensiones c
		on b.ITEM = c.Item COLLATE Modern_Spanish_CI_AS
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	group by a.OrdenFacturacion_CartaPorte_Cabecera_Id

	insert into #Campote
	select 
		'CPORTEMERCAS|'+a.PESOBRUTOTOTAL+'|'+a.UNIDADDEPESO+
		'|'+a.PESONETOTOTAL+'|'+a.NUMTOTALMERCA+'|'+a.CARGOPORTASACION
	from #Procesar_Detalle_Group_CPORTEMERCAS a
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
		

	select 
		a.OrdenFacturacion_CartaPorte_Cabecera_Id
		,ISNULL(null,'BIENESTRNSP')BIENESTRNSP
		,ISNULL(null,'CLAVESTCC')CLAVESTCC
		,ISNULL(null,'DESCRIPCION')DESCRIPCION
		,ISNULL(null,'CANTIDAD')CANTIDAD
		,ISNULL(null,'CLAVEUNIDAD')CLAVEUNIDAD
		,ISNULL(null,'UNIDAD')UNIDAD
		,ISNULL(null,'DIMENCIONES')DIMENCIONES
		,ISNULL(null,'MATERIALPELIGROSO')MATERIALPELIGROSO
		,ISNULL(null,'CLAVEMATERIALPELIGROSO')CLAVEMATERIALPELIGROSO
		,ISNULL(null,'EMBALAJE')EMBALAJE
		,ISNULL(null,'DESCRIPCIONEMBALAJE')DESCRIPCIONEMBALAJE
		,ISNULL(null,'PESOENKG')PESOENKG
		,ISNULL(null,'VALORMERCANCIA')VALORMERCANCIA
		,ISNULL(null,'MONEDA')MONEDA
		,ISNULL(null,'FRACCIONARANCELARIA')FRACCIONARANCELARIA
		,ISNULL(null,'UUIDCOMERCIOEXT')UUIDCOMERCIOEXT
		,ISNULL(null,'UNIDADPESO')UNIDADPESO
		,ISNULL(null,'PESOBRUTO')PESOBRUTO
		,ISNULL(null,'PESONETO')PESONETO
		,ISNULL(null,'PESOTARA')PESOTARA--DIFERENCIA ENTRE PESO NETO Y BRUTO
		,ISNULL(null,'NUMPIEZAS')NUMPIEZAS
		,ISNULL(null,'PEDIMENTO')PEDIMENTO
		,convert(bit,0) Procesada
		into #Procesar_Detalle_Group_CPORTEMERCA
	from OrdenFacturacion_CartaPorte_DetalleFactura a
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
	group by a.OrdenFacturacion_CartaPorte_Cabecera_Id
		
	insert into #Campote
	select 
		'CPORTEMERCA|'+a.BIENESTRNSP+'|'+a.CLAVESTCC+'|'+a.DESCRIPCION+
		'|'+a.CANTIDAD+'|'+a.CLAVEUNIDAD+'|'+a.UNIDAD+'|'+a.DIMENCIONES+
		'|'+a.MATERIALPELIGROSO+'|'+a.CLAVEMATERIALPELIGROSO+'|'+a.EMBALAJE+
		'|'+a.DESCRIPCIONEMBALAJE+'|'+a.PESOENKG+'|'+a.VALORMERCANCIA+
		'|'+a.MONEDA+'|'+a.FRACCIONARANCELARIA+'|'+a.UUIDCOMERCIOEXT+
		'|'+a.UNIDADPESO+'|'+a.PESOBRUTO+'|'+a.PESONETO+'|'+a.PESOTARA+
		'|'+a.NUMPIEZAS+'|'+a.PEDIMENTO
	from #Procesar_Detalle_Group_CPORTEMERCA a
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

	--while exists()

	select
		a.Id
		,a.OrdenFacturacion_CartaPorte_Cabecera_Id
		,ISNULL(b.Clave,'PERMSCT')PERMSCT
		,ISNULL(a.NumPermisoSCT,'NUMPERMSCT')NUMPERMSCT
		,ISNULL(a.NombreAseguradora,'NOMBREASEGURADORA')NOMBREASEGURADORA
		,ISNULL(a.NumPolizaSeguro,'NUMEROPOLIZASEGURO')NUMEROPOLIZASEGURO
		,ISNULL(a.ConfigVehicular,'CONFIGURACIONVEICULAR')CONFIGURACIONVEICULAR
		,ISNULL(a.PlacaVM,'PLACAMV')PLACAMV
		,ISNULL(CONVERT(varchar,a.AnioModeloVM),'ANIOMODELOVM')ANIOMODELOVM
		,ISNULL(a.AseguraRespCivil,'ASEGURARESPCIVIL')ASEGURARESPCIVIL
		,ISNULL(a.PolizaRespCivil,'POILIZARESPCIVIL')POILIZARESPCIVIL
		,ISNULL(a.AseguraMedAmbiente,'ASEGURAMEDAMBIENTE')ASEGURAMEDAMBIENTE
		,ISNULL(a.PolizaMedAmbiente,'POLIZAMEDAMBIENTE')POLIZAMEDAMBIENTE
		,ISNULL(a.AseguraCarga,'ASEGURACARGA')ASEGURACARGA
		,ISNULL(a.PolizaCarga,'POLIZACARGA')POLIZACARGA
		,ISNULL(CONVERT(varchar,a.PrimaSeguro),'PRIMASEGURO')PRIMASEGURO
		into #Cabecera_AutoTransporteFederal
	from OrdenFacturacion_CartaPorte_Cabecera_AutoTransporteFederal a
		left outer join CartaPorte_TipoPermiso b
		on a.CartaPorte_TipoPermiso_Id = b.Id
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

	insert into #Campote
	select 
		'CPORTETRANSFED|'+a.PERMSCT+'|'+a.NUMPERMSCT+'|'+a.NOMBREASEGURADORA+
		'|'+a.NUMEROPOLIZASEGURO+'|'+a.CONFIGURACIONVEICULAR+'|'+a.PLACAMV+
		'|'+a.ANIOMODELOVM+'|'+a.ASEGURARESPCIVIL+'|'+a.POILIZARESPCIVIL+
		'|'+a.ASEGURAMEDAMBIENTE+'|'+a.POLIZAMEDAMBIENTE+'|'+a.ASEGURACARGA+
		'|'+a.POLIZACARGA+'|'+a.PRIMASEGURO
	from #Cabecera_AutoTransporteFederal a
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar

	
	set @IdOrdenFacturacionProcesar_Cabecera_AutoTransporteFederal =(select 
																		a.Id
																	from OrdenFacturacion_CartaPorte_Cabecera_AutoTransporteFederal a
																	where 1 = 1
																		and a.OrdenFacturacion_CartaPorte_Cabecera_Id = @IdOrdenFacturacionProcesar
																)

	select 
		a.Id
		,a.OrdenFacturacion_CartaPorte_Cabecera_AutoTransporteFederal_Id
		,ISNULL(a.Placa_Remolque,'PLACAREMOLQUE')PLACAREMOLQUE
		,ISNULL(b.Clave,'TIPOREMOLQUE')TIPOREMOLQUE
		,convert(bit,0) Procesada
		into #Cabecera_AutoTransporteFederal_Remolque
	from OrdenFacturacion_CartaPorte_Cabecera_AutoTransporteFederal_Remolque a
		left outer join CartaPorte_TipoRemolque b
		on a.CartaPorte_TipoRemolque_Id = b.Id
	where 1 = 1
		and a.OrdenFacturacion_CartaPorte_Cabecera_AutoTransporteFederal_Id = @IdOrdenFacturacionProcesar_Cabecera_AutoTransporteFederal

	--while exists(select top 1 * from #Cabecera_AutoTransporteFederal_Remolque a
	--			where 1 = 1
	--				and a.Procesada = 0
	--			)
	--begin
	--end
	drop table #Cabecera_AutoTransporteFederal_Remolque

	drop table #ComplementoCartaPorte_Ubicacion
			  ,#Procesar_Detalle_Group_CPORTEMERCAS
			  ,#Procesar_Detalle_Group_CPORTEMERCA
			  ,#Cabecera_AutoTransporteFederal

	update a
		set
			a.Procesada = 1
	from #Procesar_CAB a
	where 1 = 1
		and a.Id = @IdOrdenFacturacionProcesar

	--drop table #Cabecera_ComplementoCartaPorte

end

select * from #Campote

drop table #Procesar_CAB,#Campote