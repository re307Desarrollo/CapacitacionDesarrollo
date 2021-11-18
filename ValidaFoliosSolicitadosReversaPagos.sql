truncate table [EliminarDropbox]
	create table #EliminarDropbox(
		Sucursal varchar(max)
		,Oracle int
		,Folio varchar(max)
	)
	BULK INSERT #EliminarDropbox FROM 'H:\Desarrollo\EliminarDropbox.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 2);
	
	insert into EliminarDropbox
	select 
		a.Sucursal
		,a.Oracle
		,REPLACE(REPLACE(a.Folio,'á',''),' ','')
		,0
	from #EliminarDropbox a

	select * from EliminarDropbox a
	where 1 = 1
		and a.Sucursal is not null
	order by a.Oracle desc

	select cr.Razon_Social, a.* 
	into #SiEstan
from Devoluciones_Pagos a
	left outer join E_Carta_de_Rutas cr
	on a.Oracle = cr.No_Cliente
where 1 = 1
	--and Oracle = @Oracle
	--and Folio = @Folio
	and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.Oracle = b.Oracle
			and a.Folio = b.Folio
			and a.Sucursal = b.Sucursal)
--and a.[Nota Crédito] is not null
and a.ImportePortalesWeb is null
order by a.Oracle desc

select * from EliminarDropbox a
where 1 = 1
	and not exists(select * from #SiEstan b
						where 1 = 1
							and a.Folio = b.Folio
							and a.Oracle = b.Oracle
							and a.Sucursal = b.Sucursal
					)
	and a.Sucursal is not null