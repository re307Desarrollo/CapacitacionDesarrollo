USE [Global]
GO
/****** Object:  StoredProcedure [dbo].[Automatizacion_Liverpool]    Script Date: 27/12/2021 04:36:38 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Automatizacion_Liverpool] (
	 @Accion VARCHAR(MAX) = ''
	,@Fecha VARCHAR(MAX) = null
	,@Importe VARCHAR(MAX) = null
	,@Unidades VARCHAR(MAX) = null
	)
AS
BEGIN


/* DEVOLUCIONES */

	IF @Accion = 'Devoluciones'
	BEGIN

		DELETE FROM [Z_DV_Liverpool_Bot]
		WHERE 1=1 AND Column1 = 'NroReferen'

		delete from [Z_DV_Liverpool_Bot]
		where 1=1
		and column5 like '%00000000%'
		
		delete from [Z_DV_Liverpool_Bot]
		where 1=1
		and column5 IS NULL
		
		--Nuevo Dato
		delete from [Z_DV_Liverpool_Bot]
		where 1=1
		and Column1 like '%Número de Referencia%'
		and Column2 like '%Ejercicio%'
		
		/* INSERTA DATOS ACUMULADOS */
		INSERT INTO Z_DV_Liverpool
		SELECT
			 [Column1]
			,[Column2]
			,CASE 
				WHEN Column3 LIKE '%/%' THEN CONVERT(DATE,REPLACE(SUBSTRING(Column3, LEN(Column3)-3,4) + '-' + SUBSTRING(Column3, CHARINDEX('/',Column3,1)+1,2) + '-' + SUBSTRING(Column3, 1,CHARINDEX('/',Column3,1)),'/',''))
				ELSE CONVERT(DATE,Column3) 
			END AS Column3
			,[Column4]
			,CASE 
				WHEN Column5 LIKE '%/%' THEN CONVERT(DATE,REPLACE(SUBSTRING(Column5, LEN(Column5)-3,5) + '-' + SUBSTRING(Column5, CHARINDEX('/',Column5,1)+1,2) + '-' + SUBSTRING(Column5, 1,CHARINDEX('/',Column5,1)),'/',''))
				WHEN [Column5] LIKE '%/%' THEN CONVERT(DATE,SUBSTRING([Column5], 7,4) + '-' + SUBSTRING([Column5], 4,2) + '-' + SUBSTRING([Column5], 1,2))
				ELSE CONVERT(DATE,[Column5]) 
			END AS [Column5]
			,[Column6]
			,[Column7]
			,[Column8]
			,[Column9]
			,[Column10]
			,[Column11]
			,[Column12]
			,[Column13]
			,[Column14]
			,[Column15]
			,[Column16]
			,[Column17]
			,[Column18]
			,GETDATE()
		FROM [Global].[dbo].[Z_DV_Liverpool_Bot] A
		WHERE 1 = 1
			AND NOT EXISTS(SELECT * FROM Z_DV_Liverpool B 
				WHERE 1 = 1
					AND A.Column1 = B.NroReferen 
					AND CONVERT(INT,A.Column9) = CONVERT(INT,B.Articulo) 
					AND A.Column6 = B.CentroOrig 
					--AND A.Column12 = B.Cantidad 
					--AND A.Column18 = B.COD_P
					)
		and Column3 is not null

		update Z_DV_Liverpool
		set Cantidad = REPLACE(Cantidad,',','.')
		where 1 = 1
		and Cantidad like '%,%'

		TRUNCATE TABLE Z_DV_Liverpool_Bot

	END
	IF @Accion = 'Devoluciones_2'
	begin
		DELETE FROM [Z_DV_Liverpool_Bot]
		WHERE 1=1 AND Column10 = 'NroReferen'

		delete from [Z_DV_Liverpool_Bot]
		where 1=1
		and column5 like '%00000000%'
		
		delete from [Z_DV_Liverpool_Bot]
		where 1=1
		and column6 IS NULL
		
		--Nuevo Dato
		delete from [Z_DV_Liverpool_Bot]
		where 1=1
		and Column10 like '%Número de Referencia%'
		and Column12 like '%Ejercicio%'
		
		/* INSERTA DATOS ACUMULADOS */
		INSERT INTO Z_DV_Liverpool
		SELECT
			 [Column10]
			,[Column12]
			,CASE 
				WHEN Column13 LIKE '%/%' THEN CONVERT(DATE,REPLACE(SUBSTRING(Column13, LEN(Column13)-3,4) + '-' + SUBSTRING(Column13, CHARINDEX('/',Column13,1)+1,2) + '-' + SUBSTRING(Column13, 1,CHARINDEX('/',Column13,1)),'/',''))
				ELSE CONVERT(DATE,Column13) 
			END AS Column13
			,[Column1]
			,CASE 
				WHEN Column2 LIKE '%/%' THEN CONVERT(DATE,REPLACE(SUBSTRING(Column2, LEN(Column2)-3,5) + '-' + SUBSTRING(Column2, CHARINDEX('/',Column2,1)+1,2) + '-' + SUBSTRING(Column2, 1,CHARINDEX('/',Column2,1)),'/',''))
				WHEN [Column2] LIKE '%/%' THEN CONVERT(DATE,SUBSTRING([Column2], 7,4) + '-' + SUBSTRING([Column2], 4,2) + '-' + SUBSTRING([Column2], 1,2))
				ELSE CONVERT(DATE,[Column2]) 
			END AS [Column2]
			,[Column14]
			,[Column3]
			,[Column4]
			,[Column15]
			,[Column16]
			,[Column5]
			,[Column11]
			,[Column17]
			,[Column6]
			,[Column7]
			,[Column8]
			,[Column9]
			,[Column18]
			,GETDATE()
		FROM [Global].[dbo].[Z_DV_Liverpool_Bot] A
		WHERE 1 = 1
			AND NOT EXISTS(SELECT * FROM Z_DV_Liverpool B 
				WHERE 1 = 1
					AND A.Column10 = B.NroReferen 
					AND CONVERT(INT,A.Column15) = CONVERT(INT,B.Articulo) 
					AND A.Column14 = B.CentroOrig 
					--AND A.Column12 = B.Cantidad 
					--AND A.Column18 = B.COD_P
					)
		and Column5 is not null

		update Z_DV_Liverpool
		set Cantidad = REPLACE(Cantidad,',','.')
		where 1 = 1
		and Cantidad like '%,%'

		TRUNCATE TABLE Z_DV_Liverpool_Bot
	end

--****************************************************************************************************************************************************************
	IF @Accion = 'LimpiarDevoluciones'
	BEGIN
		TRUNCATE TABLE Z_DV_Liverpool_Bot
	END
--****************************************************************************************************************************************************************
	IF @Accion = 'LimpiarVentas'
	BEGIN
		TRUNCATE TABLE Z_VE_Liverpool_Bot
	END

--****************************************************************************************************************************************************************
IF @Accion = 'VentasLiverpool'

	begin
CREATE TABLE #DataOriginalOrder(
	Id INT Identity (1,1) primary key,
	[Column1] [varchar](max) NULL,
	[Column2] [varchar](max) NULL,
	[Column3] [varchar](max) NULL,
	[Column4] [varchar](max) NULL,
	[Column5] [varchar](max) NULL,
	[Column6] [varchar](max) NULL,
	[Column7] [varchar](max) NULL,
	[Column8] [varchar](max) NULL,
	[Column9] [varchar](max) NULL,
	[Column10] [varchar](max) NULL,
	[Column11] [varchar](max) NULL,
	[Column12] [varchar](max) NULL
)

insert into #DataOriginalOrder
select * from Z_VE_Liverpool_Bot
where 1=1
	and Column4 is not null
	and Column5 is not null
	and Column6 is not null
	and Column7 is not null
	and Column8 is not null
--select * from #DataOriginalOrder
--order by Id


delete 
from #DataOriginalOrder
where 1=1 and Id < 16

delete
from #DataOriginalOrder
where Column1 = 'Resultado Total'

delete
from #DataOriginalOrder
where Column3 = 'Resultado'

delete
from #DataOriginalOrder
where Column4 = 'Resultado'

delete
from #DataOriginalOrder
where Column5 = 'Resultado'


	update #DataOriginalOrder
	set column12 = REPLACE(Column12,'"','')
	where Column12 like '%"%'

	update #DataOriginalOrder
	set column1 = null
	where Column1 = ''

	update #DataOriginalOrder
	set column2 = null
	where Column2 = ''

	update #DataOriginalOrder
	set column3 = null
	where Column3 = ''


	
delete
FROM #DataOriginalOrder
where 1=1
	AND [Column4] = ''
	AND [Column5] = ''
	AND [Column6] = ''
	AND [Column7] = ''
	AND [Column8] = ''

	   	  
	Declare 
		@Id int = 0,
		@Sucursal varchar(max) = null,
		@lapCounter int = 0,
		@NombreSucursal varchar(max) = null,
		@Fecha2  varchar(max) = null
	while (exists( select top 1 Id, Column1 from #DataOriginalOrder where 1 = 1 and Column1 is null order by id asc))
	--while (exists( select top 1 Column13, Column1 from #Concentrado where 1 = 1 and Column1 = '' order by Column13 asc))
	begin
		--Identificamos el id que vamos a actualizar
		select top 1 @Id=Id, @Sucursal=Column1,@NombreSucursal=column2 from #DataOriginalOrder where 1 = 1 and Column1 is null order by id asc
		--select top 1 @Id=Column13, @Sucursal=Column1,@NombreSucursal=column2 from #Concentrado where 1 = 1 and Column1 = '' order by Column13 asc
		
		--print 'Id a actualizar = ' + convert(varchar,@Id)
		--Identificamos el Id que vamos a tomar como referencia para llevar a cabo la actualización
		Select top 1 @Sucursal=Column1,@NombreSucursal=column2 from #DataOriginalOrder where 1 = 1 and Id < @Id and Column1 is not null order by Id desc
		--Select top 1 @Sucursal=Column1,@NombreSucursal=column2 from #Concentrado where 1 = 1 and Column13 < @Id and Column1 != '' order by Column13 desc
		--print 'Sucursal a tomar como base para la actualización' + @Sucursal
	
		update x
			set x.Column1 = @Sucursal, x.Column2 = @NombreSucursal
		from #DataOriginalOrder x
		--from #Concentrado x
		where 1 = 1
			and id = @Id

		select @lapCounter = @lapCounter + 1
		--print 'Lap Counter ' + convert(varchar,@lapCounter)
	end

	select @lapCounter = 0


	while (exists( select top 1 Id, Column3 from #DataOriginalOrder where 1 = 1 and Column3 is null order by id asc))
	--while (exists( select top 1 Column13, Column1 from #Concentrado where 1 = 1 and Column1 = '' order by Column13 asc))
	begin
		--Identificamos el id que vamos a actualizar
		select top 1 @Id=Id, @Fecha2=Column3 from #DataOriginalOrder where 1 = 1 and Column3 is null order by id asc
		--select top 1 @Id=Column13, @Sucursal=Column1,@NombreSucursal=column2 from #Concentrado where 1 = 1 and Column1 = '' order by Column13 asc
		
		--print 'Id a actualizar = ' + convert(varchar,@Id)
		--Identificamos el Id que vamos a tomar como referencia para llevar a cabo la actualización
		Select top 1 @Fecha2=Column3 from #DataOriginalOrder where 1 = 1 and Id < @Id and Column3 is not null order by Id desc
		--Select top 1 @Sucursal=Column1,@NombreSucursal=column2 from #Concentrado where 1 = 1 and Column13 < @Id and Column1 != '' order by Column13 desc
		--print 'Sucursal a tomar como base para la actualización' + @Sucursal
	
		update x
			set x.Column3 = @Fecha2
			from #DataOriginalOrder x
		--from #Concentrado x
		where 1 = 1
			and id = @Id

		select @lapCounter = @lapCounter + 1
		--print 'Lap Counter ' + convert(varchar,@lapCounter)
	end

	--select * from #DataOriginalOrder

		--Proceso de acumulación de Venta
	--drop table #Liverpool1
		SELECT  
			 Column1 Centro
			,Column2 Sucursal
			,Column5 Articulo
			,Column6 Descripcion
			,Column7 Estado
			,Column8 [Modelo/Editor]
			,Column9 [EAN/UPC]
			,Column10 Temporada
			,Convert(int,Column11)  VentasUnidades
			--,convert(money,Column12) Ventas$
			,convert(float,convert(money,Column12)) Ventas$
			--,Column11 Ventas$

			,right(column3,4) + '-' + SUBSTRING(column3,4,2) + '-' + left(column3,2) FechaVenta
			--,Convert(int,Column13) COD_P
			,1 COD_P
		into #Liverpool1
		FROM #DataOriginalOrder

		
		--Identificamos que vamos a cambiar

		Select FechaVenta 
		into #Analizar
		from Z_VE_Liverpool
		where 1 = 1
			and FechaVenta in (Select distinct FechaVenta from #Liverpool1)


		--eliminamos la venta que ya tenemos en el bot
		delete a from Z_VE_Liverpool a
		where 1 = 1
			and FechaVenta in (Select distinct FechaVenta from #Analizar)


		--Inserción Final
		Insert into Z_VE_Liverpool
		Select
			 a.Centro
			,a.Sucursal
			,a.Articulo
			,a.Descripcion
			,a.Estado
			,a.[Modelo/Editor]
			,a.[EAN/UPC]
			,a.Temporada
			,a.VentasUnidades
			,a.Ventas$
			,a.FechaVenta
			,a.COD_P
			,GETDATE() FechaSubida
		from #Liverpool1 a


end

IF @Accion = 'Automatizacion_Liverpool_SKU'
        BEGIN

		update a
				set Inicio_Actualiza = GETDATE()
				from Subidas_Log_Gral a
				where 1 = 1
					and Sp_Padre = 'Automatizacion_Liverpool'
					and Sp = 'Automatizacion_Liverpool_SKU'

			TRUNCATE TABLE Z_DV_Liverpool_SKU

			INSERT INTO Z_DV_Liverpool_SKU
			SELECT distinct
				Column1
				,Column2
				,Column3 
				,Column4
				,Column5
				,Column6
				,REPLACE(Column7,' ','') Column7 
				,Column8
				,Column9
				,Column10
				,Column11
				,Column12
				,Column13
				,Column14
				,Column15
				,Column16
				,Column17
				,Column18
				,CONVERT(float,Column19) Column19
				,CONVERT(float,Column20) Column20
				,Column21
				,CONVERT(float,Column22) Column22
				,Column23
				,CONVERT(float,Column24) Colum24
				,CONVERT(float,Column25) Column25
				,CONVERT(float,Column26) Column26
				,Column27
				,Column28
				,Column29
				,Column30
				,CONVERT(float,Column31) Column31
				,Column32
				,CONVERT(float,Column33) Column33
				,Column34
				,CONVERT(float,Column35) Column35
				,CONVERT(float,Column36) Column36
				,CONVERT(float,Column37)Column37
				,CONVERT(float,Column38) Column38
				,CONVERT(float,Column39)Column39
				,CONVERT(float,Column40)Column40
				,Column41
				,CONVERT(float,Column42) Column42
				,Column43
				,Column44
				,Column45
				,Column46
				,Column47 
				,Column48
				,Column49
				,Column50
				,REPLACE(Column51,'e','�') Column51
				,Column52
				,Column53
				,CONVERT(VARCHAR(23), GETDATE(), 121)
			FROM Z_DV_Liverpool_SKU_bot
			WHERE 1=1
			AND Column2 IS NOT NULL
			AND Column3 IS NOT NULL

			UPDATE Z_DV_Liverpool_SKU SET Descr_Pais = REPLACE(Descr_Pais,'?','e')

			TRUNCATE TABLE Z_DV_Liverpool_SKU_bot

			--Inserción manual de material que no existe desde el origen
			if (select COUNT(*) from [Z_DV_Liverpool_SKU] where Material = '000000001070597191') = 0
			begin
			insert into [Z_DV_Liverpool_SKU]
			SELECT [Tipo_Reg]
				  ,[Proveedor]
				  ,'000000001070597191'[Material]
				  ,'7509997026343'[Ean]
				  ,[Cat_Articulo]
				  ,[Art_General]
				  ,[Desc_Art]
				  ,[Estatus]
				  ,[Tp_Art]
				  ,[Art_Proveedor]
				  ,[Gpo_Art]
				  ,[Texto_Adicional]
				  ,[Negocio]
				  ,[Submarca]
				  ,[Desc_Submarca]
				  ,[Licencia]
				  ,[Desc_Licencia]
				  ,[Temporada]
				  ,[Peso_Bruto]
				  ,[Peso_Neto]
				  ,[Unidad_Peso]
				  ,[Volumen]
				  ,[Unidad_Volumen]
				  ,[Longitud]
				  ,[Ancho]
				  ,[Altura]
				  ,[Unidad_L_A_A]
				  ,[Armado]
				  ,[Manipulacion]
				  ,[Almacenamiento]
				  ,[Servicio]
				  ,'159.92' [Costo_Bruto]
				  ,[Inicio_Costo_Bruto]
				  ,[Costo_Bruto_p_Apl]
				  ,[Inicio_Costo_bruto_p_Aplicar]
				  ,[Descuento1]
				  ,[Descuento2]
				  ,[Descuento3]
				  ,[Descuento4]
				  ,'159.92' [Costo_Neto]
				  ,[Precio_venta]
				  ,[Inicio_Precio_Venta]
				  ,[Precio_venta_p_Apl]
				  ,[Inicio_Precio_Venta_p_Aplicar]
				  ,[Etiqueta]
				  ,[Evento]
				  ,[Texto_datos_Basicos]
				  ,[Gr_Moda]
				  ,[Desc_Gr_Moda]
				  ,[Pais]
				  ,[Descr_Pais]
				  ,[Region]
				  ,[Descr_Region]
				  ,[Fecha_Subida]
			  FROM [Global].[dbo].[Z_DV_Liverpool_SKU] a
			  where 1 = 1
				and Material = '000000000018230160'
			end

			--Validación de SKU's, aquí validaremos que la información de SKU's no tenga duplicidades,
			--en caso de tener duplicidades procederemos a marcarlo en el log
			select Material, COUNT(Material) contador 
			into #Final
			from Z_DV_Liverpool_SKU
			group by Material
			having COUNT(Material) > 1
			order by contador desc

			update a
				set Fin_Actualiza = GETDATE()
				from Subidas_Log_Gral a
				where 1 = 1
					and Sp_Padre = 'Automatizacion_Liverpool'
					and Sp = 'Automatizacion_Liverpool_SKU'

			update a
				set a.Comentarios = null
				from Subidas_Log_Gral a
				where 1 = 1
					and Sp_Padre = 'Automatizacion_Liverpool'
					and Sp = 'Automatizacion_Liverpool_SKU'

			if (select COUNT(*) from #Final) > 0
			begin
				update a
				set a.Comentarios = 'SKUs duplicados, valide por favor. Queda estrictamente prohibido ejecutar el SP: "Devoluciones_Liverpool_Subir_2.0"'
				from Subidas_Log_Gral a
				where 1 = 1
					and Sp_Padre = 'Automatizacion_Liverpool'
					and Sp = 'Automatizacion_Liverpool_SKU'
			end
		END

END


--create table Z_VE_Liverpool
--(
--	 Centro varchar(5)
--	,Sucursal varchar(50)
--	,Articulo Varchar(25) 
--	,Descripcion Varchar(500)
--	,Estado Varchar(50)
--	,Modelo Varchar(500)
--	,[EAN/UPC] varchar(25)
--	,Temporada varchar(50)
--	,VentasUnidades int
--	,Ventas$ float
--	,FechaVenta date
--	,COD_P int 
--	,FechaSubida datetime
--)