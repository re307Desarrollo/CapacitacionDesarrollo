declare
	@NC varchar(max) = '156019,'

create table #NCs(
	NC varchar(max)
)

while( LEN(@NC)>1)
begin
	insert into #NCs
	select
		SUBSTRING(@NC,0,CHARINDEX(',',@NC,0))

	set @NC = SUBSTRING(@NC,CHARINDEX(',',@NC,0)+1,LEN(@NC))
end


--select * from ControlDocumental_LI a
--where 1 = 1
--and a.Folio in ('4212337533','4211206679','4210030419','4209225478')
--order by a.Folio desc 

select * from ControlDocumental_LI a
where 1 = 1
and a.Folio in (select * from #NCs)
order by a.Folio desc 

--select * from ControlDocumental_LI a
--where 1 = 1
--and a.Folio = '4212337533'
--order by a.Folio desc 



select *
into #Maestro_Sucursales
from Maestro_Sucursales
where 1 = 1
and Modulo = 'Devolución'

--select * from #NCs a
--where 1 = 1
--	and a.NC = '4209124110'


select distinct
	b.Oracle
	,b.Sucursal
	,c.Den_Comer
	,a.FOLIO
	,a.SUCURSAL
	,a.FECHA_ALTA
	,a.FechaSubida
from Z_DV_CityFresko a

left outer join #Maestro_Sucursales b
on a.SUCURSAL= b.Sucursal
and 'Cityfresko' = b.Cadena

left outer join E_Carta_de_Rutas c
on b.Oracle = c.No_Cliente

where 1 = 1
	and a.FOLIO in (select * from #NCs)
	--and a.NroReferen = '480903073142'
order by a.FOLIO desc


--select distinct
--	b.Oracle
--	,b.Sucursal
--	,c.Den_Comer
--	,a.NroReferen
--	,a.CentroOrig
--	,a.FechaCreac
--from Z_DV_Liverpool a

--left outer join #Maestro_Sucursales b
--on a.CentroOrig = b.Sucursal
--and 'Liverpool' = b.Cadena

--left outer join E_Carta_de_Rutas c
--on b.Oracle = c.No_Cliente

--where 1 = 1
--	and a.NroReferen in (select * from #NCs)
--	and a.NroReferen = '4212337533'
--order by a.NroReferen desc

--select distinct
--	c.Den_Comer
--from Z_DV_Liverpool a

--left outer join #Maestro_Sucursales b
--on a.CentroOrig = b.Sucursal
--and 'Liverpool' = b.Cadena

--left outer join E_Carta_de_Rutas c
--on b.Oracle = c.No_Cliente

--where 1 = 1
--	and a.NroReferen in (select * from #NCs)
----order by a.NroReferen desc


--select
--b.Oracle
--,a.*
--from Z_DV_Pendientes_Walmart a

--left outer join #Maestro_Sucursales b
--on a.Tienda = b.Sucursal
--and 'Walmart' = b.Cadena

--where 1 = 1
--and Folio = '0152411055'

drop table #Maestro_Sucursales
		,#NCs