declare
	@NC varchar(max) = '32471,49474,49473,58371,14447,'

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

select b.No_Cliente,a.* from Z_DV_HEB a
	left outer join E_Carta_de_Rutas b
	on b.Codigo_Sucursal = a.Sucursal
where 1 = 1
	and a.FolioDev in (select * from #NCs)

select distinct a.FolioDev from Z_DV_HEB a
	left outer join E_Carta_de_Rutas b
	on b.Codigo_Sucursal = a.Sucursal
where 1 = 1
	and a.FolioDev in (select * from #NCs)

select b.No_Cliente,a.FolioDev,a.FechaDev,a.Sucursal, SUM(a.CantidadDev) Uniades, SUM(a.CostoDev) Importe_Total from Z_DV_HEB a
	left outer join E_Carta_de_Rutas b
	on b.Codigo_Sucursal = a.Sucursal
where 1 = 1
	and a.FolioDev in (select * from #NCs)
group by b.No_Cliente,a.FechaDev,a.Sucursal,a.FolioDev

select * from Devoluciones_HEB_Reporte_Acumulado a
where 1 = 1
	and a.Folio in (select * from #NCs)
	and a.Cliente in (190353,
210251,
192932,
210289,
50518,
190353,
190359)

select * from ControlDocumental_LI a
where 1 = 1
	and a.Folio in (select * from #NCs)
	and a.Oracle in (190353,
210251,
192932,
210289,
50518,
190353,
190359)
	
select * from ControlDocumental_LI_Detalle a
where 1 = 1
	and a.ControlDocumental_LI_Id in (73291,
73292,
73294,
73297,
73304)

	
select * from ControlDocumental_LI_Detalle_Scan a
where 1 = 1
	and a.ControlDocumental_LI_Id in (73291,
73292,
73294,
73297,
73304)