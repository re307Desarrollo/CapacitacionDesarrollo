


declare 
	@Alimentar int = 0
	,@ValidarSubir int = 0
	,@Subir int = 0
	,@VerificarSubida int = 0
	,@EjecutarSpSoriana int = 0
	,@ValidarTablasDevoSoriana int = 0
	,@EjecutarSpSubidaDevo int = 0

if @Alimentar = 1
begin
IF OBJECT_ID('tempdb..#Z_DV_Soriana') IS not NULL
BEGIN
drop table #Z_DV_Soriana
END
CREATE TABLE #Z_DV_Soriana(
	[Folio] [varchar](max) NULL,
	[FechaDev] [varchar](max) NULL,
	[Sucursal] [varchar](max) NULL,
	[Importe_Cab] [varchar](max) NULL,
	[Talon] [varchar](max) NULL,
	[Status] [varchar](max) NULL,
	[Proveedor] [varchar](max) NULL,
	[Departamento] [varchar](max) NULL,
	[Sucursal_Det] [varchar](max) NULL,
	[Movimiento] [varchar](max) NULL,
	[FechaCargo] [varchar](max) NULL,
	[FechaMarcaje] [varchar](max) NULL,
	[FechaCalculo] [varchar](max) NULL,
	[Status_Det] [varchar](max) NULL,
	[Folio_Det] [varchar](max) NULL,
	[Subtotal] [varchar](max) NULL,
	[IEPS] [varchar](max) NULL,
	[IVA] [varchar](max) NULL,
	[Total_Det] [varchar](max) NULL,
	[FechaVencimiento] [varchar](max) NULL,
	[Partida] [varchar](max) NULL,
	[Sec] [varchar](max) NULL,
	[CodigoBarras] [varchar](max) NULL,
	[Descripcion] [varchar](max) NULL,
	[Cantidad] [int] NULL,
	[DoctoBase] [varchar](max) NULL,
	[Vigencia] [varchar](max) NULL,
	[CostoB] [varchar](max) NULL,
	[CostoN] [varchar](max) NULL
)

BULK INSERT #Z_DV_Soriana FROM 'H:\Desarrollo\Devolucion Soriana\Devolución Soriana.txt' 
WITH (
	FIELDTERMINATOR= '	'
	--,CODEPAGE = 1252
	,FIRSTROW = 2
	,ROWTERMINATOR = '\n'
);

			--DATAFILETYPE =''char'',
			--FIELDTERMINATOR =''	'',
			--,
			--FIRSTROW = 2
--select distinct a.IEPS
--from #Z_DV_Soriana a
--select top 1 a.*
--from Z_DV_Soriana a
--where 1 = 1
--and a.CostoB like '%"%'
--order by a.FechaDev desc

update a
	set
	 a.Importe_Cab = REPLACE(REPLACE(a.Importe_Cab,'"',''),'á','')
	 ,a.Subtotal = REPLACE(REPLACE(a.Subtotal,'"',''),'á','')
	 ,a.Total_Det = REPLACE(REPLACE(a.Total_Det,'"',''),'á','')
	 ,a.CostoB = REPLACE(a.CostoB,'"','')
	 ,a.CostoN = REPLACE(a.CostoN,'"','')
	 ,a.Sucursal_Det = REPLACE(a.Sucursal_Det,'á',' ')
	 ,a.Folio = REPLACE(a.Folio,'á','')
	 ,a.FechaVencimiento = REPLACE(a.FechaVencimiento,'á','')
	 ,a.FechaMarcaje = REPLACE(a.FechaMarcaje,'á','')
	 ,a.FechaCalculo= REPLACE(a.FechaCalculo,'á','')
	 ,a.FechaCargo = REPLACE(a.FechaCargo,'á','')
	 ,a.Movimiento = REPLACE(a.Movimiento,'á','')
	 ,a.IEPS = REPLACE(a.IEPS,'á','')
	 ,a.IVA = REPLACE(a.IEPS,'á','')
from #Z_DV_Soriana a
--select 
--	a.* 
update a
	set a.FechaDev = REPLACE(a.FechaDev,'-jun','- Jun')
from #Z_DV_Soriana a
where 1 = 1 
	and a.FechaDev like '%-jun%'
--select 
--	a.* 
update a
	set a.FechaDev = REPLACE(a.FechaDev,'-may','- May')
from #Z_DV_Soriana a
where 1 = 1 
	and a.FechaDev like '%-may%'
--select 
--	a.* 
update a
	set a.FechaDev = REPLACE(a.FechaDev,'-abr','- Abr')
from #Z_DV_Soriana a
where 1 = 1 
	and a.FechaDev like '%-abr%'
--select 
--	a.* 
update a
	set a.FechaDev = REPLACE(a.FechaDev,'-sep','- Sep')
from #Z_DV_Soriana a
where 1 = 1 
	and a.FechaDev like '%-sep%'
--select 
--	a.* 
update a
	set a.FechaDev = REPLACE(a.FechaDev,'-jul','- Jul')
from #Z_DV_Soriana a
where 1 = 1 
	and a.FechaDev like '%-jul%'


delete a
from #Z_DV_Soriana a
where 1 = 1
	and a.Folio is null

select * from #Z_DV_Soriana a
where 1 = 1
	and a.Folio is not null

--select * from #Z_DV_Soriana s
--where 1 = 1
--	and s.Cantidad like '%á%'
--	or s.CodigoBarras like '%á%'
--	or s.CostoB like '%á%'
--	or s.CostoN like '%á%'
--	or s.Departamento like '%á%'
--	or s.Descripcion like '%á%'
--	or s.DoctoBase like '%á%'
--	or s.FechaCalculo like '%á%'
--	or s.FechaCargo like '%á%'
--	or s.FechaDev like '%á%'
--	or s.FechaMarcaje like '%á%'
--	or s.FechaVencimiento like '%á%'
--	or s.Folio like '%á%'
--	or s.Folio_Det like '%á%'
--	or s.IEPS like '%á%'
--	or s.Importe_Cab like '%á%'
--	or s.IVA like '%á%'
--	or s.Movimiento like '%á%'
--	or s.Partida like '%á%'
--	or s.Proveedor like '%á%'
--	or s.Sec like '%á%'
--	or s.[Status] like '%á%'
--	or s.Status_Det like '%á%'
--	or s.Subtotal like '%á%'
--	or s.Sucursal like '%á%'
--	or s.Sucursal_Det like '%á%'
--	or s.Talon like '%á%'
--	or s.Total_Det like '%á%'
--	or s.Vigencia like '%á%'

end
--return
--delete a
--from Z_DV_Soriana a
--where 1 = 1
--	--and a.FechaDev like '%jul%'
--	--and a.Sucursal = '632'
--	and CONVERT(date,a.FechaSuida) = '2021-08-18'

if @ValidarSubir = 1
begin
--insert into Z_DV_Soriana
SELECT [Folio]
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
      ,1
      ,GETDATE()
  FROM #Z_DV_Soriana A
		WHERE 1=1
		AND NOT EXISTS (SELECT * FROM [Z_DV_Soriana] B WHERE 
							    convert(int,A.Folio) = convert(int,B.Folio) 
							AND	convert(int,A.Sucursal) = convert(int,B.Sucursal) 
							--AND A.Column4 = B.Importe_Cab
							--AND A.Column2 = B.FechaDev 
							AND A.CodigoBarras = B.CodigoBarras 
							--AND A.Column29 = B.COD_P
							--AND convert(int,A.Column25) = B.Cantidad
							)
SELECT [Folio]
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
      ,1
      ,GETDATE()
  FROM #Z_DV_Soriana A
		WHERE 1=1
		AND EXISTS (SELECT * FROM [Z_DV_Soriana] B WHERE 
							    convert(int,A.Folio) = convert(int,B.Folio) 
							AND	convert(int,A.Sucursal) = convert(int,B.Sucursal) 
							--AND A.Column4 = B.Importe_Cab
							--AND A.Column2 = B.FechaDev 
							AND A.CodigoBarras = B.CodigoBarras 
							--AND A.Column29 = B.COD_P
							--AND convert(int,A.Column25) = B.Cantidad
							)
end
if @Subir = 1
begin
insert into Z_DV_Soriana
SELECT [Folio]
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
      ,1
      ,GETDATE()
  FROM #Z_DV_Soriana A
		WHERE 1=1
		AND NOT EXISTS (SELECT * FROM [Z_DV_Soriana] B WHERE 
							    convert(int,A.Folio) = convert(int,B.Folio) 
							AND	convert(int,A.Sucursal) = convert(int,B.Sucursal) 
							--AND A.Column4 = B.Importe_Cab
							--AND A.Column2 = B.FechaDev 
							AND A.CodigoBarras = B.CodigoBarras 
							--AND A.Column29 = B.COD_P
							--AND convert(int,A.Column25) = B.Cantidad
							)
end
if @VerificarSubida = 1
begin
create table #Devol_Soriana
  	(C_FOLIO	varchar(50)
,	C_SUCURSAL	varchar(50)
,	C_FECHA_	varchar(20)
,	C_IMPORTE	float
,	C_ESTATUS	varchar(25)
,	C_MOVIMIENTO	varchar(10)
,	C_DEPARTAMENTO	varchar(25)
,	C_FECHA_CARGO	varchar(25)
,	C_FECHA_CALCULO	varchar(25)
,	C_FECHA_MOVIMIENTO	varchar(25)
,	C_FECHA_MARCAJE	varchar(25)
,	C_MOTIVO	varchar(30)
,	C_VIGENCIA	varchar(25)
,	D_NUM	int
,	D_SEC	varchar(10)
,	D_CODIGO	varchar(20)
,	D_DESCRIPCION	varchar(100)
,	D_CANT_DEV	int
,	D_COSTO_BRUTO	float
,	D_COSTO_NETO	float
,	D_IMPUESTOS	float
,	D_FACTOR	float
,	D_FECHA_RECIBO	varchar(20)
,	D_DESCUENTO_BASE	varchar(10)
,	D_SUBTOTAL_CALCULADO	float
,	D_IVA	float
,	D_IEPS	float
,	D_TOTAL	float
,	D_PROVEEDOR	varchar(50)
,	D_TIPO_ENTREGA	varchar(20))

TRUNCATE TABLE #Devol_Soriana	

--EXTRAE INFO DE TABLA DE SERVICIO 
Insert into #Devol_Soriana
select 
	 Folio C_FOLIO
	,Sucursal C_SUCURSAL 
	,FechaDev C_FECHA_
	,replace(replace(Importe_Cab,'$',''),',','') C_IMPORTE
	,Status C_ESTATUS
	,Movimiento C_MOVIMIENTO
	,Departamento C_DEPARTAMANETO
	,FechaCargo C_FECHA_CARGO
	,FechaCalculo C_FECHA_CALCULO
	,FechaVencimiento C_FECHA_MOVIMEINTO
	,FechaMarcaje C_FECHA_MARCAJE
	,NULL C_MOTIVO
	,Vigencia C_VIGENCIA
	,Partida D_NUM 
	,Sec D_SEC
	,CodigoBarras D_CODIGO
	,Descripcion D_DESCRIPCION
	,Cantidad D_CANT_DEV
	,replace(replace(CostoB,'$',''),',','') D_COSOTO_BRUTO
	,replace(replace(CostoN,'$',''),',','') D_COSTO_NETO
	,NULL D_IMPUESTOS
	,null D_FACTOR
	,null D_FECHA_RECIBO
	,DoctoBase D_DESCUENTO_BASE
	,replace(replace(subtotal,'$',''),',','') D_SUBTOTAL_CALCULADO
	,null--,replace(replace(iva,'$',''),',','') D_IVA
	,null--,replace(replace(IEPS,'$',''),',','') D_IEPS
	,replace(replace(Total_Det,'$',''),',','') D_TOTAL
	,Proveedor D_PROVEEDOR
	,Talon D_TIPO_ENTREGA
	--,FechaSuida
from Z_DV_Soriana
where COD_P = 1

drop table #Devol_Soriana
end
if @EjecutarSpSoriana = 1
begin
EXEC [Devoluciones_Soriana_Subir_2.0]
end
if @ValidarTablasDevoSoriana = 1
begin
select 
	a.Folio
	,a.Sucursal
	into #FoliSucursalSubidos
from Z_DV_Soriana a
where 1 = 1
	--and a.FechaDev like '%jul%'
	--and a.Sucursal = '632'
	and CONVERT(date,a.FechaSuida) = '2021-08-18'
group by a.Folio
	,a.Sucursal
select * from Devoluciones_Soriana a
where 1 = 1
	and exists (select * from #FoliSucursalSubidos b
				where 1 = 1
				and a.C_FOLIO = b.Folio
				and a.C_SUCURSAL = b.Sucursal)
	--and a.C_FOLIO in ('17704','18854','65150')
	--and a.C_SUCURSAL in ('65','320','632')

select * from Devoluciones_Soriana_Reporte_Acumulado a
where 1 = 1
	and exists (select * from #FoliSucursalSubidos b
				where 1 = 1
				and a.Folio = b.Folio
				and a.Sucursal = b.Sucursal)
	--and a.Folio in ('17704','18854','65150')
	--and a.Sucursal in ('65','320','632')

select * from Devoluciones_Soriana_Reporte_Acumulado_porItem a
where 1 = 1
	and exists (select * from #FoliSucursalSubidos b
				where 1 = 1
				and a.Folio = b.Folio
				and a.Sucursal = b.Sucursal)
	--and a.Folio in ('17704','18854','65150')
	--and a.Sucursal in ('65','320','632')

select top 1 * from Devoluciones_Pagos a
where 1 = 1
	and exists (select * from #FoliSucursalSubidos b
				where 1 = 1
				and a.Folio = b.Folio
				and a.Sucursal = b.Sucursal)
	--and a.Folio in ('17704','18854','65150')
	--and a.Sucursal in ('65','320','632')
--25- Jul-20 07- Abr-20 13-abr-21 14-jul-21
end
if @EjecutarSpSubidaDevo = 1
begin
EXEC [Control_Entregas_AlimentarDevoluciones]
EXEC [dbo].[Devoluciones_ConcentradoTotal_Subir]
EXEC [dbo].[Devoluciones_ConcentradoTotalCabecero_Subir]
end

return

select 
	*
	--delete a
from Z_DV_Soriana a
where 1 = 1
	and CONVERT(date,a.FechaSuida) ='2021-08-20'