create table #DevolucionSanbornsSubir(
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
)
BULK INSERT #DevolucionSanbornsSubir FROM 'H:\Desarrollo\Devolucion Sanborns\DevolucionCargar.txt'  
WITH (
	FIELDTERMINATOR= '	'
	--,CODEPAGE = 1252
	,FIRSTROW = 2
	,ROWTERMINATOR = '\n'
);

--select * from #DevolucionSanbornsSubir

insert into Z_DV_Sanborns
select
	a.Column9
	,a.Column8
	,CONVERT(date,a.Column7)
	,CONVERT(float,REPLACE(REPLACE(a.Column10,'"',''),',',''))*-1
	,a.Column2
	,a.Column2
	,a.Column3
	,CONVERT(int,REPLACE(REPLACE(a.Column4,'"',''),',',''))*-1
	,CONVERT(float,REPLACE(REPLACE(a.Column5,'"',''),',',''))
	,CONVERT(float,REPLACE(REPLACE(a.Column6,'"',''),',',''))*-1
	,1 COD_P
	,GETDATE()
from #DevolucionSanbornsSubir a
where 1 = 1
	and not exists(select * from Z_DV_Sanborns b
					where 1 = 1
						and b.Devolucion = a.Column8
						and b.Sucursal = a.Column9
					)



drop table #DevolucionSanbornsSubir