select distinct a.FOLIO,a.SUCURSAL,b.Oracle,c.Codigo_Sucursal,c.Sucursal from Z_DV_CityFresko a
	left outer join Maestro_Sucursales b
	on a.SUCURSAL = b.Sucursal
	left outer join E_Carta_de_Rutas c
	on b.Oracle = c.No_Cliente
where 1 = 1
	and a.FOLIO = '187024'
	and b.Cadena = 'Cityfresko'
	and b.Modulo = 'Devolución'



	select * from Maestro_Sucursales a
