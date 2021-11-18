declare
	@Folio varchar(max) = '148811049'

select * from Z_DV_Pendientes_Walmart
where 1 = 1
	and Folio like '%'+@Folio+'%'

select * from Z_DV_Pendientes_Walmart_DescargaIncompleta
where 1 = 1
	and Folio like '%'+@Folio+'%'

select * from Z_DV_Pagadas_Walmart
where 1 = 1
	and Folio like '%'+@Folio+'%'

select * from Z_DV_Pagadas_Walmart_DescargaIncompleta
where 1 = 1
	and Folio like '%'+@Folio+'%'
select * from Z_DV_Pagadas_Walmart_SinDetalle
where 1 = 1
	and Folio like '%'+@Folio+'%'
