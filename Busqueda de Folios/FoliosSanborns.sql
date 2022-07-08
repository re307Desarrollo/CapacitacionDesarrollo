declare
	@NC varchar(max) = '40913542,46117546,42813718,44700083,43751360,43865210,44582986,43640329,66008603,'--'21022731,21022680,21022662,21022643,'

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



select 'Z_DV_Sanborns' tabla
select * from Z_DV_Sanborns a
where 1 = 1
	and a.devolucion in (select * from #NCs)
	--and a.Devolucion = '21022643'
order by a.Devolucion, a.CB 


select 'Z_DV_Sanborns' tabla
select 
	a.Devolucion
	,a.Sucursal
	,SUM(a.TotalDet)TotalDet
	,a.Total
from Z_DV_Sanborns a
where 1 = 1
	and a.devolucion in (select * from #NCs)
group by a.Devolucion,a.Sucursal,a.Total
--order by a.Devolucion desc


select 'Z_DV_Sanborns' tabla
select distinct 
	a.Devolucion
	,a.FechaSubida
	into #foliosEncontrados
from Z_DV_Sanborns a
where 1 = 1
	and a.devolucion in (select * from #NCs)
order by a.FechaSubida,a.Devolucion desc


select '#foliosEncontrados' tabla
select * from #foliosEncontrados

select 'foliosNoEncontrados' tabla
select * from #NCs a
where 1 = 1
	and not exists(select * from #foliosEncontrados b
				   where 1 = 1
						and b.Devolucion = a.NC)


select 'Z_DV_Sanborns_DescargaIncompleta' tabla
select * from Z_DV_Sanborns_DescargaIncompleta a
where 1 = 1
	and a.devolucion in (select * from #NCs)


select 'ControlDocumental_LI' tabla
select * from ControlDocumental_LI a
where 1 = 1
	and a.Folio in (select b.NC from #NCs b)

drop table #NCs,#foliosEncontrados

return
select 'E_Carta_de_Rutas' tabla
select * from E_Carta_de_Rutas a
where 1 = 1
	and a.No_Cliente in (140250,140261,220125,110133)

select distinct a.Devolucion, a.Sucursal,sum(a.TotalDet),a.Fecha from Z_DV_Sanborns a
where 1 = 1
	--and a.Fecha = '2022-03-03'
	and a.Fecha >= '2022-03-01'
group by a.Devolucion, a.Sucursal,a.Fecha
order by a.Fecha desc