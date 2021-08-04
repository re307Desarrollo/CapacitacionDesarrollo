﻿/*
truncate table [EliminarDropbox]
BULK INSERT EliminarDropbox FROM 'H:\Desarrollo\EliminarDropbox.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 2);
select * from [EliminarDropbox]
where 1 = 1
and Sucursal is not null
order by Sucursal

--Dropbox eliminar IMMEX IMPULSORA DE MERCADOS DE MEXICO, S. A. DE C. V. //solo cuando no es una cadena con portal y bot de descarga Desarrollo
*/

declare 
	  @deletePago bit = 0
	 ,@deleteDropbox bit = 0
	 ,@deleteOracle bit = 0

declare 
	 @Oracle varchar(max) = ''
	,@Folio varchar(max) = ''
	,@Sucursal varchar(max) = ''

if @deleteDropbox = 0
begin

select cr.Razon_Social, a.* 
from Devoluciones_Pagos a
	left outer join E_Carta_de_Rutas cr
	on a.Oracle = cr.No_Cliente
where 1 = 1
	--and Oracle = @Oracle
	--and Folio = @Folio
	and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.Oracle = b.Oracle
			and a.Folio = b.Folio
			and a.Sucursal = b.Sucursal)
--and a.[Nota Crédito] is not null
and a.ImportePortalesWeb is null--si al quitar este filtro aparecen, las transacciones ya estan en Oreacle
--and a.Folio = '456'
--and cr.Razon_Social != 'CASA LEY, SAPI DE CV'

--select * from Devoluciones_Carga_ORACLE_Auditoria_SinIVA a
--where 1 = 1
--	--and Oracle = @Oracle
--	--and Folio = @Folio
--	and exists (select * from [EliminarDropbox] b
--		where 1 = 1	
--			and a.Oracle = b.Oracle
--			and a.Folio = b.Folio
--			and a.Sucursal = b.Sucursal)
----and a.[Nota Crédito] is not null
--and a.[Importe Oracle] is null
--order by [Importe Oracle]



select distinct Sucursal, Folio from Devoluciones_OperadoraSierra a
where 1 = 1
	--and Sucursal = @Sucursal
	--and Folio = @Folio
	and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.Folio = b.Folio
			and a.Sucursal = b.Sucursal
			)

select * from Devoluciones_OperadoraSierra a
where 1 = 1
	--and Sucursal = @Sucursal
	--and Folio = '456'
	and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.Folio = b.Folio
			and a.Sucursal = b.Sucursal
			)


select * from Devoluciones_OperadoraSierra_Reporte_Acumulado a
where 1 = 1
	--and cliente = @Oracle
	--and Folio = @Folio
	--and Folio = '456'
	and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.cliente = b.Oracle
			and a.Folio = b.Folio
			--and a.Sucursal = b.Sucursal
			)

select * from Devoluciones_OperadoraSierra_Reporte_Acumulado_porItem a
where 1 = 1
	--and cliente = @Oracle
	--and Folio = @Folio
	--and Folio = '456'
		and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.cliente = b.Oracle
			and a.Folio = b.Folio
			--and a.Sucursal = b.Sucursal
			)


select * from AcreditacionPortalesWeb a
where 1 = 1
	--and cliente = @Oracle
	--and Folio = @Folio
	--and Folio = '456'
		and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.Oracle = b.Oracle
			and a.FolioDevolucion = b.Folio
			--and a.Sucursal = b.Sucursal
			)

	end



if @deleteDropbox = 1
	begin
		delete a
		from Devoluciones_OperadoraSierra a
		where 1 = 1
			--and Sucursal = @Sucursal
			--and Folio = @Folio
			and exists (select * from [EliminarDropbox] b
				where 1 = 1	
					and a.Folio = b.Folio
					and a.Sucursal = b.Sucursal)

		delete a
		from Devoluciones_OperadoraSierra_Reporte_Acumulado a
		where 1 = 1
			--and cliente = @Oracle
			--and Folio = @Folio
			and exists (select * from [EliminarDropbox] b
				where 1 = 1	
					and a.cliente = b.Oracle
					and a.Folio = b.Folio
					--and a.Sucursal = b.Sucursal
					)

		delete a
		from Devoluciones_OperadoraSierra_Reporte_Acumulado_porItem a
		where 1 = 1
			--and cliente = @Oracle
			--and Folio = @Folio
				and exists (select * from [EliminarDropbox] b
				where 1 = 1	
					and a.cliente = b.Oracle
					and a.Folio = b.Folio
					--and a.Sucursal = b.Sucursal
					)
	end

if @deletePago = 1
	begin
		delete a
		from Devoluciones_Pagos a
		where 1 = 1
			--and Oracle = @Oracle
			--and Folio = @Folio
			and exists (select * from [EliminarDropbox] b
				where 1 = 1	
					and a.Oracle = b.Oracle
					and a.Folio = b.Folio
					and a.Sucursal = b.Sucursal)
		--and a.[Nota Crédito] is not null
		and a.ImportePortalesWeb is null--si al quitar este filtro aparecen, las transacciones ya estan en Oreacle

		delete a
		from Devoluciones_Carga_ORACLE_Auditoria a
		where 1 = 1
			--and Oracle = @Oracle
			--and Folio = @Folio
			and exists (select * from [EliminarDropbox] b
				where 1 = 1	
					and a.Oracle = b.Oracle
					and a.Folio = b.Folio
					and a.Sucursal = b.Sucursal)
		--and a.[Nota Crédito] is not null
		and a.[Importe Oracle] is null
	end

if @deleteOracle = 1
begin
	
delete a from AcreditacionPortalesWeb a
where 1 = 1
	--and cliente = @Oracle
	--and Folio = @Folio
	--and Folio = '456'
		and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.Oracle = b.Oracle
			and a.FolioDevolucion = b.Folio
			--and a.Sucursal = b.Sucursal
			)
end

	return


	/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (1000) [Sucursal]
--      ,[Oracle]
--      ,[Folio]
--      ,[Importe]
--  FROM [Global].[dbo].[EliminarDropbox]

--  truncate table [EliminarDropbox]

--  select * from E_Carta_de_Rutas
--  where  1 = 1	
--  --and No_Cliente = '93407'
--  and Razon_Social like '%IMPULSORA DE MERCADOS DE MEXICO, S. A. DE C. V.%'
  