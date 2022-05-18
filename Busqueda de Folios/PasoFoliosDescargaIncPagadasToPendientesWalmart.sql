
--Insert into Z_DV_Pendientes_Walmart
select 
	*
from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	and not exists(select * from Z_DV_Pendientes_Walmart b
					where 1 = 1
						and a.Tienda = b.Tienda
						and a.Folio = b.Folio
						and a.DET_UPC = b.DET_UPC)
	and a.Tienda is not null
	and a.Folio is not null
	and a.DET_UPC is not null
order by a.FechaSubida desc

--Insert into Z_DV_Pendientes_Walmart
select 
	*
from Z_DV_Pagadas_Walmart a
where 1 = 1
	and not exists(select * from Z_DV_Pendientes_Walmart b
					where 1 = 1
						and a.Tienda = b.Tienda
						and a.Folio = b.Folio
						and a.DET_UPC = b.DET_UPC)
	and a.Tienda is not null
	and a.Folio is not null
	and a.DET_UPC is not null
order by a.FechaSubida desc

--Insert into Z_DV_Pendientes_Walmart
select 
	*
from Z_DV_Pagadas_Walmart_DescargaIncompleta a
where 1 = 1
	and not exists(select * from Z_DV_Pendientes_Walmart b
					where 1 = 1
						and a.Tienda = b.Tienda
						and a.Folio = b.Folio
						and a.DET_UPC = b.DET_UPC)
	and a.Tienda is not null
	and a.Folio is not null
	and a.DET_UPC is not null
order by a.FechaSubida desc

return
select top 1 * from Z_DV_Pendientes_Walmart_DescargaIncompleta
select top 1 * from Z_DV_Pagadas_Walmart_DescargaIncompleta
select top 1 * from Z_DV_Pagadas_Walmart
select top 1 * from Z_DV_Pendientes_Walmart a
order by a.FechaSubida desc