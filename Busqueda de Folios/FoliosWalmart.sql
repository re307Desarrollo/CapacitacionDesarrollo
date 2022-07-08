declare
	@NC varchar(max) = '0136305832,'

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

select 'Z_DV_Pendientes_Walmart' tabla
select * from Z_DV_Pendientes_Walmart a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.Folio desc, a.FechaRecibo desc
select distinct a.Folio from Z_DV_Pendientes_Walmart a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.Folio desc

select 'Z_DV_Pendientes_Walmart_DescargaIncompleta' tabla
select * from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.FechaRecibo desc

select b.No_Cliente,b.Estatus_Pedidos, a.Folio,a.Tienda,SUM(a.DET_Cantidad)DET_Cantidad,a.Importe Importe_Cabecero, SUM(a.DET_ImporteTotal)DET_ImporteDetalle,a.Importe-SUM(a.DET_ImporteTotal) Diferencia from Z_DV_Pendientes_Walmart_DescargaIncompleta a
	left outer join E_Carta_de_Rutas b
	on a.Tienda = '0'+b.Codigo_Sucursal
where 1 = 1
	and a.Folio in (select * from #NCs)
group by b.No_Cliente,b.Estatus_Pedidos,a.Folio,a.Importe,a.Tienda

select 'Z_DV_Pagadas_Walmart' tabla
select * from Z_DV_Pagadas_Walmart a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.FechaPago desc

select 'Z_DV_Pagadas_Walmart_DescargaIncompleta' tabla
select * from Z_DV_Pagadas_Walmart_DescargaIncompleta a
where 1 = 1
	and a.Folio in (select * from #NCs)
order by a.FechaPago desc

drop table #NCs

return

insert into Z_DV_Pendientes_Walmart
select 
	* 
from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	and a.Folio = '0117703894'

