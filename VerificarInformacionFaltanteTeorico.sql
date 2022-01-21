declare
	@Query varchar(max) = ''
	,@Insertar varchar(max) = 'insert into #'
	,@Consulta varchar(max) = ' select * from Devoluciones_'
	,@Cadena varchar(max) = 'CancunAirport'
	,@Devolucion varchar(max) = 'Devoluciones'
	,@Reporte_Acumulado varchar(max) = 'Reporte_Acumulado'
	,@Reporte_Acumulado_Item varchar(max) = 'Reporte_Acumulado_porItem'
	,@RazonSocial varchar(max) = ''
	,@Oracle varchar(max) = '301025'--'210202'
	,@OracleBD int = null
	,@OraclePagoBD int = null
	,@CodigoBD int = null
	,@Folio varchar(max) = 'Dev 4'

CREATE TABLE #Devoluciones(
	[Sucursal] [varchar](max) NULL,
	[Folio] [varchar](max) NULL,
	[cb] [varchar](max) NULL,
	[Fecha] [date] NULL,
	[unidades] [int] NULL,
	[importe] [float] NULL,
	[RS] [varchar](max) NULL
) 

CREATE TABLE #Reporte_Acumulado(
	[cliente] [varchar](100) NULL,
	[folio] [varchar](100) NULL,
	[Codigo] [varchar](50) NULL,
	[CB] [varchar](100) NULL,
	[fecha] [date] NULL,
	[unidades] [int] NULL,
	[importe] [float] NULL,
	[cadena] [varchar](100) NULL
)
CREATE TABLE #Reporte_Acumulado_porItem(
	[cliente] [varchar](50) NULL,
	[folio] [varchar](50) NULL,
	[Codigo] [varchar](50) NULL,
	[CB] [varchar](100) NULL,
	[fecha] [date] NULL,
	[unidades] [int] NULL,
	[importe] [float] NULL,
	[cadena] [varchar](50) NULL,
	[Item] [varchar](13) NULL,
	[FechaSubida] [datetime] NULL
) 

select cr.Razon_Social, a.* 
from Devoluciones_Pagos a
	left outer join E_Carta_de_Rutas cr
	on a.Oracle = cr.No_Cliente
where 1 = 1
	and Oracle = @Oracle
	and Folio = @Folio
	--and exists (select * from [EliminarDropbox] b
	--	where 1 = 1	
	--		and a.Oracle = b.Oracle
	--		and a.Folio = b.Folio
	--		and a.Sucursal = b.Sucursal)
--and a.[Nota Crédito] is not null
and a.ImportePortalesWeb is null


select * from Devoluciones_Carga_ORACLE_Auditoria_SinIVA
where 1 = 1
    and Oracle = CONVERT(int,@Oracle)
	and Folio = @Folio


select * from Devoluciones_Carga_ORACLE_Auditoria
where 1 = 1
    and Oracle = CONVERT(int,@Oracle)
	and Folio = @Folio

set @Query = @Insertar+@Devolucion+@Consulta+@Cadena+' a where 1 = 1 and a.Folio = convert(varchar,'+@Folio+')'
select @Query Query
exec(@query)
select * from #Devoluciones
select 
	@RazonSocial = a.RS
from #Devoluciones a
group by a.RS
select @RazonSocial [Razon Social]
--drop table #Devoluciones
--select @Query as Devo

set @Query = @Insertar+@Reporte_Acumulado+@Consulta+@Cadena+'_'+@Reporte_Acumulado+' where 1 = 1 and Folio = convert(varchar,'+@Folio+')'
select @Query Query
exec(@query)


set @Query = @Insertar+@Reporte_Acumulado_Item+@Consulta+@Cadena+'_'+@Reporte_Acumulado_Item+' where 1 = 1 and Folio = convert(varchar,'+@Folio+')'
select @Query Query
exec(@query)

if exists(select 
			*
		from #Reporte_Acumulado a
		where 1 = 1
			and a.cliente = @Oracle
		)
begin
	--select 'si hay datos'
	select * from #Reporte_Acumulado
	select * from #Reporte_Acumulado_porItem
end
else
begin
	select 'no se registro Oracle o Codigo en Reporte acomulado'Razon

	select * from #Reporte_Acumulado a
	where 1 = 1
		and a.folio like '%'+@Folio+'%'

	select 
		@OracleBD = CONVERT(int,ISNULL(a.cliente,'0')) 
		,@CodigoBD = CONVERT(int,ISNULL(a.Codigo,'0')) 
	from #Reporte_Acumulado a
	group by a.cliente
			,a.Codigo
	
	select @CodigoBD Reporte_Acumulado_Codigo

	if (@CodigoBD = 0 or @CodigoBD is null)
	begin 
		--select @OracleBD Reporte_Acumulado_Oracle
		select 
			@OraclePagoBD = ISNULL(a.Oracle,0)
		from Devoluciones_Carga_ORACLE_Auditoria_SinIVA a
		where 1 = 1
			and a.folio like '%'+@Folio+'%'
		
		select @OraclePagoBD ORACLE_Auditoria_SinIVA

		if (@OracleBD = 0 or @OracleBD is null )
		begin
			select 
				@OraclePagoBD = ISNULL(a.Oracle,0)
			from Devoluciones_Carga_ORACLE_Auditoria a
			where 1 = 1
				and a.folio like '%'+@Folio+'%'
			select @OraclePagoBD ORACLE_Auditoria
		end
		
	end

	select 
		a.No_Cliente
		,a.Razon_Social
		,a.Codigo_Sucursal
		,a.Estatus_Pedidos
	from E_Carta_de_Rutas a
	where 1 = 1
		--and a.Razon_Social = @RazonSocial
		and a.No_Cliente in (CONVERT(int,@Oracle),@OracleBD,@OraclePagoBD)



end
--select @Query as ReporteAcomulado
--select @Query as ReporteAcomuladoItem



drop table #Devoluciones,#Reporte_Acumulado,#Reporte_Acumulado_porItem
return
