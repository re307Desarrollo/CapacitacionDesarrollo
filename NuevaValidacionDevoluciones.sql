declare
	@FechaSubida date = DATEADD(dd,0,GETDATE())


select @FechaSubida fecha

--select * from [10.7.216.90,2717].[Global].[dbo].[Z_DV_Sanborns]
select 
	'Z_DV_Liverpool_SKU' Tabla
	,a.Ean Folio
	,CONVERT(date,a.Fecha_Subida) FechaSubida
	into #Folios_Liverpool_SKU
from Z_DV_Liverpool_SKU a
where 1 = 1
	and CONVERT(date,a.Fecha_Subida) = @FechaSubida
group by
	CONVERT(date,a.Fecha_Subida)
	,a.Ean

select 
	'Z_DV_Liverpool' Tabla
	,a.NroReferen Folio
	,CONVERT(date,a.FechaSubida) FechaSubida
	into #Folios_Liverpool
from Z_DV_Liverpool a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by
	CONVERT(date,a.FechaSubida)
	,a.NroReferen

select 
	'Z_DV_Pendientes_Walmart' Tabla
	,a.Folio
	,CONVERT(date,a.FechaSubida) FechaSubida
	into #Folios_Walmart
from Z_DV_Pendientes_Walmart a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by
	CONVERT(date,a.FechaSubida)
	,a.Folio

select 
	'Z_DV_Sanborns' Tabla
	,a.Devolucion FOLIO
	,CONVERT(date,a.FechaSubida) FechaSubida
	into #Folios_Sanborns
from Z_DV_Sanborns a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by
	CONVERT(date,a.FechaSubida)
	,a.Devolucion

--select * from Z_DV_Liverpool

select 
	'Z_DV_Soriana' Tabla
	,a.FOLIO
	,CONVERT(date,a.FechaSuida) FechaSubida
	into #Folios_Soriana
from Z_DV_Soriana a
where 1 = 1
	and CONVERT(date,a.FechaSuida) = @FechaSubida
group by
	CONVERT(date,a.FechaSuida)
	,a.FOLIO
	

select 
	'Z_DV_CityFresko' Tabla
	,a.FOLIO
	,CONVERT(date,a.FechaSubida) FechaSubida
	into #Folios_CityFresko
from Z_DV_CityFresko a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by
	CONVERT(date,a.FechaSubida)
	,a.FOLIO

select
	'Z_DV_Chedraui' Tabla
	,a.FOLIO
	,CONVERT(date,a.FechaSubida) FechaSubida
	into #Folios_Chedraui
from Z_DV_Chedraui a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by
	CONVERT(date,a.FechaSubida)
	,a.FOLIO
order by 
	CONVERT(date,a.FechaSubida) desc

select
	'Z_DV_Chedraui_Sucursal' Tabla
	,a.FOLIO
	,CONVERT(date,a.FechaSubida) FechaSubida
	into #Folios_Chedraui_Sucursal
from Z_DV_Chedraui_Sucursal a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by
	CONVERT(date,a.FechaSubida)
	,a.FOLIO
order by 
	CONVERT(date,a.FechaSubida) desc

select 
	a.Tabla
	,COUNT(a.FOLIO)Folios
	,a.FechaSubida
	into #TotalFolios_Liverpool_SKU
from #Folios_Liverpool_SKU a
where 1 = 1
	--and a.FOLIO > 0
group by 
	a.Tabla
	,a.FechaSubida


select 
	a.Tabla
	,COUNT(a.FOLIO)Folios
	,a.FechaSubida
	into #TotalFolios_Liverpool
from #Folios_Liverpool a
where 1 = 1
	--and a.FOLIO > 0
group by 
	a.Tabla
	,a.FechaSubida

select 
	a.Tabla
	,COUNT(a.FOLIO)Folios
	,a.FechaSubida
	into #TotalFolios_Walmart
from #Folios_Walmart a
where 1 = 1
	--and a.FOLIO > 0
group by 
	a.Tabla
	,a.FechaSubida

select 
	a.Tabla
	,COUNT(a.FOLIO)Folios
	,a.FechaSubida
	into #TotalFolios_Chedraui_Sucursal
from #Folios_Chedraui_Sucursal a
where 1 = 1
	and a.FOLIO > 0
group by 
	a.Tabla
	,a.FechaSubida

select 
	a.Tabla
	,COUNT(a.FOLIO)Folios
	,a.FechaSubida
	into #TotalFolios_CityFresko
from #Folios_CityFresko a
where 1 = 1
	--and a.FOLIO > 0
group by 
	a.Tabla
	,a.FechaSubida

select 
	a.Tabla
	,COUNT(a.FOLIO)Folios
	,a.FechaSubida
	into #TotalFolios_Sanborns
from #Folios_Sanborns a
where 1 = 1
	--and a.FOLIO > 0
group by 
	a.Tabla
	,a.FechaSubida

select 
	a.Tabla
	,COUNT(a.FOLIO)Folios
	,a.FechaSubida
	into #TotalFolios_Chedraui
from #Folios_Chedraui a
where 1 = 1
	--and a.FOLIO > 0
group by 
	a.Tabla
	,a.FechaSubida

select 
	a.Tabla
	,COUNT(a.FOLIO)Folios
	,a.FechaSubida
	into #TotalFolios_Soriana
from #Folios_Soriana a
where 1 = 1
	--and a.FOLIO > 0
group by 
	a.Tabla
	,a.FechaSubida


create table #ConsultaBotsRetails(
	Tabla varchar(max)
	,Registros int
	,Folios int
	,FechaSubida date
)
insert into #ConsultaBotsRetails
select 
	'Z_DV_Liverpool_SKU' Tabla
	,COUNT(*) Registros
	,null
	,CONVERT(date,a.Fecha_Subida)FechaSubida
from Z_DV_Liverpool_SKU a
where 1 = 1
	and CONVERT(date,a.Fecha_Subida) = @FechaSubida
group by 
	CONVERT(date,a.Fecha_Subida)

insert into #ConsultaBotsRetails
select 
	'Z_DV_Pendientes_Walmart' Tabla
	,COUNT(*) Registros
	,null
	,CONVERT(date,a.FechaSubida)FechaSubida
from Z_DV_Pendientes_Walmart a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by 
	CONVERT(date,a.FechaSubida)


insert into #ConsultaBotsRetails
select 
	'Z_DV_Chedraui_Sucursal' Tabla
	,COUNT(*) Registros
	,null
	,CONVERT(date,a.FechaSubida)FechaSubida
from Z_DV_Chedraui_Sucursal a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by 
	CONVERT(date,a.FechaSubida)


insert into #ConsultaBotsRetails
select 
	'Z_DV_Chedraui' Tabla
	,COUNT(*) Registros
	,null
	,CONVERT(date,a.FechaSubida)FechaSubida
from Z_DV_Chedraui a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by 
	CONVERT(date,a.FechaSubida)

insert into #ConsultaBotsRetails
select 
	'Z_DV_CityFresko' Tabla
	,COUNT(*) Registros
	,null
	,CONVERT(date,a.FechaSubida)FechaSubida
from Z_DV_CityFresko a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by 
	CONVERT(date,a.FechaSubida)

insert into #ConsultaBotsRetails
select 
	'Z_DV_Soriana' Tabla
	,COUNT(*) Registros
	,null
	,CONVERT(date,a.FechaSuida)FechaSubida
from Z_DV_Soriana a
where 1 = 1
	and CONVERT(date,a.FechaSuida) = @FechaSubida
group by 
	CONVERT(date,a.FechaSuida)

insert into #ConsultaBotsRetails
select 
	'Z_DV_Sanborns' Tabla
	,COUNT(*) Registros
	,null
	,CONVERT(date,a.FechaSubida)FechaSubida
from Z_DV_Sanborns a
where 1 = 1
	and CONVERT(date,a.FechaSubida) = @FechaSubida
group by 
	CONVERT(date,a.FechaSubida)

update a
	set
		a.Folios = ISNULL(b.Folios,ISNULL(c.Folios,ISNULL(d.Folios,ISNULL(e.Folios,ISNULL(f.Folios,ISNULL(g.folios,ISNULL(h.Folios,i.Folios)))))))--e.Folios)))
from #ConsultaBotsRetails a
	left outer join #TotalFolios_Chedraui_Sucursal b
	on a.Tabla = b.Tabla collate SQL_Latin1_General_CP1_CI_AI
		and a.FechaSubida = b.FechaSubida
	left outer join #TotalFolios_Chedraui c
	on a.Tabla = c.Tabla collate SQL_Latin1_General_CP1_CI_AI
		and a.FechaSubida = c.FechaSubida
	left outer join #TotalFolios_CityFresko d
	on a.Tabla = d.Tabla collate SQL_Latin1_General_CP1_CI_AI
		and a.FechaSubida = d.FechaSubida
	left outer join #TotalFolios_Sanborns e
	on a.Tabla = e.Tabla collate SQL_Latin1_General_CP1_CI_AI
		and a.FechaSubida = e.FechaSubida
	left outer join #TotalFolios_Soriana f
	on a.Tabla = f.Tabla collate SQL_Latin1_General_CP1_CI_AI
		and a.FechaSubida = f.FechaSubida
	left outer join #TotalFolios_Walmart g
	on a.Tabla = g.Tabla collate SQL_Latin1_General_CP1_CI_AI
		and a.FechaSubida = g.FechaSubida
	left outer join #TotalFolios_Liverpool h
	on a.Tabla = h.Tabla collate SQL_Latin1_General_CP1_CI_AI
		and a.FechaSubida = h.FechaSubida
	left outer join #TotalFolios_Liverpool_SKU i
	on a.Tabla = i.Tabla collate SQL_Latin1_General_CP1_CI_AI
		and a.FechaSubida = i.FechaSubida
where 1 = 1
	and a.Folios is null

select * from #ConsultaBotsRetails

--select 
--	a.Cadena
--	,a.Rubro
--	,a.Tabla
--	,a.Inicio_Actualiza
--	,a.Fin_Actualiza
--	,b.Folios Folios_Descargados
--	,b.Registros
--from Subidas_Log_Gral_BotsRetail a
--	left outer join #ConsultaBotsRetails b
--	on a.Tabla = b.Tabla collate SQL_Latin1_General_CP1_CI_AI
--		and CONVERT(date,a.Fin_Actualiza) = b.FechaSubida
--where 1 = 1
--	and CONVERT(date,a.Fin_Actualiza) = @FechaSubida 
--order by a.Fin_Actualiza desc

drop table #ConsultaBotsRetails
,#Folios_Chedraui_Sucursal
,#TotalFolios_Chedraui_Sucursal
,#Folios_CityFresko
,#TotalFolios_CityFresko
,#Folios_Sanborns
,#TotalFolios_Sanborns
,#Folios_Chedraui
,#TotalFolios_Chedraui
,#Folios_Soriana
,#TotalFolios_Soriana
,#Folios_Walmart
,#TotalFolios_Walmart
,#Folios_Liverpool
,#TotalFolios_Liverpool
,#Folios_Liverpool_SKU
,#TotalFolios_Liverpool_SKU