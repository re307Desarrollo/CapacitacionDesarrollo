declare 
	 @Bulk_Insert varchar(max) = null
	,@FilePath varchar(max) = 'H:\Desarrollo\Devolucion Walmart\'
	,@FileExtension varchar(max) = '.txt'
	,@FileName2 varchar(max) = 'Folios con diferencia WM'

create table #Folios_Liberar(
Tienda varchar(max)
,Folio varchar(max)
,l1 varchar(max)
,Pendientes varchar(max)
,ImporteCabecero varchar(max)
,IVA varchar(max)
,ImporteDetalle varchar(max)
,l2 varchar(max)
,Pendientes_DI varchar(max)
,Pendientes_DIImporteCabecero varchar(max)
,Pendientes_DIIVA varchar(max)
,Pendientes_DIImporteDetalle varchar(max)
,l3 varchar(max)
,Pagadas varchar(max)
,PagadasImporteCabecero varchar(max)
,PagadasIVA varchar(max)
,PagadasImporteDetalle varchar(max)
,l4 varchar(max)
,Pagadas_DI varchar(max)
,Pagadas_DIImporteCabecero varchar(max)
,Pagadas_DIIVA varchar(max)
,Pagadas_DIImporteDetalle varchar(max)
,l5 varchar(max)
,Oracle varchar(max)
,Importe_Pago varchar(max)
,Importe_Portales varchar(max)

)

TRUNCATE TABLE #Folios_Liberar

set @Bulk_Insert = 'BULK INSERT #Folios_Liberar FROM ''' + @FilePath + @FileName2 + @FileExtension + ''' WITH
		(
			CODEPAGE = ''1252'',
			DATAFILETYPE =''char'',
			FIELDTERMINATOR =''	'',
			ROWTERMINATOR = ''\n'',
			FIRSTROW = 2
			
		)'

execute (@Bulk_Insert)

select 
	* 
	into #PendientesDescargaIncompleta
from #Folios_Liberar a
where 1 = 1
	and a.Pendientes_DI != 'NULL'
select 
	*
	into #PagadasDescargaIncompleta
from #Folios_Liberar a
where 1 = 1
	and a.Pendientes_DI = 'NULL'
	and a.Pagadas_DI != 'NULL'

select top 1 * into #Z_DV_Pendientes_Walmart from Z_DV_Pendientes_Walmart

truncate table #Z_DV_Pendientes_Walmart

--select top 1 * from Z_DV_Pendientes_Walmart

insert into #Z_DV_Pendientes_Walmart
select 
	* 
from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	and exists(select * from #PendientesDescargaIncompleta b
				where 1 = 1 
					and '0'+b.Folio = a.Folio
					and '0'+b.Tienda = a.Tienda)


insert into #Z_DV_Pendientes_Walmart
select 
	  a.[CIA]
      ,a.[IdMov]
      ,a.[Tienda]
      ,a.[Depto]
      ,a.[Folio]
      ,a.[Factura]
      ,a.[FechaPago]
	  ,null [FechaVencimiento]
      ,a.[Importe]
	  ,null [Estatus]
      ,a.[OrdenCompra]
      ,a.[IVA]
      ,a.[IEPSTotal]
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
      --,a.[TipoPago]
      --,a.[NoCheque]
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
      ,a.[FechaSubida]
from Z_DV_Pagadas_Walmart_DescargaIncompleta a
where 1 = 1
	and exists(select * from #PagadasDescargaIncompleta b
				where 1 = 1 
					and '0'+b.Folio = a.Folio
					and '0'+b.Tienda = a.Tienda)
	--and not exists(select * from Z_DV_Pendientes_Walmart c
	--			where 1 = 1 
	--				and c.Folio = a.Folio
	--				and c.Tienda = a.Tienda)

insert into Z_DV_Pendientes_Walmart
select 
	* 
from #Z_DV_Pendientes_Walmart a
where 1 = 1
	and not exists(select * from Z_DV_Pendientes_Walmart b
					where 1 = 1
						and b.Folio = a.Folio
						and b.Tienda = a.Tienda)
drop table 
	#Folios_Liberar,
	#PagadasDescargaIncompleta,
	#PendientesDescargaIncompleta,#Z_DV_Pendientes_Walmart