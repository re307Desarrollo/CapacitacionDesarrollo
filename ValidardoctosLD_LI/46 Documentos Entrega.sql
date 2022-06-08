
declare 
	 @Docto varchar(max) = '7018783'
	,@Item varchar(max) = ''
	,@Insert int = 0
	,@Select int = 1
	,@Select_Item int = 0
	,@DuplicarRemisionItem int = 0


if @Select = 1
begin

	select '46_Acumulado_F'
	select top 1000 * from [46_Acumulado_F]
	where 1 = 1
		and [Docto Num] = @Docto
	order by [Numero Articulo] asc, Edicion asc

	select '46_Acumulado_R'
	select top 1000 * from [46_Acumulado_R]
	where 1 = 1
		and [Código de Barras] = @Docto
	order by Articulo asc

	select 'Control_Entregas_Concentrado'
	select * from Control_Entregas_Concentrado
	where 1 = 1
		and Docto_Num = @Docto

	select 'Recolección Data'
	select * from RecoleccionData_LD
	where 1 = 1
		and DOCUMENTO = @Docto

end


if @Select_Item = 1
begin

select '46_Acumulado_F'
select top 1000 * from [46_Acumulado_F]
where 1 = 1
	and [Docto Num] = @Docto
	and [Numero Articulo] + '.' + Edicion = @Item
order by [Numero Articulo] asc, Edicion asc

select '46_Acumulado_R'
select top 1000 * from [46_Acumulado_R]
where 1 = 1
	and [Código de Barras] = @Docto
	and Articulo = @Item
order by Articulo asc

select 'Control_Entregas_Concentrado'
select * from Control_Entregas_Concentrado
where 1 = 1
	and Docto_Num = @Docto
	and Item = @Item
end

--if @Insert = 1
--begin
--select '46_Acumulado_F'
--select top 1000 * from [46_Acumulado_F]
--where 1 = 1
--	and [Docto Num] = @Docto

--select '46_Acumulado_R'
--select top 1000 * from [46_Acumulado_R]
--where 1 = 1
--	and [Código de Barras] = @Docto

--select 'Control_Entregas_Concentrado'
--select * from Control_Entregas_Concentrado
--where 1 = 1
--	and Docto_Num = @Docto
--	order by Item asc
--end


if @Insert = 1
	begin
insert into Control_Entregas_Concentrado
Select 
		 '0'
		,'Factura'
		,[Fecha Emision]
		,[Docto Num]
		,[Cliente Transaccional]
		,cr.Razon_Social
		,cr.Denominación
		,cr.Sucursal
		,cr.Den_Comer
		,cr.[Días_de_visita]
		,cr.[Zona_Comercial]
		,cr.[Ruta_Maquina]
		,a.[Numero Articulo] + '.' + a.Edicion
		,pc.[TITULO]
		,round(round(Importe,2) / convert(float,Cantidad),2) as [Precio Lista]
		,[Cantidad]
		,[Importe]
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,[Zona]
		,null
		,null
		,null
		,null
		,'Pendiente'
		,null
		,null
		,null
		,null
		,null
		,null
		,'-'
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,getdate()
		,null
from [46_Acumulado_F] a
	left outer join E_Carta_de_Rutas cr
	on convert(int,a.[Cliente Transaccional]) = cr.No_Cliente
	left outer join Programa_Circulacion_Completo pc
	on a.[Numero Articulo] + '.' + a.Edicion = pc.ITEM

where 1 = 1
	and [Docto Num] = @Docto
	and not exists (select distinct b.No_Cliente, b.Docto_Num from Control_Entregas_Concentrado b
		where 1 = 1
			and convert(int,a.[Cliente Transaccional]) = b.No_Cliente
			and a.[Docto Num] = b.Docto_Num)

insert into Control_Entregas_Concentrado
	Select
		 '0'
		,'Factura'
		,[Fecha Remision]
		,[Código de Barras]
		,[Cliente Transaccional]
		,cr.Razon_Social
		,cr.Denominación
		,cr.Sucursal
		,cr.Den_Comer
		,cr.[Días_de_visita]
		,cr.[Zona_Comercial]
		,cr.[Ruta_Maquina]
		,Articulo
		,pc.[TITULO]
		,round([Precio Rem SUM],2) as [Precio Lista]
		,[Cantidad Remisionada]
		,round([Importe Remisionado],2)
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,[Zona]
		,null
		,null
		,null
		,null
		,'Pendiente'
		,null
		,null
		,null
		,null
		,null
		,null
		,'-'
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,null
		,getdate()
		,null
from [46_Acumulado_R] a
	left outer join E_Carta_de_Rutas cr
	on convert(int,a.[Cliente Transaccional]) = cr.No_Cliente
	left outer join Programa_Circulacion_Completo pc
	on a.Articulo = pc.ITEM
where 1 = 1
	and [Código de Barras] = @Docto
	and not exists (select distinct b.No_Cliente, b.Docto_Num from Control_Entregas_Concentrado b
		where 1 = 1
			and convert(int,a.[Cliente Transaccional]) = b.No_Cliente
			and a.[Código de Barras] = b.Docto_Num)

	end

	--

if @DuplicarRemisionItem = 1
begin
insert into [46_Acumulado_R]
select top 1000 * from [46_Acumulado_R]
where 1 = 1
	and [Código de Barras] = @Docto
	and Articulo = @Item
end

	return

select * from Matriz_Seguimiento_Control_Documental_Detalle_LD
where 1 = 1
	and Documento = '6941382'
	and Item = '07085613.2003'

select * 
--delete
from Control_Entregas_Concentrado
where 1 = 1
	and Docto_Num = '7018783'
	and No_Cliente is null