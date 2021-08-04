declare
	--Validacion Pagos Toks
	 @Pagos int = 0
	,@FechaPagos date = '2021-06-23'
	--,@Pago int = '1219432'
	,@Toks int = 0

	
	--Validación Devoluciosnes
	,@Devoluciones int = 1
	,@FechaDevolucion int = 1
	--,@menosDias int = -1
	,@FechaSubida date = DATEADD(dd,0,GETDATE())-- '2020-09-07'
	--,@FechaSubida date = '2021-01-26'
	--Cadena
	,@Walmart int = 0
	,@Sanbons int = 0
	,@Liverpool int = 0
	,@Liverpool_SKU int = 0
	,@Chedraui_24Hras int = 0--
	,@Chedraui_Sucursal int = 0--
	,@Cityfresko int = 0
	,@HEB int = 0
	,@OXXO int = 0
	,@Soriana int = 0
	,@7eleven int = 0
	,@7eleven_Cargos int = 0---



	----Acuses de Recibo
	--,@AcusesRecibo int = 1
	--,@FechaAR date = '2019-11-27'
	----PORTALES Acuses de Recibo
	--,@Waltma_AR int = 0
	--,@Soriana_AR int = 0
	--,@CityFresko_AR int = 0
	--,@HEB_AR int = 0
	--,@OXXO_AR int = 0
	--,@OXXO_Detalle_AR int = 0

if @Devoluciones =1
begin
	if @HEB = 1
		begin
			SELECT 
				FolioDev,
				Sucursal,
				CodigoBarras,
				count (Descripcion)Contador
			FROM Z_DV_HEB
			where 1=1
			and CONVERT(date,FechaSubida) = @FechaSubida
			group by FolioDev,
					 Sucursal,
					 CodigoBarras
			having COUNT(Descripcion) > 1
			order by Contador desc
	end

	if @Sanbons = 1
	begin
			SELECT 
			 Sucursal
			,Devolucion
			,SKU
			,CB
				,COUNT (Descripcion) Contador
			FROM Z_DV_Sanborns
			where 1=1
			and CONVERT (date,FechaSubida) = @FechaSubida
			group by Sucursal
				,Devolucion
				,SKU
				,CB
			having count(Descripcion) >1
			order by Contador desc
	end
	if @Soriana = 1
	begin
			SELECT top 1000 
			 Folio
			,Sucursal
			,CodigoBarras
			,Count (Descripcion) Contador
			FROM Z_DV_Soriana
			where 1=1
			and CONVERT(date,FechaSuida) = @FechaSubida
			group by  Folio
				 ,Sucursal
				 ,CodigoBarras
			having COUNT (Descripcion) >1
			order by Contador desc
	end

	if @OXXO = 1
	begin 
			SELECT 
				FolDev,
				Sku,
				Tienda,
				COUNT (Artículo) Contador 
			FROM  Z_DV_OXXO
			where 1=1
			and convert(date,FechaSubida) = @FechaSubida
			group by FolDev,
					Sku,
					Tienda
			having COUNT (Artículo) > 1
			order by Contador desc
	end
	if @Cityfresko = 1
	BEGIN
			select top 1000 
			FOLIO
			,SUCURSAL
			,CODIGO_ARTICULO
			,COUNT (SUC_DESCRIPCION)Contador 
			from Z_DV_CityFresko
			where 1=1
			and convert (date,FechaSubida) = @FechaSubida
			group by FOLIO,
				 SUCURSAL,
				 CODIGO_ARTICULO
			having COUNT (SUC_DESCRIPCION) > 1
			order by Contador desc
	END
	
	if @Chedraui_24Hras = 1
	begin
	 select --top 1000 
	 Folio,
	 Upc,
	 NumeroPedido,
	 fechaSubida
	 from Z_DV_Chedraui
	 WHERE 1=1
		AND CONVERT(date,FechaSubida)=@FechaSubida
	 order by fechaSubida desc
	end


	IF @Chedraui_Sucursal = 1
	BEGIN 
			select TOP 1000 
			FOLIO,
			Sucursal,
			NumeroDocumento,
			Count (Descripcion) Contador
			from Z_DV_Chedraui_Sucursal
			WHERE 1=1
			AND CONVERT(date,FechaSubida)=@FechaSubida
			group by FOLIO,Sucursal,NumeroDocumento
			having count(Descripcion) >1
			order by Contador desc
	END
	if @7eleven_Cargos = 1
	begin

	--select top 1000 * from Z_DV_7Eleven_Folios
			select top 1000 
			 Solicitud
			,NumTienda
			,FolioUnicoRecepcion
			,Count (FacturaFuente) Contador
		from Z_DV_7Eleven_Folios
		where 1=1
		and convert(date,FechaSubida) = @FechaSubida
		group by Solicitud,
				 NumTienda,
				 FolioUnicoRecepcion
		Having count(FacturaFuente) > 1
		order by Contador desc

	end

	if @Liverpool = 1
	begin

			select --TOP 1000 
				 a.Articulo
				,a.NroReferen
				,COUNT (Descripcio) Contador
		from Z_DV_Liverpool a
		WHERE 1=1
		--left outer join Z_DV_Liverpool_SKU b
		-- on 
		-- a.Articulo= b.Material
		 AND CONVERT(date,FechaSubida) = @FechaSubida
		 group by  a.Articulo
				  ,a.NroReferen
		having COUNT(Descripcio) > 1
		order by Contador desc

	end 
	if @Walmart = 1
	begin 
			select Tienda
						  , Folio
						  , DET_UPC
						  , COUNT (DET_Desc) Contador
		from Z_DV_Pendientes_Walmart
		where 1=1
		and convert(date,FechaSubida) = @FechaSubida
		group by Tienda,
				 Folio,
				 DET_UPC
		having COUNT (DET_Desc) > 1
		order by Contador desc
	end
	if @7eleven = 1
	begin
			select TOP 1000 
			Solicitud
			,NumTienda
			,UPC
			,COUNT (Descrpcion)Contador 
		from Z_DV_7Eleven
		where 1=1
		and convert(date,FechaSubida) = @FechaSubida
		GROUP BY Solicitud
				,NumTienda
				,UPC
		HAVING COUNT (Descrpcion) > 1
		ORDER BY Contador desc

	end
if @FechaDevolucion = 1
	begin 
	
	if @Walmart = 1
	BEGIN 
	
	SELECT  
		Factura,
		Tienda,
		Base,
		Folio,
		Importe,
		DET_Cantidad,
		DET_Costo,
		DET_ImporteTotal,
		FechaSubida
	FROM Z_DV_Pendientes_Walmart
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	if @Sanbons = 1
	BEGIN 
	
	SELECT *
	FROM Z_DV_Sanborns
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	if @Soriana = 1
	BEGIN 
	
	SELECT 
		Folio,
		Sucursal,
		Importe_Cab,
		Proveedor,
		FechaDev,
		Subtotal,
		IVA,
		Total_Det,
		CodigoBarras,
		Descripcion,
		FechaSuida
	FROM Z_DV_Soriana
	where 1=1
	and convert(date,FechaSuida) = @FechaSubida
	ORDER BY FechaSuida desc

	END

	if @Chedraui_24Hras = 1
	BEGIN 
	
	SELECT 
		Folio,
		NumeroLinea,
		Proveedor,
		NumeroPedido,
		TextoPosicion,
		Upc,
		DescripcionArt,
		Cantidad,
		CtoUnitario,
		TotalDocumentos,
		SubTotalDocumentos,
		fechaSubida
	FROM Z_DV_Chedraui
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	if @Chedraui_Sucursal = 1
	BEGIN 
	
	SELECT 
		Sucursal,
		NumeroDocumento,
		ReferenciaDocumento,
		FechaRegistrado,
		FechaVencimiento,
		Importe,
		UUID_CFDI,
		FechaSubida
	FROM Z_DV_Chedraui_Sucursal
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	if @Liverpool = 1
	BEGIN 
	
	SELECT 
		NroReferen,
		FechaCreac,
		FechaCambi,
		Articulo,
		Descripcio,
		Cantidad,
		FechaSubida
	FROM Z_DV_Liverpool
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	if @Liverpool_SKU = 1
	BEGIN 
	
	SELECT *
	FROM Z_DV_Liverpool_SKU
	where 1 = 1
	and convert(date,Fecha_Subida) = @FechaSubida
	ORDER BY Fecha_Subida desc

	END

	if @Cityfresko = 1
	BEGIN 
	
	SELECT 
		SUCURSAL,
		FOLIO,
		SUCURSAL,
		FECHA_ALTA,
		DESC_MOTIVO,
		FECHA_PUBLICACION,
		CODIGO_ARTICULO,
		DESCRIPCION,
		CANTIDAD,
		CONDICION,
		FechaSubida
	FROM Z_DV_CityFresko
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	if @HEB = 1
	BEGIN 
	
	SELECT TOP 1000 
		*
	FROM Z_DV_HEB
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	if @7eleven = 1
	BEGIN 
	
	SELECT 
		Solicitud,
		FechaSolicitud,
		NumTienda,
		Tienda,
		UPC,
		Descrpcion,
		Precio,
		Cantidad,
		Subtotal,
		Total,
		FechaSubida
	FROM Z_DV_7Eleven
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	if @7eleven_Cargos = 1
	BEGIN 
	
	SELECT 
		Solicitud,
		NumTienda,
		FolioUnicoRecepcion,
		FechaOrigen,
		FechaSolicitud,
		SubtotalSolicitud,
		TotalSolicitud,
		FacturaFuente,
		SubtotalFactura,
		TotalFactura,
		FechaSubida
	FROM Z_DV_7Eleven_Folios
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	if @OXXO = 1
	BEGIN 
	
	SELECT 
		*
	FROM Z_DV_OXXO
	where 1=1
	and convert(date,FechaSubida) = @FechaSubida
	ORDER BY FechaSubida desc

	END

	end


end


if @Pagos = 1
begin
	if @Toks = 1
	begin 

	--select top 1000 * from Z_DVParcial_Toks
		select distinct top 1000 
			 NotaAclaracion
			,CONVERT (int,Pago) Pago
			,FechaFactura			
			,SUM (convert(int,Ctd)) Cantidad
			,SUM(Precio) Precio
			,TotalMXP
			,SUM(Importe) Importe
			,FechaSubida
		from Z_DVParcial_Toks
		where 1=1
		and convert(date,FechaSubida) = @FechaPagos
		--and Pago = @Pago
		group by NotaAclaracion
				,TotalMXP
				,FechaFactura
				,FechaSubida
				,Pago
		order by FechaFactura desc, FechaSubida desc
	end
end

--if @AcusesRecibo = 1
--BEGIN
--	IF @Waltma_AR = 1
--	BEGIN

--	SELECT TOP 1000 
--		 NO_FACTURA
--		,FOLIO_RECIBO
--		,COD_ARTICULO
--		,FechaSubida
--		,COUNT(COD_ARTICULO_COMPRADOR)Contador
--	FROM Z_AR_Walmart
--		WHERE 1=1
--		and convert(date, FechaSubida) = @FechaAR
--		group by NO_FACTURA
--				,FOLIO_RECIBO
--				,COD_ARTICULO
--				,FechaSubida
--		having count (COD_ARTICULO_COMPRADOR) > 1
--	ORDER BY Contador DESC
	
--	END

--	IF @Soriana_AR = 1
--	BEGIN

--	SELECT TOP 1000 
--		 FolioEntrega
--		,Sucursal_Cab
--		,Factura
--		,Codigo_Articulo_Det
--		,FechaSubida
--		,count(Descripción_Det) Contador 
--	FROM Z_AR_Soriana
--		WHERE 1=1
--		and convert(date,FechaSubida) = @FechaAR
--		group by FolioEntrega
--				,Sucursal_Cab
--				,Factura
--				,Codigo_Articulo_Det
--				,FechaSubida
--		having count(Descripción_Det) > 1
--	ORDER BY Contador DESC

--	END

--	IF @HEB_AR = 1
--	BEGIN
	
--	SELECT TOP 1000 
--		 FolioRecibo
--		,Sucursal
--		,Articulo
--		,CodigoBarras
--		,FechaSubida
--		,COUNT(Descripcion)Contador
--	FROM Z_AR_HEB
--		WHERE 1=1
--		and convert(date,FechaSubida) = @FechaAR
--		group by 
--			 FolioRecibo
--			,Sucursal
--			,Articulo
--			,CodigoBarras
--			,FechaSubida
--		having count(Descripcion)>1
--	ORDER BY Contador DESC

--	END
	
--	IF @CityFresko_AR = 1
--	BEGIN
--	SELECT distinct TOP 1000 
--		 SUCURSAL_RE
--		,FOLIO_RE
--		,SUC_DESCRIPCION_RE
--		,FACTURA_RF
--		,CODIGO_ARTICULO_RD
--		,FOLIO_DET_RD
--		,FechaSubida
--		,count (DESCRIPCION_RD)Contador	
--	FROM Z_AR_CityFresko
--		WHERE 1=1
--		and CONVERT(date,FechaSubida) = @FechaAR
--		group by SUCURSAL_RE
--				,FOLIO_RE
--				,SUC_DESCRIPCION_RE
--				,FACTURA_RF
--				,CODIGO_ARTICULO_RD
--				,FOLIO_DET_RD
--				,FechaSubida
--		having COUNT(DESCRIPCION_RD) > 1
--		order by Contador desc

--	END


--END