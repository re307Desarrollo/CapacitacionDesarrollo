declare 
	  @Accion int = 0
	,@Query varchar(max) = ''
	,@Consulta varchar(max) = 'select distinct a.Sucursal, a.Folio from Devoluciones_'
	,@Consulta2 varchar(max) = 'select * from Devoluciones_'
	,@Eliminar varchar(max)='delete a from Devoluciones_'
	,@Cadena varchar(max) = 'PromotoraMusical'
	,@Reporte_Acumulado varchar(max) = 'Reporte_Acumulado'
	,@Reporte_Acumulado_Item varchar(max) = 'Reporte_Acumulado_porItem'

if @Accion = 0
begin

truncate table [EliminarDropbox]
BULK INSERT EliminarDropbox FROM 'H:\Desarrollo\EliminarDropbox.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 2);

end
if @Accion = 1
begin

select cr.Razon_Social, a.* 
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
and a.ImportePortalesWeb is null--si al quitar este filtro aparecen, las transacciones ya estan en Oreacle
	
end
if @Accion = 2
begin

set @Query = @Consulta+@Cadena+' a 
			where 1 = 1 and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.Folio = b.Folio
			and a.Sucursal = b.Sucursal
			)'
exec(@query)
set @Query = @Consulta2+@Cadena+' a 
			where 1 = 1 and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.Folio = b.Folio
			and a.Sucursal = b.Sucursal
			)'
exec(@query)
set @Query = @Consulta2+@Cadena+'_'+@Reporte_Acumulado+' a where 1 = 1 
	and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.cliente = b.Oracle
			and a.Folio = b.Folio
			)'
exec(@query)
set @Query = @Consulta2+@Cadena+'_'+@Reporte_Acumulado_Item+' a where 1 = 1 
	and exists (select * from [EliminarDropbox] b
		where 1 = 1	
			and a.cliente = b.Oracle
			and a.Folio = b.Folio
			)'
exec(@query)
	
end
if @Accion = 3
begin
		delete a
		from Devoluciones_Pagos a
		where 1 = 1
			--and Oracle = @Oracle
			--and Folio = @Folio
			and exists (select * from [EliminarDropbox] b
				where 1 = 1	
					and a.Oracle = b.Oracle
					and a.Folio = b.Folio
					and a.Sucursal = b.Sucursal)
		--and a.[Nota Crédito] is not null
		and a.ImportePortalesWeb is null--si al quitar este filtro aparecen, las transacciones ya estan en Oreacle

		delete a
		from Devoluciones_Carga_ORACLE_Auditoria a
		where 1 = 1
			--and Oracle = @Oracle
			--and Folio = @Folio
			and exists (select * from [EliminarDropbox] b
				where 1 = 1	
					and a.Oracle = b.Oracle
					and a.Folio = b.Folio
					and a.Sucursal = b.Sucursal)
		--and a.[Nota Crédito] is not null
		and a.[Importe Oracle] is null



end