declare
	@NC varchar(max) = '4209161332,4212337533,4209124110,4209065442,4210033773,4210959073,4210224014,4209750009,4211209932,4207849662,4209350186,4211325608,4209355755,4209225478,4210030419,4209481159,4209569832,4209074184,4210331632,4211198831,4209220825,4208566860,4210715148,4210351091,4207323375,4211201223,4210351046,4209422257,4208983134,4210178374,4209082722,4208273105,4207567366,4208897852,4209569708,4211207458,4210575602,4211206679,480903073142,'

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


select * from ControlDocumental_LI a
where 1 = 1
and a.Folio in ('4212337533','4211206679','4210030419','4209225478')
order by a.Folio desc 

select * from ControlDocumental_LI a
where 1 = 1
and a.Folio in (select * from #NCs)
order by a.Folio desc 

select * from ControlDocumental_LI a
where 1 = 1
and a.Folio = '4212337533'
order by a.Folio desc 



select *
into #Maestro_Sucursales
from Maestro_Sucursales
where 1 = 1
and Modulo = 'Devolución'

select * from #NCs a
where 1 = 1
	and a.NC = '4209124110'


select distinct
	b.Oracle
	,b.Sucursal
	,c.Den_Comer
	,a.NroReferen
	,a.CentroOrig
	,a.FechaCreac
from Z_DV_Liverpool a

left outer join #Maestro_Sucursales b
on a.CentroOrig = b.Sucursal
and 'Liverpool' = b.Cadena

left outer join E_Carta_de_Rutas c
on b.Oracle = c.No_Cliente

where 1 = 1
	and a.NroReferen in (select * from #NCs)
	--and a.NroReferen = '480903073142'
order by a.NroReferen desc


select distinct
	b.Oracle
	,b.Sucursal
	,c.Den_Comer
	,a.NroReferen
	,a.CentroOrig
	,a.FechaCreac
from Z_DV_Liverpool a

left outer join #Maestro_Sucursales b
on a.CentroOrig = b.Sucursal
and 'Liverpool' = b.Cadena

left outer join E_Carta_de_Rutas c
on b.Oracle = c.No_Cliente

where 1 = 1
	and a.NroReferen in (select * from #NCs)
	and a.NroReferen = '4212337533'
order by a.NroReferen desc

select distinct
	c.Den_Comer
from Z_DV_Liverpool a

left outer join #Maestro_Sucursales b
on a.CentroOrig = b.Sucursal
and 'Liverpool' = b.Cadena

left outer join E_Carta_de_Rutas c
on b.Oracle = c.No_Cliente

where 1 = 1
	and a.NroReferen in (select * from #NCs)
--order by a.NroReferen desc


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