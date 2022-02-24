select 'Z_DV_Pendientes_Walmart' tabla
select * from Z_DV_Pendientes_Walmart a
where 1 = 1
	and a.Folio = '0110546720'
select 'Z_DV_Pendientes_Walmart_DescargaIncompleta' tabla
select * from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	and a.Folio = '0110546720'
order by a.DET_UPC desc

select SUM(a.DET_ImporteTotal) from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	and a.Folio = '0110546720'

select 'Z_DV_Pagadas_Walmart' tabla
select * from Z_DV_Pagadas_Walmart a
where 1 = 1
	and a.Folio = '0110546720'
select 'Z_DV_Pagadas_Walmart_DescargaIncompleta' tabla
select * from Z_DV_Pagadas_Walmart_DescargaIncompleta a
where 1 = 1
	and a.Folio = '0110546720'

