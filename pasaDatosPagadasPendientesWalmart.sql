declare 
	 @Bulk_Insert varchar(max) = null
	,@FilePath varchar(max) = 'H:\Desarrollo\Devolucion Walmart\'
	,@FileExtension varchar(max) = '.txt'
	,@FileName2 varchar(max) = 'SolicitudLiberacionWalmart'

create table #LiberarPagadas
(
	FolioSucursal varchar(max)
	,Voucher varchar(max)
	,Oracle_Solicitado varchar(max)
	,Sucursal varchar(max)
	,Folio varchar(max)
	,Importe_Pago varchar(max)
	,Importe_Portales varchar(max)
	,Importe_Portales_IVA varchar(max)
	,Importe_Oracle varchar(max)
	,No_column_name varchar(max)
	,Oracle varchar(max)
	,Sucursal_Portal varchar(max)
	,ImporteCabecero varchar(max)
	,ImporteDetalle varchar(max)
	,IVA varchar(max)
	,FechaRecibo varchar(max)
	,FechaSubida varchar(max)
	,Origen varchar(max)
	,OracleDiferente varchar(max)
	,Link varchar(max)
	,Seleccion varchar(max)


)

TRUNCATE TABLE #LiberarPagadas

set @Bulk_Insert = 'BULK INSERT #LiberarPagadas FROM ''' + @FilePath + @FileName2 + @FileExtension + ''' WITH
		(
			CODEPAGE = ''1252'',
			DATAFILETYPE =''char'',
			FIELDTERMINATOR =''	'',
			ROWTERMINATOR = ''\n'',
			FIRSTROW = 2
			
		)'

execute (@Bulk_Insert)

select 'PagadasSolicitadas'
select distinct b.Folio,b.Sucursal  from #LiberarPagadas b
where 1 = 1
	and b.Origen  = 'Pagadas'

select 'Pagadas en Z_DV_Pagadas_Walmart agrupadas'
select 
	a.Folio
	,a.Tienda
	,a.Importe Importe_Cabecero
	,SUM(a.DET_ImporteTotal) Importe_Total
from Z_DV_Pagadas_Walmart a
where 1 = 1
	and exists(select distinct b.Folio,b.Sucursal  from #LiberarPagadas b
				where 1 = 1
					and b.Origen  = 'Pagadas'
					and '0'+b.Sucursal = a.Tienda
					and '0'+b.Folio = a.Folio
				)
group by 
	a.Folio
	,a.Tienda
	,a.Importe

select 'Sin agrupar'
select * from Z_DV_Pagadas_Walmart a
where 1 = 1
	and exists(select distinct b.Folio,b.Sucursal  from #LiberarPagadas b
				where 1 = 1
					and b.Origen  = 'Pagadas'
					and '0'+b.Sucursal = a.Tienda
					and '0'+b.Folio = a.Folio
				)
insert into Z_DV_Pendientes_Walmart
SELECT 
		a.[CIA]
      ,a.[IdMov]
      ,a.[Tienda]
      ,a.[Depto]
      ,a.[Folio]
      ,a.[Factura]
      ,a.[FechaPago]
      ,a.[FechaPago]
      ,a.[Importe]
      ,null
      ,a.[OrdenCompra]
      ,a.[IVA]
      ,null
      ,a.[IVABebidaEnerg]
      ,a.[IVABebidaM20G]
      ,a.[IVACerveza]
      ,a.[IVABebidaH20G]
      ,a.[IVACalorifico]
      ,a.[IVAVinos]
      ,a.[IVACoolers]
      ,a.[IVAPlaguisida6]
      ,a.[IVAPlaguisida7]
      ,a.[IVAPlaguisida9]
      ,a.[IDFactura]
      ,a.[UUID]
      ,a.[Base]
      ,a.[DET_IDFactura]
      ,a.[DET_Folio]
      ,a.[DET_IDMov]
      ,a.[DET_Tienda]
      ,a.[DET_OrdenCompra]
      ,a.[DET_UPC]
      ,a.[DET_Desc]
      ,a.[DET_Cantidad]
      ,a.[DET_Costo]
      ,a.[DET_IVA%]
      ,a.[DET_IVA]
      ,a.[DET_IEPS%]
      ,a.[DET_IEPS]
      ,a.[DET_Subtotal]
      ,a.[DET_ImporteTotal]
      ,a.[COD_P]
      ,GETDATE()
  FROM [Global].[dbo].[Z_DV_Pagadas_Walmart] a
where 1 = 1
	and exists(select distinct b.Folio,b.Sucursal  from #LiberarPagadas b
				where 1 = 1
					and b.Origen  = 'Pagadas'
					and '0'+b.Sucursal = a.Tienda
					and '0'+b.Folio = a.Folio
				)
	and not exists(select * from Z_DV_Pendientes_Walmart c
					where 1 = 1
						and a.Tienda = c.Tienda
						and a.Folio = c.Folio)
--drop table #LiberarPagadas