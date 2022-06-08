

select b.No_Cliente,a.* from Z_DV_HEB a
	left outer join E_Carta_de_Rutas b
	on b.Codigo_Sucursal = a.Sucursal
where 1 = 1
	and a.FolioDev in( '38860','44973')

select b.No_Cliente,a.FolioDev,a.FechaDev,a.Sucursal, SUM(a.CantidadDev) Uniades, SUM(a.CostoDev) Importe_Total from Z_DV_HEB a
	left outer join E_Carta_de_Rutas b
	on b.Codigo_Sucursal = a.Sucursal
where 1 = 1
	and a.FolioDev in( '38860','44973')
group by b.No_Cliente,a.FechaDev,a.Sucursal,a.FolioDev

select * from Devoluciones_HEB_Reporte_Acumulado a
where 1 = 1
	and a.Folio in( '38860','44973')

select * from ControlDocumental_LI a
where 1 = 1
	and a.Folio in( '38860','44973')
	
select * from ControlDocumental_LI_Detalle a
where 1 = 1
	and a.ControlDocumental_LI_Id in (76712,73293)