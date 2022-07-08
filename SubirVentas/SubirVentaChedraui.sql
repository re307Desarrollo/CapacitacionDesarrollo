create table #VentaChedraui(
	Column1 varchar(max)
	,Column2 varchar(max)
	,Column3 varchar(max)
	,Column4 varchar(max)
	,Column5 varchar(max)
	,Column6 varchar(max)
	,Column7 varchar(max)
	,Column8 varchar(max)
	,Column9 varchar(max)
	,Column10 varchar(max)
	,Column11 varchar(max)
	,Column12 varchar(max)
	,Column13 varchar(max)
	,Column14 varchar(max)
	,Column15 varchar(max)
	,Column16 varchar(max)
	,Column17 varchar(max)
	,Column18 varchar(max)
	,Column19 varchar(max)
	,Column20 varchar(max)
	,Column21 varchar(max)
	,Column22 varchar(max)
	,Column23 varchar(max)
	,Column24 varchar(max)
	,Column25 varchar(max)
	,Column26 varchar(max)
)

--BULK INSERT #VentaWalmart FROM 'H:\Desarrollo\AuditoriaVenta\8.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
--BULK INSERT #VentaChedraui FROM 'H:\Desarrollo\Venta Chedraui\2022-01-01.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
--BULK INSERT #VentaChedraui FROM 'H:\Desarrollo\Venta Chedraui\2022-01-02.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
--BULK INSERT #VentaChedraui FROM 'H:\Desarrollo\Venta Chedraui\2022-01-03.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
--BULK INSERT #VentaChedraui FROM 'H:\Desarrollo\Venta Chedraui\2022-01-04.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 1);
BULK INSERT #VentaChedraui FROM 'H:\Desarrollo\Venta Chedraui\2022-07-05.txt' WITH (FIELDTERMINATOR= '|',FIRSTROW = 1);

--select * from #VentaChedraui


delete a
from #VentaChedraui a
where 1 = 1
	and ISNUMERIC(a.Column7) = 0


--select * from #VentaChedraui


select 
	SUBSTRING(a.Column1,0,5)+'-'+SUBSTRING(a.Column1,5,2)+'-'+SUBSTRING(a.Column1,7,2) Fecha
	,REVERSE(SUBSTRING(SUBSTRING(REVERSE(a.Column6),CHARINDEX(' ',REVERSE(a.Column6),0)+1,LEN(REVERSE(a.Column6))),CHARINDEX(' ',SUBSTRING(REVERSE(a.Column6),CHARINDEX(' ',REVERSE(a.Column6),0)+1,LEN(REVERSE(a.Column6))),0),LEN(SUBSTRING(REVERSE(a.Column6),CHARINDEX(' ',REVERSE(a.Column6),0)+1,LEN(REVERSE(a.Column6)))))) Descripcion
	,a.Column5 SKU
	,a.Column3 Sucursal
	--,CONVERT(float,a.Column8)PVD
	--,CONVERT(float,0)PVP
	,null PVD
	,null PVP
	,CONVERT(int,a.Column7) Ejemplares
	--,a.Column7
	,1 COD_p
	--,GETDATE() FechaSubida
	,TRIM(a.Column3)+' '+a.Column4 Nombresucursal
	into #Z_VE_Chedraui_Subida
from #VentaChedraui a

--select * 
--from #VentaChedraui a
--where 1 = 1
--	and ISNUMERIC(a.Column7) = 0

select 
	a.Fecha
	,a.Descripcion
	,a.SKU
	,SUM(a.PVD) PVD
	,SUM(a.PVP) PVP
	,SUM(a.Ejemplares) Ejemplares
	,a.Sucursal
	,a.Nombresucursal
	into #Final
from #Z_VE_Chedraui_Subida a
group by 
	a.Fecha
	,a.Descripcion
	,a.SKU
	,a.Sucursal
	,a.Nombresucursal

--select * from #Final
--select top 100 * from Z_VE_Chedraui

--select top 1 
--	* 
--	into #Z_VE_Chedraui
--from Z_VE_Chedraui

--truncate table #Z_VE_Chedraui

Select distinct Fecha
into #Analizar
from Z_VE_Chedraui
where 1 = 1
	and Fecha in (Select distinct Fecha from #Final)

delete a 
from Z_VE_Chedraui a
where 1 = 1
	and Fecha in (Select Fecha from #Analizar)


Insert into Z_VE_Chedraui
Select
	 a.Fecha
	,a.Descripcion
	,a.SKU
	,a.Sucursal
	,a.PVD
	,a.PVP
	,a.Ejemplares  
	,1 COD_p
	,GETDATE() FechaSubida
	,NombreSucursal
from #Final a

--select * from #Z_VE_Chedraui
	
--		 Select distinct --top 100
--			  Fecha FechaVenta_Chedraui
--			 ,sum(Ejemplares) Ejemplares
--			 ,sum(PVD) Importe
--			 ,FechaSubida
--		FROM #Z_VE_Chedraui
--		where 1 = 1
--		group by Fecha,FechaSubida
--		  order by FechaVenta_Chedraui desc

drop table 
	#VentaChedraui,
	#Z_VE_Chedraui_Subida,
	#Final,
	#Analizar--,
	--#Z_VE_Chedraui