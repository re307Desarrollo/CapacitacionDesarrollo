select 
	a.Folio
	,a.Tienda
	,SUM(a.DET_Cantidad)DET_Cantidad
	, SUM(a.DET_ImporteTotal)DET_ImporteTotal
	,a.Importe Importe_Cabecero
	,ROUND(SUM(a.DET_ImporteTotal)-a.Importe,2,2) Diferencia
	,ROUND(((SUM(a.DET_ImporteTotal)*100 )/a.Importe)-100,2,2) Porcentaje_Diferencia
from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	--and a.Folio in (select * from #NCs)
	--and (SUM(a.DET_ImporteTotal)-a.Importe)>0
group by a.Folio,a.Importe,a.Tienda
having (SUM(a.DET_ImporteTotal)-a.Importe)>0

