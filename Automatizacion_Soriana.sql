USE [Global]
GO
/****** Object:  StoredProcedure [dbo].[Automatizacion_Soriana]    Script Date: 29/06/2021 04:38:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<H. DEPTO DESARROLLO>
-- Create date: <2018-04-25>
-- Description:	<PROCESOS DE AUTOMATIZACION DE PORTALES PARA SORIAN>
-- =============================================
ALTER PROCEDURE [dbo].[Automatizacion_Soriana]
	
	 @Accion	varchar(Max) = ''
	,@Folio		varchar(Max) = ''
	,@Sucursal	varchar(Max) = ''
	,@Importe	varchar(Max) = ''
	,@Factura	varchar(Max) = ''
	,@ImporteDetalle varchar(Max) = ''
	,@Bandera varchar(2) = 0
	,@Fecha date = null
	,@FilePath varchar(max) = 'H:\Desarrollo\Ventas Soriana\Espejo\'
	,@FileName varchar(max) = null
	,@Bulk_Insert varchar(max) = null
AS
BEGIN
-- Truncar tabla Bot
	IF @Accion = 'CatTruncateTable'
	BEGIN
		TRUNCATE TABLE Z_CAT_Soriana_Bot
	END

	-- Procesos de ventas
	IF @Accion = 'CatalogacionPortal'
	BEGIN
		
		SELECT*
		INTO #Cabecero
		from Z_CAT_Soriana_Bot

		-- Delete fail data
		DELETE FROM #Cabecero
		WHERE 1 = 1
		AND Column1 = 'Cve Div'

		--change status
		UPDATE #Cabecero SET Column30 = 'Act'
		WHERE 1 = 1
		AND Column30 = 'Z2'
		UPDATE #Cabecero SET Column30 = 'Desc'
		WHERE 1 = 1
		AND Column30 = 'Z0'
		OR Column30 = 'ZD'

		--Pruba, revicion de diferentes estatus
		DELETE a FROM #Cabecero a
		WHERE 1 = 1
		AND Column30 != 'Act'
		AND Column30 != 'Desc'
		 
		-- Accumulation of datas from portal
		SELECT 
		Column8 CB
		,Column9 Descripcion
		,CONVERT (INT,Column10) Num_Sucursal
		,Column11 Sucursal
		,Column30 [Status]
		,CONVERT (INT,'1') COD_p
		INTO #Convert
		FROM #Cabecero

		--CB AND Num_Sucursal *new
		SELECT *
		INTO #Last
		FROM #Convert a
		WHERE 1 = 1
		AND NOT EXISTS(SELECT*FROM Z_CAT_Soriana b WHERE a.CB = b.CB AND a.Num_Sucursal = b.Num_Sucursal)
		
		-- Identify, which one status change
		SELECT a.*
		INTO #Clean
		FROM #Convert a
		LEFT OUTER JOIN Z_CAT_Soriana b
		ON a.CB = b.CB
		AND a.Num_Sucursal = b.Num_Sucursal
		WHERE 1 = 1
		AND a.[Status] != b.[Status]

		--Delete data from production table whit #Clean
		DELETE a FROM Z_CAT_Soriana a, #Clean b
		WHERE 1 = 1
		AND a.CB = b.CB
		AND a.Num_Sucursal = b.Num_Sucursal

		--Insert new data
		INSERT INTO Z_CAT_Soriana
		SELECT a.*
		,GETDATE() FechaSubida
		FROM #Last a

		--Insert diferent data
		INSERT INTO Z_CAT_Soriana
		SELECT a.*
		,GETDATE() FechaSubida
		FROM #Clean a
	END
	--*****************************************************************************************************
	IF @Accion = 'AcuseRecibo'
	BEGIN 
		SELECT*
		INTO #Soriana1
		FROM Z_AR_Soriana_Bot
		
		DELETE FROM #Soriana1
		WHERE Column26 IS NULL

		SELECT *FROM #Soriana1


		INSERT INTO [Z_AR_Soriana]
		SELECT
			Column1,
			--CONVERT(DATE,REPLACE(REPLACE(REPLACE(REPLACE(Column2,'Ago','Aug'),'Ene','Jan'),'Dic','Dec'),'Abr','Apr'),105),
			Column2,
			Column3,
			Column4,
			Column5,
			Column6,
			column7,
			--CONVERT(DATE,REPLACE(REPLACE(REPLACE(REPLACE(Column7,'Ago','Aug'),'Ene','Jan'),'Dic','Dec'),'Abr','Apr'),105),
			Column8,
			Column9,
			--CONVERT(DATE,REPLACE(REPLACE(REPLACE(REPLACE(Column10,'Ago','Aug'),'Ene','Jan'),'Dic','Dec'),'Abr','Apr'),105),
			Column10,
			Column11,
			Column12,
			Column13,
			--CONVERT(DATE,REPLACE(REPLACE(REPLACE(REPLACE(Column14,'Ago','Aug'),'Ene','Jan'),'Dic','Dec'),'Abr','Apr'),105),
			Column14,
			Column15,
			Column16,
			Column17,
			Column18,
			Column19,
			Column20,
			Column21,
			Column22,
			Column23,
			Column24,
			Column25,
			CONVERT(INT,Column26)	COD_P,
			GETDATE()				FECHA_SUBIDA
		FROM #Soriana1 A
		WHERE 1=1
		AND NOT EXISTS (SELECT * FROM [Z_AR_Soriana] B WHERE 
							    convert(int,A.Column1) = convert(int,B.Tienda) 
							AND convert(int,A.Column3) = convert(int,B.FolioEntrega) 
							AND A.Column4 = B.Factura 
							AND A.Column21 = B.Codigo_Articulo_Det 
							AND A.Column26 = B.COD_P
							AND convert(int,A.Column20) = convert(int,B.Partida_Det) 
							AND convert(int,A.Column23) = convert(int,B.CantidadRecibida_Det) )

		
		--select top 10 * from [Z_AR_Soriana]
		--select top 10 * from [Z_AR_Soriana_bot]
		--TRUNCATE TABLE [Z_AR_Soriana]

		/* BORRAR TABLA DE PASO */
		TRUNCATE TABLE [Z_AR_Soriana_Bot]

	END 
	IF @Accion = 'ValidaAcusesRecibo'
		
		--declare @folio varchar(max) = '248'
		--declare @sucursal varchar(max) = '906'
		--declare @Importe varchar(max) = '$5,972.93'

	BEGIN 
		SELECT * FROM [Z_AR_Soriana] WHERE FolioEntrega = @Folio AND Tienda = @Sucursal AND Factura = @Factura
	END


	END 
--*********************************************************************
	IF @Accion = 'Devolución'
	BEGIN 
		
		--select * from [Z_DV_Soriana_Bot]

		delete from [Z_DV_Soriana_Bot] where Column21 =' ' and Column22 = ' '

		INSERT INTO [Z_DV_Soriana]
		select 
			Column1,
			Column2,
			Column3,
			Column4,
			Column5,
			Column6,
			Column7,
			Column8,
			Column9,
			Column10,
			Column11,
			Column12,
			Column13,
			Column14,
			Column15,
			Column16,
			Column17,
			Column18,
			Column19,
			Column20,
			Column21,
			Column22,
			Column23,
			Column24,
			Column25,
			Column26,
			Column27,
			Column28,
			Column29,
			convert(int,Column30),
			GETDATE()
		from [Z_DV_Soriana_Bot] A
		WHERE 1=1
		AND NOT EXISTS (SELECT * FROM [Z_DV_Soriana] B WHERE 
							    convert(int,A.Column1) = convert(int,B.Folio) 
							AND	convert(int,A.Column3) = convert(int,B.Sucursal) 
							--AND A.Column4 = B.Importe_Cab
							--AND A.Column2 = B.FechaDev 
							AND A.Column23 = B.CodigoBarras 
							--AND A.Column29 = B.COD_P
							--AND convert(int,A.Column25) = B.Cantidad
							)

		--select * from [Z_DV_Soriana_Bot] 
		--select * from [Z_DV_Soriana] 

		TRUNCATE TABLE [Z_DV_Soriana_Bot]
		--TRUNCATE TABLE [Z_DV_Soriana]
	END

--*********************************************************************
	IF @Accion = 'ValidaDevolución'
		
		--declare @folio varchar(max) = '248'
		--declare @sucursal varchar(max) = '906'
		--declare @Importe varchar(max) = '$5,972.93'
	BEGIN 
		SELECT  folio, sucursal, convert(float,replace(replace(iva,'$',''),',','')) iva , sum(convert(float,replace(replace(CostoN,'$',''),',',''))) importe FROM [Z_DV_Soriana]
		where 1=1 
			and Folio = @Folio 
			AND Sucursal = @Sucursal 
		group by folio, sucursal, convert(float,replace(replace(iva,'$',''),',','')),
		round(convert(float,replace(replace(Importe_Cab,'$',''),',','')),2)
		--having round(convert(float,replace(replace(iva,'$',''),',','')) + sum(convert(float,replace(replace(CostoN,'$',''),',',''))),1) = round(convert(float,replace(replace(@Importe, '$',''),',','')),1)
		having 
			round(round(sum(convert(float,replace(replace(CostoN,'$',''),',',''))),2) + round(convert(float,replace(replace(iva,'$',''),',','')),2),2) =
			round(convert(float,replace(replace(Importe_Cab,'$',''),',','')),2) 


		truncate table [Z_DV_Soriana_Bot]

	END 

	--BEGIN 
	--	SELECT * FROM [Z_DV_Soriana] WHERE Folio = @Folio AND Sucursal = @Sucursal AND @Importe = Importe_Cab
	--END

--**********************************************************************

IF @Accion = 'DevolucionNoCuadra'

BEGIN
	--declare @Sucursal Varchar(10) = '191'
	--declare @Folio Varchar(50) = '026802'
	--declare @Importe Varchar(50) = '$4,990.00'
	--declare @ImporteDetalle Varchar(50) = '$4,990.000001'
	--truncate table Z_DV_Soriana_DescargaIncompleta_
	--select * from Z_DV_Soriana_DescargaIncompleta_
	insert into Z_DV_Soriana_DescargaIncompleta_
	values(@Folio,@Sucursal, @Importe, @ImporteDetalle, getdate())

				
END

-------------------------------------------------------------------------

	-- Procesos de ventas
--Ventas
-- Truncar tabla Bot
	IF @Accion = 'TruncarTablaVE'
	BEGIN
		TRUNCATE TABLE Z_VE_Soriana_Bot
	END

	-- Procesos de ventas
	--IF @Accion = 'VentasPortal'
	--BEGIN
	--	 delete from Z_VE_Soriana_Bot
	--where 1 = 1
	--and Column1 = 'Día                 '

	--delete from Z_VE_Soriana_Bot
	--where 1 = 1
	--and Column1 like '%=%'

	--select distinct
	--	 convert(date,Column1) Fecha
	--	 into #Fechas
	--from Z_VE_Soriana_Bot
	--where 1 = 1

	--delete a
	--from Z_VE_Soriana a
	--where 1 = 1
	--	and Fecha in (Select * from #Fechas)


	--insert into Z_VE_Soriana
	--select
	--	 convert(date,Column1) Fecha
	--	,replace(Column2,' ','') Sucursal
	--	,replace(Column3,' ','') CB
	--	,round(convert(float,Column4),2) Importe
	--	,convert(int,Column5) Unidades
	--	,GETDATE() FechaSubida
	--from Z_VE_Soriana_Bot
	--where 1 = 1
	--END

----------------------------------------------------------------------------------------------------
	if @Accion = 'Corregir_Z_DV_Soriana'
	begin
		--26264
--drop table #Validar

--drop table CorregirPeppaSoriana
select 
	 Folio
	,Sucursal
	,round(sum(convert(float,replace(replace(CostoN,'$',''),',',''))),2) ImporteDetalle
	,round(convert(float,replace(replace(iva,'$',''),',','')),2) IVA
	,round(convert(float,replace(replace(Importe_Cab,'$',''),',','')),2) ImporteCabecero
	into #Validar
from Z_DV_Soriana
where 1 = 1	
group by
	 Folio
	,Sucursal
	,Importe_Cab
	,round(convert(float,replace(replace(iva,'$',''),',','')),2) 
	,round(convert(float,replace(replace(Importe_Cab,'$',''),',','')),2) 
--having 
--	round(round(sum(convert(float,replace(replace(CostoN,'$',''),',',''))),2) + round(sum(convert(float,replace(replace(iva,'$',''),',',''))),2),2) =
--	round(convert(float,replace(replace(Importe_Cab,'$',''),',','')),2)

--drop table #PosibleCorreccion
select 
	 Folio
	,Sucursal
	,ImporteDetalle
	,IVA
	,round(round(ImporteDetalle,2) + round(IVA,2),2) ImporteTotal
	,ImporteCabecero
	,round(round(round(ImporteDetalle,2) + round(IVA,2),2) - round(ImporteCabecero,2),2) Diferencia
	--into CorregirSoriana
	--into CorregirPeppaSoriana
	into #PosibleCorreccion
from #Validar
where 1 = 1
	--and Folio = '56895'
	and round(round(ImporteDetalle,2) + round(IVA,2),2) != round(ImporteCabecero,2)
	and round(round(round(ImporteDetalle,2) + round(IVA,2),2) - round(ImporteCabecero,2),2) > .02
order by Diferencia desc
	
	--drop table #ValidarCB
	select distinct
		 Folio 
		,Sucursal
		,CodigoBarras
		,Descripcion
		into #ValidarCB
	from Z_DV_Soriana a
	where 1 = 1
		and exists (select * from #PosibleCorreccion b where 1 = 1 and a.Folio = b.Folio and a.Sucursal = b.Sucursal)

		--Verificamos si existen CB's duplicados al folio y la sucursal
		--drop table #Corregir
		Select 
			 Folio
			,Sucursal
			,CodigoBarras
			,COUNT(Descripcion) contador
			into #Corregir
		from #ValidarCB
		group by
			 Folio
			,Sucursal
		    ,CodigoBarras
		having COUNT(Descripcion) > 1
			--order by contador desc
			order by Folio asc, Sucursal asc


			--Over patition para identificar las líneas correctas que reemplazarán las líneas duplicadas
			--drop table #Correctas
			SELECT *
			into #Correctas
		FROM (
			SELECT *
				 , row_number() over (partition by Folio, Sucursal, CodigoBarras
									  order by CodigoBarras asc, Descripcion asc
									 ) as rn
			
			FROM Z_DV_Soriana a
			where 1 = 1
				--and NoCte = '91615'
				--and RefNotaCarg = '091615'
				and exists (select * from #Corregir b where 1 = 1 and a.Folio = b.Folio and a.Sucursal = b.Sucursal and a.CodigoBarras = b.CodigoBarras)
		) AS T
		WHERE rn = 1

			--Eliminamos las líneas duplicadas
			--select * 
			delete a
			from Z_DV_Soriana a
			where 1 = 1
				and exists (select * from #Corregir b where 1 = 1 and a.Folio = b.Folio and a.Sucursal = b.Sucursal and a.CodigoBarras = b.CodigoBarras)

			insert into Z_DV_Soriana
			select 
				   [Folio]
				  ,[FechaDev]
				  ,[Sucursal]
				  ,[Importe_Cab]
				  ,[Talon]
				  ,[Status]
				  ,[Proveedor]
				  ,[Departamento]
				  ,[Sucursal_Det]
				  ,[Movimiento]
				  ,[FechaCargo]
				  ,[FechaMarcaje]
				  ,[FechaCalculo]
				  ,[Status_Det]
				  ,[Folio_Det]
				  ,[Subtotal]
				  ,[IEPS]
				  ,[IVA]
				  ,[Total_Det]
				  ,[FechaVencimiento]
				  ,[Partida]
				  ,[Sec]
				  ,[CodigoBarras]
				  ,[Descripcion]
				  ,[Cantidad]
				  ,[DoctoBase]
				  ,[Vigencia]
				  ,[CostoB]
				  ,[CostoN]
				  ,[COD_P]
				  ,[FechaSuida]			
			from #Correctas
	end



	
		----------------------------------------------------------------------------------------

if @Accion = 'ConsultaVta_Soriana'
begin
	select distinct Fecha 
	from Z_VE_Soriana
	where 1=1
	and Bandera = @Bandera
	and Fecha = @Fecha

end

if @Accion = 'Subir_Ventas_Soriana'

begin


create table #Z_VE_Soriana_Bot
(
NumTienda	varchar(max)
,Depto	varchar(max)
,CB	varchar(max)
,Fecha	varchar(max)
,VentasU	varchar(max)
,ComprasU	varchar(max)
,Inventario	varchar(max)
,ImporteVta	varchar(max)
,ImporteCom	varchar(max)

)


--BULK INSERT #Z_VE_Soriana_Bot FROM 'C:\Users\Grajales Diaz\Documents\Subir Data\VentaSoriana.txt' WITH (FIELDTERMINATOR= '!',FIRSTROW = 1);
--BULK INSERT #Z_VE_Soriana_Bot FROM '\\CORPSFEVEXTSQLP.corp.televisa.com.mx\Desarrollo\Ventas Soriana\VentaSoriana.txt' WITH (FIELDTERMINATOR= '!',FIRSTROW = 1);
BULK INSERT #Z_VE_Soriana_Bot FROM 'H:\Desarrollo\Ventas Soriana\VentaSoriana.txt' WITH (FIELDTERMINATOR= '!',FIRSTROW = 1);

--return
--Proceso de consolidación de información


-----************************************
--select * from Z_VE_Soriana_Bot
truncate table Z_VE_Soriana_Bot
insert into Z_VE_Soriana_Bot
select 
left(Fecha,4) + '-' + substring(Fecha,5,2) + '-' + right(Fecha,2) Fecha
,NumTienda Sucursal
,CB
,convert(float,ImporteVta)Importe
,VentasU Unidades
,@Bandera Bandera

from #Z_VE_Soriana_Bot


-----************************************

	select distinct
		 convert(date,Column1) Fecha
		 into #Fechas_V
	from Z_VE_Soriana_Bot
	where 1 = 1

	delete a
	from Z_VE_Soriana a
	where 1 = 1
		and Fecha in (Select * from #Fechas_V)
		and Bandera = @Bandera

	insert into Z_VE_Soriana
	select
		 convert(date,Column1) Fecha
		,replace(Column2,' ','') Sucursal
		,replace(Column3,' ','') CB
		,round(convert(float,Column4),2) Importe
		,convert(int,Column5) Unidades
		,GETDATE()
		,Column6 Bandera
	from Z_VE_Soriana_Bot
	where 1 = 1


end

if @Accion = 'Subir_Ventas_Soriana_Espejo'

begin

declare @Ant varchar(max)=null 


create table #Z_VE_Soriana_Bot_Espejo
(
NumTienda	varchar(max)
,Depto	varchar(max)
,CB	varchar(max)
,Fecha	varchar(max)
,VentasU	varchar(max)
,ComprasU	varchar(max)
,Inventario	varchar(max)
,ImporteVta	varchar(max)
,ImporteCom	varchar(max)

)


		set @Bulk_Insert = 'BULK INSERT #Z_VE_Soriana_Bot_Espejo FROM ''' + @FilePath + @FileName + ''' WITH
		(
			FIELDTERMINATOR = ''!'',
			FIRSTROW = 1
		)'
		exec(@Bulk_Insert)

--return
--Proceso de consolidación de información


-----************************************
--select * from Z_VE_Soriana_Bot
set @Ant = (REVERSE(SUBSTRING(REVERSE(@FileName),CHARINDEX('.',REVERSE(@FileName))+1,CHARINDEX('-',REVERSE(@FileName))-5)))
truncate table Z_VE_Soriana_Bot
insert into Z_VE_Soriana_Bot
select 
left(Fecha,4) + '-' + substring(Fecha,5,2) + '-' + right(Fecha,2) Fecha
,NumTienda Sucursal
,CB
,convert(float,ImporteVta)Importe
,VentasU Unidades
,iif(@Ant = 'DiaAnt','2','1') Bandera

from #Z_VE_Soriana_Bot_Espejo


-----************************************

	select distinct
		 convert(date,Column1) Fecha
		 into #Fechas_VE_Espejo
	from Z_VE_Soriana_Bot
	where 1 = 1

	delete a
	from Z_VE_Soriana_Espejo a
	where 1 = 1
		and Fecha in (Select * from #Fechas_VE_Espejo)
		and Bandera = @Bandera

	insert into Z_VE_Soriana_Espejo
	select
		 convert(date,Column1) Fecha
		,replace(Column2,' ','') Sucursal
		,replace(Column3,' ','') CB
		,round(convert(float,Column4),2) Importe
		,convert(int,Column5) Unidades
		,GETDATE()
		,Column6 Bandera
	from Z_VE_Soriana_Bot
	where 1 = 1


end