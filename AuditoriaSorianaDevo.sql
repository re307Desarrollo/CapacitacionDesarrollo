declare 
	 @Bulk_Insert varchar(max) = null
	,@FilePath varchar(max) = 'H:\Desarrollo\Devolucion Soriana\'
	,@FileExtension varchar(max) = '.txt'
	,@FileName2 varchar(max) = 'FoliosFaltantes'

create table #Folios
(
	Sucursal varchar(max)
	,Oracle varchar(max)
	,Folio varchar(max)

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


select 
	b.Oracle
	,a.Sucursal
	,a.Folio
	,a.Total_Det Importe
	,SUM(CONVERT(float,REPLACE(REPLACE(REPLACE(a.CostoN,'$',''),',',''),'"','')))ImporteDetalle
	,a.FechaDev FechaDevolucion
	,a.FechaSuida
	into #Z_DV_Soriana
from Z_DV_Soriana a

	left outer join Maestro_Sucursales b
	on a.Sucursal = b.Sucursal

where 1 = 1
	and b.Modulo = 'Devolución'
	and b.Cadena = 'Soriana'
group by b.Oracle
	,a.Sucursal
	,a.Folio
	,a.Total_Det
	,a.FechaDev
	,a.FechaSuida

select 
	b.Oracle
	,a.sucursal
	,a.Folio
	,a.importe_Cab Importe
	,a.ImporteDetalle ImporteDetalle
	,a.FechaSubida
	into #Z_DV_Soriana_DescargaIncompleta_
from Z_DV_Soriana_DescargaIncompleta_ a

	left outer join Maestro_Sucursales b
	on a.Sucursal = b.Sucursal

where 1 = 1
	and b.Modulo = 'Devolución'
	and b.Cadena = 'Soriana'
order by a.FechaSubida desc

select   
	 a.Voucher
	,a.Oracle
	,a.Sucursal
	,a.Folio
	,a.[Importe Pago]
	,a.[Importe Portales]
	,a.[Importe Portales IVA]
	,a.[Importe Oracle]
	,'//'
	,case
		when (b.Oracle)is not null then b.Oracle
		when (c.Oracle)is not null then c.Oracle
		else null
	end Oracle
	,case 
		when (b.Oracle) is Not null then b.Importe
		when (c.Oracle) is Not null then c.Importe
		else null
	 end as ImporteCabecero
	,case 
		when (b.Oracle) is Not null then b.ImporteDetalle
		when (c.Oracle) is Not null then c.ImporteDetalle
		else null 
	 end as ImporteDetalle
	,case 
		when (b.Oracle) is Not null then b.FechaDevolucion
		when (c.Oracle) is Not null then null
		else null 
	 end as FechaRecibo_Pago
	,case 
		when (b.Oracle) is Not null then b.FechaSuida
		when (c.Oracle) is Not null then c.FechaSubida
		else null 
	 end as FechaSubida
	,case 
		when (b.Oracle) is Not null then 'Detalle'
		when (c.Oracle) is Not null then 'Detalle Incompleto'
		else null 
	 end as Origen
	 ,case 
		when (a.Oracle) != (case 
		when (b.Oracle) is Not null then b.Oracle
		when (c.Oracle) is Not null then c.Oracle
		else null 
	 end) then 'SI' else 'NO' end as OracleDiferente
from Devoluciones_Carga_ORACLE_Auditoria_SinIVA a

	left outer join #Z_DV_Soriana b
	on a.Folio = b.Folio
	and a.Sucursal = b.Sucursal

	left outer join #Z_DV_Soriana_DescargaIncompleta_ c
	on a.Folio = c.Folio
	and a.Sucursal = c.sucursal

where 1 = 1
	and exists (select * from #Folios d
		where 1 = 1
			and a.Sucursal = d.Sucursal
			--and a.Oracle = b.Oracle
			and a.Folio = d.Folio)
	--and a.Origen is not null
order by a.Folio asc

drop table #Folios,#Z_DV_Soriana,#Z_DV_Soriana_DescargaIncompleta_