drop table #Maestro_Sucursales 
select * 
into #Maestro_Sucursales 
from Maestro_Sucursales a
where 1 = 1
	--and a.Folio = '0110033217'
	--and a.Tienda = '01003'
	and a.Modulo = 'Devolución'
	and a.Cadena = 'Walmart'


declare 
	 @Bulk_Insert varchar(max) = null
	,@FilePath varchar(max) = 'H:\Desarrollo\Devolucion Walmart\'
	,@FileExtension varchar(max) = '.txt'
	,@FileName2 varchar(max) = 'Devoluciones WM 22.12.2021'

create table #Folios
(
	ID_Factura varchar(max)
	,Folio varchar(max)
	,Id_Mov varchar(max)
	,Tienda varchar(max)
	,Orden_Compra varchar(max)
	,UPC varchar(max)
	,Descr varchar(max)
	,Cantidad varchar(max)
	,Costo varchar(max)
	,IVA_por100 varchar(max)
	,IVA varchar(max)
	,IEPS_por100 varchar(max)
	,IEPS varchar(max)
	,Subtotal varchar(max)
	,Importe_Total varchar(max)

)

TRUNCATE TABLE #Folios

set @Bulk_Insert = 'BULK INSERT #Folios FROM ''' + @FilePath + @FileName2 + @FileExtension + ''' WITH
		(
			CODEPAGE = ''1252'',
			DATAFILETYPE =''char'',
			FIELDTERMINATOR =''	'',
			ROWTERMINATOR = ''\n'',
			FIRSTROW = 1
			
		)'

execute (@Bulk_Insert)

drop table #Reclamo
select  distinct
	'0' + Tienda as Tienda
	,'0' + Folio as Folio
	into #Reclamo
from #Folios


drop table #Pendientes
select distinct
	 Tienda
	,Folio
	,Importe as ImporteCabecero
	,IVA
	,SUM(DET_ImporteTotal) as ImporteDetalle
	,'Pendientes' as Origen
	into #Pendientes
from Z_DV_Pendientes_Walmart
group by
	Tienda
	,Folio
	,Importe 
	,IVA

drop table #Pendientes_DescargaIncompleta
select distinct
	Tienda
	,Folio
	,Importe as ImporteCabecero
	,IVA
	,SUM(DET_ImporteTotal) as ImporteDetalle
	,'Pendiente descarga incompleta' as Origen
	into #Pendientes_DescargaIncompleta
from Z_DV_Pendientes_Walmart_DescargaIncompleta
group by
	Tienda
	,Folio
	,Importe
	,IVA

drop table #Pagadas
select distinct
	Tienda
	,Folio
	,Importe as ImporteCabecero
	,IVA
	,SUM(DET_ImporteTotal) as ImporteDetalle
	,'Pagadas' as Origen
	into #Pagadas
from Z_DV_Pagadas_Walmart
group by
	Tienda
	,Folio
	,Importe
	,IVA

drop table #Pagadas_DescargaIncompleta
select distinct
	Tienda
	,Folio
	,Importe as ImporteCabecero
	,IVA
	,SUM(DET_ImporteTotal) as ImporteDetalle
	,'Pagadas descarga incompleta' as Origen
	into #Pagadas_DescargaIncompleta
from Z_DV_Pagadas_Walmart_DescargaIncompleta
group by
	Tienda
	,Folio
	,Importe
	,IVA

delete a
from #Pendientes a
where 1 = 1
	and not exists (select * from #Reclamo b
	where 1 = 1
		and a.Folio = b.Folio
		and a.Tienda = b.Tienda)

delete a
from #Pendientes_DescargaIncompleta a
where 1 = 1
	and not exists (select * from #Reclamo b
	where 1 = 1
		and a.Folio = b.Folio
		and a.Tienda = b.Tienda)

delete a
from #Pagadas a
where 1 = 1
	and not exists (select * from #Reclamo b
	where 1 = 1
		and a.Folio = b.Folio
		and a.Tienda = b.Tienda)

delete a
from #Pagadas_DescargaIncompleta a
where 1 = 1
	and not exists (select * from #Reclamo b
	where 1 = 1
		and a.Folio = b.Folio
		and a.Tienda = b.Tienda)

select 
	 a.Tienda
	,a.Folio
	,b.Origen as Pendientes
	,b.ImporteCabecero 
	,b.IVA
	,b.ImporteDetalle
	,c.Origen as Pendientes_DI
	,c.ImporteCabecero 
	,c.IVA
	,c.ImporteDetalle
	,d.Origen as Pagadas
	,d.ImporteCabecero 
	,d.IVA
	,d.ImporteDetalle
	,e.Origen as Pagadas_DI
	,e.ImporteCabecero 
	,e.IVA
	,e.ImporteDetalle
	,ms.Oracle
	,z.[Importe Pago]
	,z.[Importe Portales]
from #Reclamo a

	left outer join #Pendientes b
	on a.Folio = b.Folio
	and a.Tienda = b.Tienda

	left outer join #Pendientes_DescargaIncompleta c
	on a.Folio = c.Folio
	and a.Tienda = c.Tienda

	left outer join #Pagadas d
	on a.Folio = d.Folio
	and a.Tienda = d.Tienda

	left outer join #Pagadas_DescargaIncompleta e
	on a.Folio = e.Folio
	and a.Tienda = e.Tienda

	left outer join #Maestro_Sucursales ms
	on a.Tienda = ms.Sucursal

	left outer join Devoluciones_Carga_ORACLE_Auditoria_SinIVA z
	on ms.Oracle = z.Oracle
	and substring(a.Folio,2,200) = z.Folio