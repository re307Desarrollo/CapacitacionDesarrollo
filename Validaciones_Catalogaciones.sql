


declare  
		 
		 @Walmart int = 0
		,@Sanborns int = 0
		,@Soriana int = 0
		,@Cityfresko int = 0
		,@Chedraui int = 0


if @Walmart = 1
begin
	select 'Walmart' as [Punto Venta]
	select top 1000 
		* 
	from Z_CAT_Walmart
	order by FechaSubida desc
	------------------------------------------------
	select top 1000 
		* 
	from Z_CAT_Walmart_Log
	order by FechaSubida desc, FechaLog desc
end


if @Sanborns = 1
begin
	select 'Sanbors' as [Punto Venta]
	select top 1000 
	* 
	from Z_CAT_Sanborns
	order by FechaSubida desc
		------------------------------------------------
	select top 1000 
		* 
	from Z_CAT_Sanborns_Log
	order by FechaSubida desc, FechaLog desc
end


if @Soriana = 1
begin
	select 'Soriana' as [Punto Venta]
	select top 1000 
		* 
	from Z_CAT_Soriana
	order by FechaSubida desc
		------------------------------------------------
	select top 1000 
		* 
	from Z_CAT_Soriana_Log
	order by FechaSubida desc, FechaLog desc
end

if @Cityfresko = 1
begin
	select 'City Fresco' as [Punto Venta]
	select top 1000 
		* 
	from Z_CAT_CityFresko
	order by FechaSubida desc
		------------------------------------------------

	select top 1000 
		* 
	from Z_CAT_CityFresko_Log
	order by FechaSubida desc, FechaLog desc
end

if @Chedraui = 1
begin
	select 'Cheadraui' as [Punto Venta]
	select top 1000 
		* 
	from Z_CAT_Chedraui
	order by FechaSubida desc
		------------------------------------------------
	select top 1000 
		* 
	from Z_CAT_Chedraui_Log
	order by FechaSubida desc, FechaLog desc
end

--select 'Sanbors' as [Punto Venta]
--	select --top 1000 
--	* 
--	from Z_CAT_Sanborns
--	order by FechaSubida desc