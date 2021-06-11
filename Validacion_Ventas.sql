
declare 
	 @FechaHora int = 1
	,@Fecha int = 0
	,@FechaVenta int = 1
	--Cadenas
	,@Walmart int = 0                                                                                                                                                                                                                                                                                                                                                          
	,@Sanborns int =  0
	,@Liverpool int = 1
	,@Chedraui int = 0---
	,@Cityfresko int = 0
	,@Heb int = 0---
	,@Soriana int = 0

if @FechaHora = 1
begin
	if @Walmart = 1
	begin	
		Select distinct top 100
			  [FechaSubida] FechaSubida_Walmart
			  ,Fecha
		FROM [Global].[dbo].[Z_VE_Walmart]
		where 1 = 1
		  order by FechaSubida_Walmart desc
	end

	if @Sanborns = 1
	begin	
		Select distinct top 100
			   [FechaSubida] FechaSubida_Sanborns
			  --,substring(FechaVenta_Det,7,4)+'-'+substring(FechaVenta_Det,4,2)+'-'+substring(FechaVenta_Det,1,2) FechaVenta
			  ,FechaVenta_Det
		FROM [Global].[dbo].[Z_VE_Sanborns]
		where 1 = 1
		  order by FechaSubida_Sanborns desc
	end

	if @Liverpool = 1
	begin	
		  Select distinct top 100
			  [FechaSubida] FechaSubida_Liverpool
			  ,FechaVenta
		FROM [Global].[dbo].[Z_VE_Liverpool]
		where 1 = 1
		  order by FechaSubida_Liverpool desc
	end

	if @Chedraui = 1
	begin	
		 Select distinct top 100
			   [FechaSubida] FechaSubida_Chedraui
			  ,Fecha
		FROM [Global].[dbo].[Z_VE_Chedraui]
		where 1 = 1
		  order by FechaSubida_Chedraui desc
	end

	if @Cityfresko = 1
	begin	
		Select distinct top 100
			  [FechaSubida] FechaSubida_Cityfresko
			  ,FECHA
		FROM [Global].[dbo].[Z_VE_Cityfresko]
		where 1 = 1
		  order by FechaSubida_Cityfresko desc
	end

	if @Heb = 1
	begin	
		  Select distinct top 100
			  [FechaSubida] FechaSubida_HEB
			  ,Fecha
		FROM [Global].[dbo].[Z_VT_HEB]
		where 1 = 1
		  order by FechaSubida_HEB desc
	end

	if @Soriana = 1
	begin	
	  Select distinct top 100
		  [FechaSubida] FechaSubida_Soriana
		  ,Fecha
	FROM [Global].[dbo].[Z_VE_Soriana]
	where 1 = 1
	  order by FechaSubida_Soriana desc
	end
end


if @Fecha = 1
begin
	Select distinct top 100
		  convert(date,[FechaSubida]) FechaSubida_Walmart
	FROM [Global].[dbo].[Z_VE_Walmart]
	where 1 = 1
	  order by FechaSubida_Walmart desc

	Select distinct top 100
		  convert(date,[FechaSubida]) FechaSubida_Sanborns
	FROM [Global].[dbo].[Z_VE_Sanborns]
	where 1 = 1
	  order by FechaSubida_Sanborns desc

	  Select distinct top 100
		  convert(date,[FechaSubida]) FechaSubida_Liverpool
	FROM [Global].[dbo].[Z_VE_Liverpool]
	where 1 = 1
	  order by FechaSubida_Liverpool desc

	 Select distinct top 100
		  convert(date,[FechaSubida]) FechaSubida_Chedraui
	FROM [Global].[dbo].[Z_VE_Chedraui]
	where 1 = 1
	  order by FechaSubida_Chedraui desc

	Select distinct top 100
		  convert(date,[FechaSubida]) FechaSubida_Cityfresko
	FROM [Global].[dbo].[Z_VE_Cityfresko]
	where 1 = 1
	  order by FechaSubida_Cityfresko desc

	  Select distinct top 100
		  convert(date,[FechaSubida]) FechaSubida_HEB
	FROM [Global].[dbo].[Z_VT_HEB]
	where 1 = 1
	  order by FechaSubida_HEB desc

	  Select distinct top 100
		  convert(date,[FechaSubida]) FechaSubida_Soriana
	FROM [Global].[dbo].[Z_VE_Soriana]
	where 1 = 1
	  order by FechaSubida_Soriana desc
end


if @FechaVenta = 1
begin
	if @Walmart = 1
	begin	
		Select distinct top 100
			  FECHA FechaVenta_Walmart
			 ,sum(Unidades) Ejemplares
			 ,sum(Venta) Importe
			 ,FechaSubida
		FROM [Global].[dbo].[Z_VE_Walmart]
		where 1 = 1
		  group by FECHA,FechaSubida 
		  order by FechaVenta_Walmart desc
	end

	if @Sanborns = 1
	begin	
		Select distinct top 100
			   FechaVenta_Det FechaVenta_Sanborns
			  ,sum(convert(int,Ventas_Pza_Det)) Ejemplares
			  --,sum(convert(float,CostoVenta_Det)) PVD
			  ,sum(convert(float,PrecioVenta_Det)) PVD
			  ,FechaSubida
		FROM [Global].[dbo].[Z_VE_Sanborns]
		where 1 = 1
		group by FechaVenta_Det,FechaSubida
		  order by FechaVenta_Det desc
	end

	if @Liverpool = 1
	begin	
		  Select distinct top 100
			  [FechaVenta] FechaVenta_Liverpool
			  ,sum(VentasUnidades) Ejemplares
			  ,sum(Ventas$) importe
			  ,FechaSubida
		FROM [Global].[dbo].[Z_VE_Liverpool]
		where 1 = 1
		group by [FechaVenta],FechaSubida
		  order by FechaVenta_Liverpool desc
	  end

	if @Chedraui = 1
	begin	
		 Select distinct top 100
			  Fecha FechaVenta_Chedraui
			 ,sum(Ejemplares) Ejemplares
			 ,sum(PVD) Importe
			 ,FechaSubida
		FROM [Global].[dbo].[Z_VE_Chedraui]
		where 1 = 1
		group by Fecha,FechaSubida
		  order by FechaVenta_Chedraui desc
	  end

	if @Cityfresko = 1
	begin	
		Select distinct top 100
			  FECHA FechaVenta_Cityfresko
			 ,sum(CANTIDAD) Ejemplares
			 ,FECHASUBIDA
		FROM [Global].[dbo].[Z_VE_Cityfresko]
		where 1 = 1
		group by FECHA,FECHASUBIDA
		  order by FechaVenta_Cityfresko desc
	end

	if @Heb = 1
	begin	
		  Select distinct top 100
			  Fecha FechaVenta_HEB
			 ,sum(UnidadesVendidas) Ejemplares
			 ,FechaSubida
		FROM [Global].[dbo].[Z_VT_HEB]
		where 1 = 1
		group by Fecha,FechaSubida
		  order by FechaVenta_HEB desc
	end

	if @Soriana = 1
	begin	
		  Select distinct top 100
			  Fecha FechaVenta_Soriana
			 ,sum(Unidades) Ejemplares
			 ,FechaSubida
		FROM [Global].[dbo].[Z_VE_Soriana]
		where 1 = 1
		group by Fecha,FechaSubida
		  order by FechaVenta_Soriana desc
	end
end
