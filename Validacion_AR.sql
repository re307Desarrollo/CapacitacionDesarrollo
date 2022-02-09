declare
			@FechaSubida date = DATEADD(dd,0,GETDATE())
			,@Walmart int = 0
			,@FacturasWalmart int = 0
			,@Cityfresko int = 0
			,@HEB int = 0
			,@Sanborns int = 0
			,@Soriana int = 0
			,@OXXO int = 0
			,@OXXO_Detalle int = 0
			,@1000Registros int = 0
			,@registrosFechaSub int  = 1



-----------------************************--------------------
-----------------Acuses de Recibo-------------------------
select @FechaSubida FechaConsulta
if @1000Registros = 1
begin
	if @Walmart = 1
	begin

		select top 1000 
			* 
		from Z_AR_Walmart
			order by FechaSubida desc
	end


	if @Cityfresko = 1
	begin

		select top 1000 
			* 
		from Z_AR_CityFresko
			order by FechaSubida desc
	end


	if @Soriana = 1
	begin

		select top 1000 
			* 
		from Z_AR_Soriana
			order by FechaSubida desc
	end


	if @HEB = 1
	begin
		select top 1000 
			* 
		from Z_AR_HEB
			order by FechaSubida desc
	end


	if @OXXO = 1
	begin
		Select top 1000 
			* 
		from Z_AR_OXXO
			order by FechaSubida desc
	end


		if @OXXO_Detalle = 1
	begin
		Select top 1000 
			* 
		from Z_AR_OXXO_Folios
			order by FECHA_SUBIDA desc
	end
end
if @registrosFechaSub = 1
begin
	if @Walmart = 1
	begin

		select 
			* 
		from Z_AR_Walmart w
			where 1 = 1
			and CONVERT(date,w.FechaSubida)=@FechaSubida
			order by w.FechaSubida desc
	end


	if @Cityfresko = 1
	begin

		select
			* 
		from Z_AR_CityFresko cf
			where 1 = 1
			and CONVERT(date,cf.FechaSubida)=@FechaSubida
			order by cf.FechaSubida desc
	end


	if @Soriana = 1
	begin

		select 
			* 
		from Z_AR_Soriana so
			where 1 = 1
			and CONVERT(date,so.FechaSubida)=@FechaSubida
			order by so.FechaSubida desc
	end


	if @HEB = 1
	begin
		select 
			* 
		from Z_AR_HEB h
			where 1 = 1
			and CONVERT(date,h.FechaSubida)=@FechaSubida
			order by h.FechaSubida desc
	end


	if @Sanborns = 1
	begin
		Select 
			* 
		from Z_AR_Sanborns san
			where 1 = 1
			and CONVERT(date,san.FechaSubida)=@FechaSubida
			order by san.FechaSubida desc
	end

	if @FacturasWalmart = 1
	begin
		Select 
			* 
		from Z_FAC_Walmart fac
			where 1 = 1
			and CONVERT(date,fac.FechaSubida)=@FechaSubida
			order by fac.FechaSubida desc
	end

	if @OXXO = 1
	begin
		Select 
			* 
		from Z_AR_OXXO ox
			where 1 = 1
			and CONVERT(date,ox.FechaSubida)=@FechaSubida
			order by ox.FechaSubida desc
	end

	if @OXXO_Detalle = 1
	begin
		Select top 1000 
			* 
		from Z_AR_OXXO_Folios oxf
			where 1 = 1
			and CONVERT(date,oxf.FECHA_SUBIDA)=@FechaSubida
			order by oxf.FECHA_SUBIDA desc
	end
end

