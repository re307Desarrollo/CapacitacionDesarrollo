declare
	@Query varchar(max) = ''
	,@Insertar varchar(max) = 'insert into #'
	,@Consulta varchar(max) = ' select * from Devoluciones_'
	,@Cadena varchar(max) = 'PromotoraMusical'
	,@Devolucion varchar(max) = 'Devoluciones'
	,@Reporte_Acumulado varchar(max) = 'Reporte_Acumulado'
	,@Reporte_Acumulado_Item varchar(max) = 'Reporte_Acumulado_porItem'
	,@RazonSocial varchar(max) = ''
	,@Oracle varchar(max) = '210202'
	,@OracleBD int = null
	,@Folio varchar(max) = '70615424'

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

select * from Devoluciones_Carga_ORACLE_Auditoria_SinIVA
where 1 = 1
    and Oracle = @Oracle
	and Folio = @Folio

set @Query = @Insertar+@Devolucion+@Consulta+@Cadena+' where 1 = 1 and Folio = '+@Folio
exec(@query)
select * from #Devoluciones
select 
	@RazonSocial = a.RS
from #Devoluciones a
group by a.RS
--drop table #Devoluciones
---select @Query as Devo

set @Query = @Insertar+@Reporte_Acumulado+@Consulta+@Cadena+'_'+@Reporte_Acumulado+' where 1 = 1 and Folio = '+@Folio
exec(@query)


set @Query = @Insertar+@Reporte_Acumulado_Item+@Consulta+@Cadena+'_'+@Reporte_Acumulado_Item+' where 1 = 1 and Folio = '+@Folio
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
	select 'no hay datos'
	select 
		@OracleBD = CONVERT(int,a.cliente) 
	from #Reporte_Acumulado a
	group by a.cliente

	select 
		a.No_Cliente
		,a.Razon_Social
		,a.Codigo_Sucursal
		,a.Estatus_Pedidos
	from E_Carta_de_Rutas a
	where 1 = 1
		and a.Razon_Social = @RazonSocial
		and a.No_Cliente in (CONVERT(int,@Oracle),@OracleBD)



end
--select @Query as ReporteAcomulado
--select @Query as ReporteAcomuladoItem



drop table #Devoluciones,#Reporte_Acumulado,#Reporte_Acumulado_porItem
return
