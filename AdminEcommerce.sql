USE [Ecommerce_TuShoppi]
GO
/****** Object:  StoredProcedure [dbo].[Admin]    Script Date: 23/12/2021 06:49:15 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   proc [dbo].[Admin]

	 @Action varchar(max) = null
	,@JSON varchar(max) = null
	,@XML varchar(max) = null
	,@Order_Id varchar(max) = null
	,@Peso float = 0
    ,@Alto float = 0
    ,@Largo float = 0
    ,@Ancho float = 0
    ,@EsPaquete bit = 1
	,@Maestro_Paquetes_Id int = 0
	,@Estafeta_TiposServicio_Id int = 0
	,@Estafeta_Guia varchar(max) = null
	,@FechaVigenciaGuia date = null
	,@Colonia_Envio varchar(max) = null
	,@Courier_Name varchar(max) = null
	,@Estatus_Guia varchar(max) = null
	,@ServerPath varchar(max) = null
	,@Product_id varchar(max) = null
	,@Image_id varchar(max) = null

as

if @Action = 'Feed_Orders'
begin
--Ecommerce_Orders
--drop table #Orders
SELECT 
			   Order_Id 
			  ,convert(datetime,replace(Order_Created_At,right(Order_Created_At, CHARINDEX('-', REVERSE(Order_Created_At)) -0),'')) Order_Created_At
			  ,convert(datetime,replace(Order_Updated_At ,right(Order_Updated_At , CHARINDEX('-', REVERSE(Order_Updated_At )) -0),'')) Order_Updated_At
			  ,Order_Number 
			  ,Order_Status_Url 
			  ,Order_Ammount 
			  ,Customer_Id
			  ,Shipping_Address 
			  ,Shipping_Address_Phone 
			  ,Shipping_Address_City 
			  ,Shipping_Address_Zip 
			  ,Shipping_Address_Province 
			  ,Shipping_Address_Country 
			  ,Shipping_Address_Latitude
			  ,Shipping_Address_Longitude
			  ,Shipping_Address_Country_Code
			  ,Shipping_Address_Province_Code
			  ,Billing_Address 
			  ,Billing_Address_Phone 
			  ,Billing_Address_City 
			  ,Billing_Address_Zip 
			  ,Billing_Address_Province 
			  ,Billing_Address_Country 
			  ,Billing_Address_Latitude 
			  ,Billing_Address_Longitude
			  ,Billing_Address_Country_Code 
			  ,Billing_Address_Province_Code 
			  ,Getdate() [date]
			  ,Fulfillment_Status
			  ,Financial_Status
			  ,Fulfillment_Id
			  ,Shipping_Address2
			  ,Billing_Address2
			  ,Email
			  ,Shipping_Address_First_Name
			  ,Shipping_Address_Last_Name
			  ,Billing_Address_First_Name
			  ,Billing_Address_Last_Name
			  into #temp_Orders
FROM 
OPENJSON ( @JSON, '$.orders' )  
WITH (
			   Order_Id varchar(max) '$.id'
			  ,Order_Created_At varchar(max) '$.created_at'
			  ,Order_Updated_At varchar(max) '$.updated_at'
			  ,Order_Number int '$.order_number'
			  ,Order_Status_Url varchar(max) '$.order_status_url'
			  ,Order_Ammount float '$.total_line_items_price_set.shop_money.amount'
			  ,Customer_Id varchar(max) '$.customer.id'
			  ,Shipping_Address varchar(max) '$.shipping_address.address1'
			  ,Shipping_Address_Phone varchar(max) '$.shipping_address.phone'
			  ,Shipping_Address_City varchar(max) '$.shipping_address.city'
			  ,Shipping_Address_Zip varchar(max) '$.shipping_address.zip'
			  ,Shipping_Address_Province varchar(max) '$.shipping_address.province'
			  ,Shipping_Address_Country varchar(max) '$.shipping_address.country'
			  ,Shipping_Address_Latitude varchar(max) '$.shipping_address.latitude'
			  ,Shipping_Address_Longitude varchar(max) '$.shipping_address.longitude'
			  ,Shipping_Address_Country_Code varchar(max) '$.shipping_address.country_code'
			  ,Shipping_Address_Province_Code varchar(max) '$.shipping_address.province_code'
			  ,Billing_Address varchar(max) '$.billing_address.address1'
			  ,Billing_Address_Phone varchar(max) '$.billing_address.phone'
			  ,Billing_Address_City varchar(max) '$.billing_address.city'
			  ,Billing_Address_Zip varchar(max) '$.billing_address.zip'
			  ,Billing_Address_Province varchar(max) '$.billing_address.province'
			  ,Billing_Address_Country varchar(max) '$.billing_address.country'
			  ,Billing_Address_Latitude varchar(max) '$.billing_address.latitude'
			  ,Billing_Address_Longitude varchar(max) '$.billing_address.longitude'
			  ,Billing_Address_Country_Code varchar(max) '$.billing_address.country_code'
			  ,Billing_Address_Province_Code varchar(max) '$.billing_address.province_code'
			  ,Fulfillment_Status varchar(max) '$.fulfillment_status'
			  ,Financial_Status varchar(max) '$.financial_status'
			  ,Fulfillment_Id varchar(max) '$.fulfillments[0].id'
			  ,Shipping_Address2 varchar(max) '$.shipping_address.address2'
			  ,Billing_Address2 varchar(max) '$.billing_address.address2'
			  ,Email varchar(max) '$.customer.email'
			  ,Shipping_Address_First_Name varchar(max) '$.shipping_address.first_name'
			  ,Shipping_Address_Last_Name varchar(max) '$.shipping_address.last_name'
			  ,Billing_Address_First_Name varchar(max) '$.billing_address.first_name'
			  ,Billing_Address_Last_Name varchar(max) '$.billing_address.last_name'
 )
 
 order by Order_Id desc

insert into Shopify_Orders
select * from #temp_Orders a
where 1 = 1
	and not exists (select * from Shopify_Orders b
		where 1 = 1
			and a.Order_Id = b.Order_Id)

--Updating Fulfillment_Status
update a
	set 
		a.Fulfillment_Status = isnull(b.Fulfillment_Status,'unfulfilled')
	   ,a.Financial_Status = b.Financial_Status
	   ,a.Fulfillment_Id = b.Fulfillment_Id
	   ,a.Shipping_Address2 = b.Shipping_Address2
	   ,a.Billing_Address2 = b.Billing_Address2
	   ,a.Email = b.Email
	   ,a.Shipping_Address_First_Name = b.Shipping_Address_First_Name 
	   ,a.Shipping_Address_Last_Name = b.Shipping_Address_Last_Name
	   ,a.Billing_Address_First_Name = b.Billing_Address_First_Name 
	   ,a.Billing_Address_Last_Name = b.Billing_Address_Last_Name

from Shopify_Orders a
left outer join #temp_Orders b
on a.Order_Id = b.Order_Id
where 1 = 1
and exists (select * from #temp_Orders c
		where 1 = 1
			and a.Order_Id = c.Order_Id)

select distinct Order_Id 
into #Estafeta_Guias 
from Shopify_Orders a
where 1 = 1
	and not exists (select distinct Order_Id from Estafeta_Guias b
		where 1 = 1
			and a.Order_Id = b.Order_Id)

	insert into Estafeta_Guias
		select null
		,Order_Id
		,null
		,GETDATE() 
		,'NEW ORDER'
	from #Estafeta_Guias

--Clientes que no existen y que SI tienen Customer_ID
delete from Shopify_Customers
where 1 = 1
	and First_Name is null

insert into Shopify_Customers
select 
	 Customer_Id
	,Email
	,isnull(Shipping_Address_Phone,Billing_Address_Phone)
	,null
	,Order_Created_At
	,Order_Updated_At
	,isnull(Shipping_Address_First_Name,Billing_Address_First_Name)
	,isnull(Shipping_Address_Last_Name,Billing_Address_Last_Name)
	,isnull(Shipping_Address,Billing_Address)
	,isnull(Shipping_Address2,Billing_Address2)
	,isnull(Shipping_Address_City,Billing_Address_City)
	,isnull(Shipping_Address_Province,Billing_Address_Province)
	,isnull(Shipping_Address_Country,Billing_Address_Country)
	,isnull(Shipping_Address_Zip,Billing_Address_Zip)
	,isnull(Shipping_Address_Phone,Billing_Address_Phone)
	,isnull(Shipping_Address_Province_Code,Billing_Address_Province_Code)
	,isnull(Shipping_Address_Country_Code,Billing_Address_Country_Code)
	,isnull(Shipping_Address_Country,Billing_Address_Country)
	,GETDATE()

from Shopify_Orders a
where 1 = 1
	and not exists (select * from Shopify_Customers b
		where 1 = 1
			and a.Customer_Id = b.Customer_Id)
	and a.Customer_Id is not null
order by convert(int,a.Order_Number) desc


	update a
	set a.Shipping_Address2 = 'N/A'
		from Shopify_Orders a
	where 1 = 1
		and (Shipping_Address2 IS NULL or Shipping_Address2  = '')

end

if @Action = 'Feed_Order_Products'
begin
	
SELECT 
	 o.id Order_Id
	,p.product_id Product_Id
	,p.quantity Product_Quantity
	into #temp_Order_Products
FROM 
OPENJSON ( @JSON, '$.orders')
WITH (
			    id varchar(max)
		   ,line_items nvarchar(max) as JSON
		   
 ) as [o]
cross apply
OPENJSON (line_items) 
 WITH (
			   product_id varchar(max)
			  ,quantity int
 
 ) as [p]

 order by Order_Id desc

 
insert into Shopify_Order_Products
select *, GETDATE() from #temp_Order_Products a
where 1 = 1
	and not exists (select * from Shopify_Order_Products b
		where 1 = 1
			and a.Order_Id = b.Order_Id
			and a.Product_Id = b.Product_Id)

end 

if @Action = 'Feed_Products'
begin
	SELECT 
	          Product_Id 
			 ,Name 
			 ,Description 
			 ,Created_At 
			 ,Updated_At 
			 ,Price 
			 ,SKU 
			 ,Position 
			 ,Inventory_Policy 
			 ,Compare_At_Price 
			 ,Fulfillment_Service 
			 ,Barcode 
			 ,Grams 
			 ,Weight 
			 ,Weight_Unit 
			 ,Inventory_Item_Id 
			 ,Inventory_Quantity 
			 ,Old_Inventory_Quantity 
			 ,Requires_Shipping 
			 into #temp_Products
FROM 
OPENJSON ( @JSON, '$.products' )  
WITH (
			  Product_Id varchar(max) '$.id'
			 ,Name varchar(max) '$.title'
			 ,Description varchar (max) '$.body_html'
			 ,Created_At varchar(max) '$.created_at'
			 ,Updated_At varchar(max) '$.updated_at'
			 ,Price float '$.variants[0].price'
			 ,SKU varchar(max) '$.variants[0].sku'
			 ,Position varchar(max) '$.variants[0].position'
			 ,Inventory_Policy varchar(max) '$.variants[0].inventory_policy'
			 ,Compare_At_Price float '$.variants[0].compare_at_price'
			 ,Fulfillment_Service varchar(max) '$.variants[0].fulfillment_service'
			 ,Barcode varchar(max) '$.variants[0].barcode'
			 ,Grams float '$.variants[0].grams'
			 ,Weight float '$.variants[0].weight'
			 ,Weight_Unit varchar(max) '$.variants[0].weight_unit'
			 ,Inventory_Item_Id varchar(max) '$.variants[0].inventory_item_id'
			 ,Inventory_Quantity int '$.variants[0].inventory_quantity'
			 ,Old_Inventory_Quantity int '$.variants[0].old_inventory_quantity'
			 ,Requires_Shipping bit '$.variants[0].requires_shipping'
 )
 
 insert into Shopify_Products
 select *, null, null, null, null, GETDATE() from #temp_Products a
 where 1 = 1
	and not exists (select * from Shopify_Products b
		where 1 = 1
			and a.Product_Id = b.Product_Id)

--Asignación de valores de Peso y Volumetría de los productos
 -- update a
	--set 
	--	a.Peso = b.Unit_Weight
	--   ,a.Largo = b.Unit_Length
	--   ,a.Ancho = b.Unit_Width
	--   ,a.Alto = b.Unit_Height
 -- FROM [Ecommerce_TuShoppi].[dbo].[Shopify_Products] a
	--left outer join Maestro_Productos_Dimensiones b
	--on a.SKU = b.Item
 -- where 1 = 1
	--and a.Peso is null
	--and a.Largo is null
	--and a.Ancho is null
	--and a.Alto is null
	
 update a
	set 
		a.Peso = round(.100,2)
	   ,a.Largo = round(0.135,2)
	   ,a.Ancho = round(0.105,2)
	   ,a.Alto = round(0.03,2)
  FROM Shopify_Products a
  where 1 = 1
	
	


end

if @Action = 'Feed_Products_Images_Data'
begin
	SELECT 
				  p.product_id,
				  p.id,
				  p.src
		into #temp_Images
	FROM 
	OPENJSON ( @JSON, '$.products' )  
	WITH (
				  images nvarchar(max) as JSON
	 )as [o]
	 cross apply
	 openjson (images)
	 with(

		  product_id varchar(max),
		  id varchar(max),
          src varchar(max)

	 )as [p]
	 --where 1 = 1
	 --and o.id = '5555395723430'

	  SELECT 
				  p.product_id,
				  p.id

		into #temp_ImagesPrincipal
	FROM 
	OPENJSON ( @JSON, '$.products' )  
	WITH (
				  [image] nvarchar(max) as JSON
	 )as [o]
	 cross apply
	 openjson ([image] )
	 with(

		  product_id varchar(max),
		  id varchar(max)

	 )as [p]


select 
	 a.product_id
	,a.id
	,a.src
	,SUBSTRING(REVERSE(SUBSTRING(REVERSE(a.src),0,CHARINDEX('/',REVERSE(a.src)))),0,CHARINDEX('?',REVERSE(SUBSTRING(REVERSE(a.src),0,CHARINDEX('/',REVERSE(a.src)))))) [Name]
	,null ServerPath
	,0 isPrincipal
	into #temp_NameArch
from #temp_Images a	


---select * from #temp_NameArch

update a
	set a.isPrincipal = 1
from #temp_NameArch a
where 1 = 1
 and exists (select * from #temp_ImagesPrincipal b
				where 1 = 1
					and a.product_id = b.product_id
					and a.id = b.id)

					
insert into Shopify_Products_Images
select 
	a.*,GETDATE() 
from #temp_NameArch a
where 1 = 1
	and not exists (select * from Shopify_Products_Images b
		where 1 = 1
			and a.id = b.Image_id
			and a.product_id = b.Product_id)

update a
set a.IsPrincipal = 0
from Shopify_Products_Images a

update a
	set a.isPrincipal = 1
from Shopify_Products_Images a
where 1 = 1
 and exists (select * from #temp_ImagesPrincipal b
				where 1 = 1
					and a.product_id = b.product_id
					and a.Image_id = b.id)

end

if @Action = 'Feed_Products_Images'
begin
	
	--SELECT 
	--		Product_id
	--		,Image_id
	--		,ServerPath
	--	into #temp_ImagesServer
	--FROM 
	--OPENJSON ( @JSON, '$.images' )  
	--WITH (
	--			  Product_id nvarchar(max) '$.Product_id'
	--			  ,Image_id nvarchar(max) '$.Image_id'
	--			  ,ServerPath nvarchar(max) '$.ServerPath'
	-- )

	--select * from #temp_ImagesServer
	--select * from Images_Products

	update  a
	set a.ServerPath = @ServerPath
	from Shopify_Products_Images a
	where 1 = 1
		and Product_id = @Product_id
		and Image_id = @Image_id

end

if @Action = 'Feed_Customers'
begin
	SELECT	
				Customer_Id 
			   ,Email 
			   ,Phone 
			   ,Accepts_Marketing 
			   ,convert(datetime,replace(Created_At,right(Created_At, CHARINDEX('-', REVERSE(Created_At)) -0),'')) Created_At
			   ,convert(datetime,replace(Updated_At ,right(Updated_At , CHARINDEX('-', REVERSE(Updated_At )) -0),'')) Updated_At
			   ,First_Name 
			   ,Last_Name 
			   ,Default_Address_Address1 
			   ,Default_Address_Address2 
			   ,Default_Address_City 
			   ,Default_Address_Province 
			   ,Default_Address_Country 
			   ,Default_Address_Zip 
			   ,Default_Address_Phone 
			   ,Default_Address_Province_Code 
			   ,Default_Address_Country_Code 
			   ,Default_Address_Country_Name 
			   into #temp_Customers
FROM 
OPENJSON ( @JSON, '$.customers' )  
WITH (
                Customer_Id varchar(max) '$.id'
			   ,Email varchar(max) '$.email'
			   ,Phone varchar(max) '$.phone'
			   ,Accepts_Marketing bit '$.accepts_marketing'
			   ,Created_At varchar(max) '$.created_at'
			   ,Updated_At varchar(max) '$.updated_at'
			   ,First_Name varchar(max) '$.first_name'
			   ,Last_Name varchar(max) '$.last_name'
			   ,Default_Address_Address1 varchar(max) '$.default_address.address1'
			   ,Default_Address_Address2 varchar(max) '$.default_address.address2'
			   ,Default_Address_City varchar(max) '$.default_address.city'
			   ,Default_Address_Province varchar(max) '$.default_address.province'
			   ,Default_Address_Country varchar(max) '$.default_address.country'
			   ,Default_Address_Zip varchar(max) '$.default_address.zip'
			   ,Default_Address_Phone varchar(max) '$.default_address.phone'
			   ,Default_Address_Province_Code varchar(max) '$.default_address.province_code'
			   ,Default_Address_Country_Code varchar(max) '$.default_address.country_code'
			   ,Default_Address_Country_Name varchar(max) '$.default_address.country_name'
 )
 
 insert into Shopify_Customers
 select *,GETDATE() from #temp_Customers a
 where 1 = 1
	and not exists (select * from Shopify_Customers b
		where 1 = 1
			and a.Customer_Id = b.Customer_Id)

end

if @Action = 'Determinar_Dimensiones_Para_CotizacionEstafeta'
begin

select 
	 a.*
	,round(convert(float,a.Product_Quantity) * b.Peso,2) PesoTotal
	into #Shopify_Order_Products_Peso
from Shopify_Order_Products a
	left outer join Shopify_Products b
	on a.Product_Id = b.Product_Id
where Order_Id = @Order_Id


select @Peso = (select 
	sum(PesoTotal)
from #Shopify_Order_Products_Peso
where Order_Id = @Order_Id)

select 
	 a.*
	,round(convert(float,a.Product_Quantity) * b.Ancho,2) AnchoTotal
	 into #Shopify_Order_Products_Ancho
from Shopify_Order_Products a
	left outer join Shopify_Products b
	on a.Product_Id = b.Product_Id
where Order_Id = @Order_Id

select @Alto = (select 
	sum(a.AnchoTotal)
from #Shopify_Order_Products_Ancho a
where Order_Id = @Order_Id)

select @Largo = (select 
	max(b.Alto)
from Shopify_Order_Products a
	left outer join Shopify_Products b
	on a.Product_Id = b.Product_Id
where Order_Id = @Order_Id)

select @Ancho = (select 
	max(b.Largo)
from Shopify_Order_Products a
	left outer join Shopify_Products b
	on a.Product_Id = b.Product_Id
where Order_Id = @Order_Id)

select 
	 a.* 
	,b.Peso
	,b.Alto
	,b.Largo
	,b.Ancho
from Shopify_Order_Products a
	left outer join Shopify_Products b
	on a.Product_Id = b.Product_Id
where Order_Id = @Order_Id
order by Product_Id asc


if exists (select * from Estafeta_Order_Especificaciones 
where Order_Id = @Order_Id)
begin
	update a
	set 
		 a.EsPaquete = null
		,a.Peso = @Peso
		,a.Alto = @Alto
		,a.Largo = @Largo
		,a.Ancho = @Ancho
		,a.Created_At = GETDATE()
		from Estafeta_Order_Especificaciones a
		where 1 = 1
			and a.Order_Id = @Order_Id
end
else
begin
	insert into Estafeta_Order_Especificaciones
	values (@Order_Id, null, @Largo, @Peso, @Alto, @Ancho, GETDATE(), null, null, null, null, null, null, null, null, null)
end


end

if @Action = 'Feed_Estafeta_Cotizacion'
begin
	
	--https://frecuenciacotizador.estafeta.com/Service.asmx?WSDL

	declare 
	  @mydoc xml
	
	 ,@iEsPaquete int
	 ,@iLargo int
	 ,@iPeso int
	 ,@iAlto int
	 ,@iAncho int

	 ,@i1 int
	 ,@i2 int
	 ,@i3 int
	 ,@i4 int
	 ,@i5 int
	 ,@i6 int
	 ,@i7 int
	 ,@i8 int
	 ,@i9 int
	 ,@i10 int

	 ,@iOrigen_CodigoPosOri int
	 ,@iOrigen_PlazaOri int
	 ,@iOrigen_MunicipioOri int
	 ,@iOrigen_EstadoOri int

	 ,@iDestino_CpDestino int
	 ,@iDestino_Plaza1 int
	 ,@iDestino_Municipio int
	 ,@iDestino_Estado int

	 ,@iDestinoColonias int

	 
	select @XML = REPLACE(@XML,'<?xml version="1.0" encoding="utf-16"?>','')
	select @XML = REPLACE(@XML,' xmlns="http://www.estafeta.com/"','')
	select @XML = REPLACE(@XML,'<ArrayOfRespuesta xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">','<Body>')
	select @XML = REPLACE(@XML,'</ArrayOfRespuesta>','</Body>')

	set @mydoc = @XML

	
exec sp_xml_preparedocument @iEsPaquete output, @mydoc
exec sp_xml_preparedocument @iLargo output, @mydoc
exec sp_xml_preparedocument @iPeso output, @mydoc
exec sp_xml_preparedocument @iAlto output, @mydoc
exec sp_xml_preparedocument @iAncho output, @mydoc

exec sp_xml_preparedocument @i1 output, @mydoc
exec sp_xml_preparedocument @i2 output, @mydoc
exec sp_xml_preparedocument @i3 output, @mydoc
exec sp_xml_preparedocument @i4 output, @mydoc
exec sp_xml_preparedocument @i5 output, @mydoc
exec sp_xml_preparedocument @i6 output, @mydoc
exec sp_xml_preparedocument @i7 output, @mydoc
exec sp_xml_preparedocument @i8 output, @mydoc
exec sp_xml_preparedocument @i9 output, @mydoc
exec sp_xml_preparedocument @i10 output, @mydoc

exec sp_xml_preparedocument @iOrigen_CodigoPosOri  output, @mydoc
exec sp_xml_preparedocument @iOrigen_PlazaOri output, @mydoc
exec sp_xml_preparedocument @iOrigen_MunicipioOri output, @mydoc
exec sp_xml_preparedocument @iOrigen_EstadoOri output, @mydoc

exec sp_xml_preparedocument @iDestino_CpDestino output, @mydoc
exec sp_xml_preparedocument @iDestino_Plaza1 output, @mydoc
exec sp_xml_preparedocument @iDestino_Municipio output, @mydoc
exec sp_xml_preparedocument @iDestino_Estado output, @mydoc

exec sp_xml_preparedocument @iDestinoColonias output, @mydoc

	if OBJECT_ID('tempdb..#iEsPaquete')is not null begin drop table #iEsPaquete end
	if OBJECT_ID('tempdb..#iLargo')is not null begin drop table #iLargo end
	if OBJECT_ID('tempdb..#iPeso')is not null begin drop table #iPeso end
	if OBJECT_ID('tempdb..#iAlto')is not null begin drop table #iAlto end
	if OBJECT_ID('tempdb..#iAncho')is not null begin drop table #iAncho end
	
	if OBJECT_ID('tempdb..#i1')is not null begin drop table #i1 end
	if OBJECT_ID('tempdb..#i2')is not null begin drop table #i2 end
	if OBJECT_ID('tempdb..#i3')is not null begin drop table #i3 end
	if OBJECT_ID('tempdb..#i4')is not null begin drop table #i4 end
	if OBJECT_ID('tempdb..#i5')is not null begin drop table #i5 end
	if OBJECT_ID('tempdb..#i6')is not null begin drop table #i6 end
	if OBJECT_ID('tempdb..#i7')is not null begin drop table #i7 end
	if OBJECT_ID('tempdb..#i8')is not null begin drop table #i8 end
	if OBJECT_ID('tempdb..#i9')is not null begin drop table #i9 end
	if OBJECT_ID('tempdb..#i10')is not null begin drop table #i10 end

	if OBJECT_ID('tempdb..#iOrigen_CodigoPosOri')is not null begin drop table #iOrigen_CodigoPosOri end
	if OBJECT_ID('tempdb..#iOrigen_PlazaOri')is not null begin drop table #iOrigen_PlazaOri end
	if OBJECT_ID('tempdb..#iOrigen_MunicipioOri')is not null begin drop table #iOrigen_MunicipioOri end
	if OBJECT_ID('tempdb..#iOrigen_EstadoOri')is not null begin drop table #iOrigen_EstadoOri end

	if OBJECT_ID('tempdb..#iDestino_CpDestino')is not null begin drop table #iDestino_CpDestino end
	if OBJECT_ID('tempdb..#iDestino_Plaza1')is not null begin drop table #iDestino_Plaza1 end
	if OBJECT_ID('tempdb..#iDestino_Municipio')is not null begin drop table #iDestino_Municipio end
	if OBJECT_ID('tempdb..#iDestino_Estado ')is not null begin drop table #iDestino_Estado end

	if OBJECT_ID('tempdb..#iDestinoColonias')is not null begin drop table #iDestinoColonias end

	select 
		 Id 
		,[text] [EsPaquete]
		into #iEsPaquete
	from OPENXML(@iEsPaquete, '/Body/Respuesta/TipoEnvio/EsPaquete')
	where text is not null

	select 
		 Id 
		,[text] [Largo]
		into #iLargo
	from OPENXML(@iLargo, '/Body/Respuesta/TipoEnvio/Largo')
	where text is not null

	select 
		 Id 
		,[text] [Peso]
		into #iPeso
	from OPENXML(@iPeso, '/Body/Respuesta/TipoEnvio/Peso')
	where text is not null

	select 
		 Id 
		,[text] [Alto]
		into #iAlto
	from OPENXML(@iAlto, '/Body/Respuesta/TipoEnvio/Alto')
	where text is not null

	select 
		 Id 
		,[text] [Ancho]
		into #iAncho
	from OPENXML(@iAncho, '/Body/Respuesta/TipoEnvio/Ancho')
	where text is not null

	select 
		 Id 
		,[text] [DescripcionServicio]
		into #i1
	from OPENXML(@i1, '/Body/Respuesta/TipoServicio/TipoServicio/DescripcionServicio')
	where text is not null


	select 
		 Id 
		,[text] [TipoEnvioRes]
		into #i2
	from OPENXML(@i2, '/Body/Respuesta/TipoServicio/TipoServicio/TipoEnvioRes')
	where text is not null

	select 
		 Id 
		,[text] [AplicaCotizacion]
		into #i3
	from OPENXML(@i3, '/Body/Respuesta/TipoServicio/TipoServicio/AplicaCotizacion')
	where text is not null


	select 
		 Id 
		,[text] [TarifaBase]
		into #i4
	from OPENXML(@i4, '/Body/Respuesta/TipoServicio/TipoServicio/TarifaBase')
	where text is not null


	select 
		 Id 
		,[text] [CCTarifaBase]
		into #i5
	from OPENXML(@i5, '/Body/Respuesta/TipoServicio/TipoServicio/CCTarifaBase')
	where text is not null

	select 
		 Id 
		,[text] [CargosExtra]
		into #i6
	from OPENXML(@i6, '/Body/Respuesta/TipoServicio/TipoServicio/AplicaServicio')
	where text is not null

	select 
		 Id 
		,[text] [SobrePeso]
		into #i7
	from OPENXML(@i7, '/Body/Respuesta/TipoServicio/TipoServicio/SobrePeso')
	where text is not null

	select 
		 Id 
		,[text] [CCSobrePeso]
		into #i8
	from OPENXML(@i8, '/Body/Respuesta/TipoServicio/TipoServicio/CCSobrePeso')
	where text is not null

	select 
		 Id 
		,[text] [Peso]
		into #i9
	from OPENXML(@i9, '/Body/Respuesta/TipoServicio/TipoServicio/Peso')
	where text is not null

	select 
		 Id 
		,[text] [CostoTotal]
		into #i10
	from OPENXML(@i10, '/Body/Respuesta/TipoServicio/TipoServicio/CostoTotal')
	where text is not null

	--Origen
	select 
		 Id 
		,[text] CodigoPosOri
		into #iOrigen_CodigoPosOri
	from OPENXML(@iOrigen_CodigoPosOri, '/Body/Respuesta/Origen/CodigoPosOri')
	where text is not null

	select 
		 Id 
		,[text] PlazaOri
		into #iOrigen_PlazaOri
	from OPENXML(@iOrigen_PlazaOri, '/Body/Respuesta/Origen/PlazaOri')
	where text is not null

	select 
		 Id 
		,[text] MunicipioOri
		into #iOrigen_MunicipioOri
	from OPENXML(@iOrigen_MunicipioOri, '/Body/Respuesta/Origen/MunicipioOri')
	where text is not null

	select 
		 Id 
		,[text] EstadoOri
		into #iOrigen_EstadoOri
	from OPENXML(@iOrigen_EstadoOri, '/Body/Respuesta/Origen/EstadoOri')
	where text is not null

	--Destino
	select 
		 Id 
		,[text] CpDestino
		into #iDestino_CpDestino
	from OPENXML(@iDestino_CpDestino, '/Body/Respuesta/Destino/CpDestino')
	where text is not null

	select 
		 Id 
		,[text] Plaza1
		into #iDestino_Plaza1
	from OPENXML(@iDestino_Plaza1, '/Body/Respuesta/Destino/Plaza1')
	where text is not null

	select 
		 Id 
		,[text] Municipio
		into #iDestino_Municipio
	from OPENXML(@iDestino_Municipio, '/Body/Respuesta/Destino/Municipio')
	where text is not null

	select 
		 Id 
		,[text] Estado
		into #iDestino_Estado
	from OPENXML(@iDestino_Estado, '/Body/Respuesta/Destino/Estado')
	where text is not null


	--Destino Colonias
	select 
		 Id 
		,[text] Destino_Colonias
		into #iDestinoColonias
	from OPENXML(@iDestinoColonias, '/Body/Respuesta/Colonias/Colonias')
	where text is not null

	--Cruce Orden
	delete from Estafeta_Order
	where Order_Id = @Order_Id

	insert into Estafeta_Order
	select 
		 @Order_Id Order_Id
		,a.DescripcionServicio
		,b.TipoEnvioRes
		,c.AplicaCotizacion 
		,convert(float,convert(varchar(max),d.TarifaBase))
		,convert(float,convert(varchar(max),e.CCTarifaBase))
		,f.CargosExtra
		,convert(float,convert(varchar(max),g.SobrePeso))
		,convert(float,convert(varchar(max),h.CCSobrePeso))
		,convert(float,convert(varchar(max),i.Peso))
		,convert(float,convert(varchar(max),j.CostoTotal))
		,GETDATE() Created_At
	from #i1 a
		left outer join #i2 b
		on a.Id = b.Id
		left outer join #i3 c
		on a.Id = c.Id
		left outer join #i4 d
		on a.Id = d.Id
		left outer join #i5 e
		on a.Id = e.Id
		left outer join #i6 f
		on a.Id = f.Id
		left outer join #i7 g
		on a.Id = g.Id
		left outer join #i8 h
		on a.Id = h.Id
		left outer join #i9 i
		on a.Id = i.Id
		left outer join #i10 j
		on a.Id = j.Id


	--Cruce Origen y Destino
	delete from Estafeta_Order_OrigenDestino
	where Order_Id = @Order_Id

	insert into Estafeta_Order_OrigenDestino
	select 
		 @Order_Id Order_Id	
		,a.CodigoPosOri Origen_CodigoPosOri
		,b.PlazaOri Origen_PlazaOri
		,c.MunicipioOri Origen_MunicipioOri
		,d.EstadoOri Origen_EstadoOri
		,e.CpDestino Destino_CpDestino
		,f.Plaza1 Destino_Plaza1
		,g.Municipio Origen_Municipio
		,h.Estado Origen_Estado
		,GETDATE() Created_At
	from #iOrigen_CodigoPosOri a
		left outer join #iOrigen_PlazaOri b
		on a.Id = b.Id
		left outer join #iOrigen_MunicipioOri c
		on a.Id = c.Id
		left outer join #iOrigen_EstadoOri d
		on a.Id = d.Id

		left outer join #iDestino_CpDestino e
		on a.Id = e.Id
		left outer join #iDestino_Plaza1 f
		on a.Id = f.Id
		left outer join #iDestino_Municipio g
		on a.Id = g.Id
		left outer join #iDestino_Estado h
		on a.Id = h.Id

	--Colonias
	delete from Estafeta_Order_DestinoColonias
	where Order_Id = @Order_Id

	insert into Estafeta_Order_DestinoColonias
	select 
		 @Order_Id Orden_Id
		,Destino_Colonias
		,GETDATE() Created_At
	from #iDestinoColonias

	
--Modificación de estatus en Estafeta_Guias
insert into Estafeta_Guias_Log
Select  
	 Guia_Id
	,Order_Id
	,UserId
	,Created_At
	,Estafeta_EstatusEntrega
from Estafeta_Guias
where Order_Id = @Order_Id

update a
set a.Estafeta_EstatusEntrega = 'VALUED', Created_At = GETDATE()
	from Estafeta_Guias a
	where Order_Id = @Order_Id

end

if @Action = 'DeterminarPaqueteIdeal' --Ingresar el %Espacio Adicional
begin
	
	Select @Peso = Peso, @Alto = Alto, @Largo = Largo, @Ancho = Ancho
	from Estafeta_Order_Especificaciones
		where 1 = 1
			and Order_Id = @Order_Id
			--and Order_Id = '2634821533862'
		
	if OBJECT_ID('tempdb..#Peso')is not null begin drop table #Peso end
	if OBJECT_ID('tempdb..#Alto')is not null begin drop table #Alto end
	if OBJECT_ID('tempdb..#Largo')is not null begin drop table #Largo end
	if OBJECT_ID('tempdb..#Ancho')is not null begin drop table #Ancho end
	if OBJECT_ID('tempdb..#RecomendacionPaquete')is not null begin drop table #RecomendacionPaquete end

	select Id, Peso
	into #Peso
	from Maestro_Paquetes
	where 1 = 1

	select Id, Alto
	into #Alto
	from Maestro_Paquetes
	where 1 = 1
		and Alto >= @Alto

	select Id, Largo
	into #Largo
	from Maestro_Paquetes
	where 1 = 1
		and Largo >= @Largo

	select Id, Ancho
	into #Ancho
	from Maestro_Paquetes
	where 1 = 1
		and Ancho >= @Ancho

	--select @Peso Peso, @Alto Alto, @Largo Largo, @Ancho Ancho

	select top 1
		a.Id
	   ,a.Peso
	   ,b.Alto
	   ,c.Largo
	   ,d.Ancho
	   into #RecomendacionPaquete
	from #Peso a
		left outer join #Alto b
		on a.Id = b.Id
		left outer join #Largo c
		on a.Id = c.Id
		left outer join #Ancho d
		on a.Id =d.Id
	where 1 = 1
		and b.Alto is not null
		and c.Largo is not null
		and d.Ancho is not null
	order by a.Peso asc

	if (select COUNT(*) from #RecomendacionPaquete) > 0
	begin
		select 'ID paquete recomendado: ' + convert(varchar,Id) from #RecomendacionPaquete

		update a
		set a.Maestro_Paquetes_Recommended_Id = (select Id from #RecomendacionPaquete)
			from Estafeta_Order_Especificaciones a
			where Order_Id = @Order_Id
	end
	else
	begin
		select 'Ningún paquete cumple con las especificaciones mínimas'

		update a
		set a.Maestro_Paquetes_Recommended_Id = null
			from Estafeta_Order_Especificaciones a
			where Order_Id = @Order_Id
	end 
end 

if @Action = 'Set_Paquete'
begin
	
	--Log
	insert into Estafeta_Order_Especificaciones_Log
	select 
	   [Order_Id]
      ,[EsPaquete]
      ,[Largo]
      ,[Peso]
      ,[Alto]
      ,[Ancho]
      ,[Created_At]
      ,[Maestro_Paquetes_Recommended_Id]
      ,[Maestro_Paquetes_Id]
      ,[Peso_Final_Paquete]
	  ,Estafeta_TiposServicio_Id
	  ,Estafeta_Guia
	  ,FechaVigenciaGuia
	  ,Colonia_Envio
	  ,Courier_Name
	  ,Courier_Delivered
	from Estafeta_Order_Especificaciones
	where 1 = 1
		and Order_Id = @Order_Id

	update a
	set a.Maestro_Paquetes_Id = @Maestro_Paquetes_Id, Peso_Final_Paquete = null
		from Estafeta_Order_Especificaciones a
		where 1 = 1
			and Order_Id = @Order_Id

	--Modificación de estatus en Estafeta_Guias
	insert into Estafeta_Guias_Log
	Select  
		 Guia_Id
		,Order_Id
		,UserId
		,Created_At
		,Estafeta_EstatusEntrega
	from Estafeta_Guias
	where Order_Id = @Order_Id

	update a
	set a.Estafeta_EstatusEntrega = 'PACKED', Created_At = GETDATE()
		from Estafeta_Guias a
		where Order_Id = @Order_Id

end

if @Action = 'Set_PesoFinalPaquete'
begin
	
	--Log
	insert into Estafeta_Order_Especificaciones_Log
	select 
	   [Order_Id]
      ,[EsPaquete]
      ,[Largo]
      ,[Peso]
      ,[Alto]
      ,[Ancho]
      ,[Created_At]
      ,[Maestro_Paquetes_Recommended_Id]
      ,[Maestro_Paquetes_Id]
      ,[Peso_Final_Paquete]
	  ,Estafeta_TiposServicio_Id
	  ,Estafeta_Guia
	  ,FechaVigenciaGuia
	  ,Colonia_Envio
	  ,Courier_Name
	  ,Courier_Delivered
	from Estafeta_Order_Especificaciones
	where 1 = 1
		and Order_Id = @Order_Id

	update a
	set a.Peso_Final_Paquete = @Peso
		from Estafeta_Order_Especificaciones a
		where 1 = 1
			and Order_Id = @Order_Id

	--Modificación de estatus en Estafeta_Guias
	insert into Estafeta_Guias_Log
	Select  
		 Guia_Id
		,Order_Id
		,UserId
		,Created_At
		,Estafeta_EstatusEntrega
	from Estafeta_Guias
	where Order_Id = @Order_Id

	update a
	set a.Estafeta_EstatusEntrega = 'PACKED', Created_At = GETDATE()
		from Estafeta_Guias a
		where Order_Id = @Order_Id
end

if @Action = 'ValidarPesoFinal'
begin
	if exists (
	select * from Estafeta_Order_Especificaciones
	where 1 = 1
		and Order_Id = @Order_Id
		and isnull(Peso_Final_Paquete,0) > 0
		)
		begin
			select 1 
		end
	else
		begin
			select 0
		end

end 

if @Action = 'SetService'
begin
	
	--Log
	insert into Estafeta_Order_Especificaciones_Log
	select 
	   [Order_Id]
      ,[EsPaquete]
      ,[Largo]
      ,[Peso]
      ,[Alto]
      ,[Ancho]
      ,[Created_At]
      ,[Maestro_Paquetes_Recommended_Id]
      ,[Maestro_Paquetes_Id]
      ,[Peso_Final_Paquete]
	  ,Estafeta_TiposServicio_Id
	  ,Estafeta_Guia
	  ,FechaVigenciaGuia
	  ,Colonia_Envio
	  ,Courier_Name
	  ,Courier_Delivered
	from Estafeta_Order_Especificaciones
	where 1 = 1
		and Order_Id = @Order_Id

	update a
	set a.Estafeta_TiposServicio_Id = @Estafeta_TiposServicio_Id
		from Estafeta_Order_Especificaciones a
		where 1 = 1
			and Order_Id = @Order_Id	
end

if @Action = 'SetGuia'
begin
	
	--Log
	insert into Estafeta_Order_Especificaciones_Log
	select 
	   [Order_Id]
      ,[EsPaquete]
      ,[Largo]
      ,[Peso]
      ,[Alto]
      ,[Ancho]
      ,[Created_At]
      ,[Maestro_Paquetes_Recommended_Id]
      ,[Maestro_Paquetes_Id]
      ,[Peso_Final_Paquete]
	  ,Estafeta_TiposServicio_Id
	  ,Estafeta_Guia
	  ,FechaVigenciaGuia
	  ,Colonia_Envio
	  ,Courier_Name
	  ,Courier_Delivered
	from Estafeta_Order_Especificaciones
	where 1 = 1
		and Order_Id = @Order_Id

	update a
	set a.Estafeta_Guia = @Estafeta_Guia
		from Estafeta_Order_Especificaciones a
		where 1 = 1
			and Order_Id = @Order_Id

	--Modificación de estatus en Estafeta_Guias
	insert into Estafeta_Guias_Log
	Select  
		 Guia_Id
		,Order_Id
		,UserId
		,Created_At
		,Estafeta_EstatusEntrega
	from Estafeta_Guias
	where Order_Id = @Order_Id

	update a
	set a.Estafeta_EstatusEntrega = 'GUIDE READY', Created_At = GETDATE()
		from Estafeta_Guias a
		where Order_Id = @Order_Id
end

if @Action = 'Set_FechaVigenciaGuia'
begin
	
	--Log
	insert into Estafeta_Order_Especificaciones_Log
	select 
	   [Order_Id]
      ,[EsPaquete]
      ,[Largo]
      ,[Peso]
      ,[Alto]
      ,[Ancho]
      ,[Created_At]
      ,[Maestro_Paquetes_Recommended_Id]
      ,[Maestro_Paquetes_Id]
      ,[Peso_Final_Paquete]
	  ,Estafeta_TiposServicio_Id
	  ,Estafeta_Guia
	  ,FechaVigenciaGuia
	  ,Colonia_Envio
	  ,Courier_Name
	  ,Courier_Delivered
	from Estafeta_Order_Especificaciones
	where 1 = 1
		and Order_Id = @Order_Id

	update a
	set a.FechaVigenciaGuia = @FechaVigenciaGuia
		from Estafeta_Order_Especificaciones a
		where 1 = 1
			and Order_Id = @Order_Id
end

if @Action = 'Set_Colonia'
begin
	
	--Log
	insert into Estafeta_Order_Especificaciones_Log
	select 
	   [Order_Id]
      ,[EsPaquete]
      ,[Largo]
      ,[Peso]
      ,[Alto]
      ,[Ancho]
      ,[Created_At]
      ,[Maestro_Paquetes_Recommended_Id]
      ,[Maestro_Paquetes_Id]
      ,[Peso_Final_Paquete]
	  ,Estafeta_TiposServicio_Id
	  ,Estafeta_Guia
	  ,FechaVigenciaGuia
	  ,Colonia_Envio
	  ,Courier_Name
	  ,Courier_Delivered
	from Estafeta_Order_Especificaciones
	where 1 = 1
		and Order_Id = @Order_Id

	update a
	set a.Colonia_Envio = @Colonia_Envio
		from Estafeta_Order_Especificaciones a
		where 1 = 1
			and Order_Id = @Order_Id
end

if @Action = 'Set_CourierDelivered'
begin
	
	--Log
	insert into Estafeta_Order_Especificaciones_Log
	select 
	   [Order_Id]
      ,[EsPaquete]
      ,[Largo]
      ,[Peso]
      ,[Alto]
      ,[Ancho]
      ,[Created_At]
      ,[Maestro_Paquetes_Recommended_Id]
      ,[Maestro_Paquetes_Id]
      ,[Peso_Final_Paquete]
	  ,Estafeta_TiposServicio_Id
	  ,Estafeta_Guia
	  ,FechaVigenciaGuia
	  ,Colonia_Envio
	  ,Courier_Name
	  ,Courier_Delivered
	from Estafeta_Order_Especificaciones
	where 1 = 1
		and Order_Id = @Order_Id

	update a
	set 
		a.Courier_Name = @Courier_Name
	   ,a.Courier_Delivered = GETDATE()
		from Estafeta_Order_Especificaciones a
		where 1 = 1
			and Order_Id = @Order_Id

	
	--Modificación de estatus en Estafeta_Guias
	insert into Estafeta_Guias_Log
	Select  
		 Guia_Id
		,Order_Id
		,UserId
		,Created_At
		,Estafeta_EstatusEntrega
	from Estafeta_Guias
	where Order_Id = @Order_Id

	update a
	set a.Estafeta_EstatusEntrega = 'DELIVERED COURIER', Created_At = GETDATE()
		from Estafeta_Guias a
		where Order_Id = @Order_Id
end

if @Action = 'Set_EstatusEstafetaGuia'
begin
	if @Estatus_Guia in ('ON_TRANSIT', 'DELIVERED', 'RETURNED')
	begin

	select @Order_Id = Order_Id from Estafeta_Order_Especificaciones
	where 1 = 1
		and @Estafeta_Guia = Estafeta_Guia

	
	if exists (select * from Estafeta_Guias
	where 1 = 1
		and Order_Id = @Order_Id
		and Estafeta_EstatusEntrega = @Estatus_Guia)
		begin
			select 'No se realiza ningún proceso ya que el estatus de entrega es el mismo'
		end
	else
		begin
			--Modificación de estatus en Estafeta_Guias
			insert into Estafeta_Guias_Log
			Select  
				 Guia_Id
				,Order_Id
				,UserId
				,Created_At
				,Estafeta_EstatusEntrega
			from Estafeta_Guias
			where Order_Id = @Order_Id

			update a
			set 
				a.Estafeta_EstatusEntrega = @Estatus_Guia
			   ,Created_At = GETDATE()
			from Estafeta_Guias a
			where Order_Id = @Order_Id
		end
	end
end

If @Action = 'Read_Orders'
BEGIN
select 
	a.Id
	,a.Order_Id
	,a.Order_Number
	,a.Customer_Id
	,a.Shipping_Address
	,a.Shipping_Address_Country
	,a.Shipping_Address_Country_Code
	,a.Shipping_Address_City
	,a.Shipping_Address_Province
	,a.Shipping_Address_Province_Code
	,a.Shipping_Address_Zip
	,a.Shipping_Address_Latitude
	,a.Shipping_Address_Longitude
	,a.Shipping_Address_Phone
	,a.Billing_Address_Phone
	,convert(float, a.Order_Ammount) AS Order_Ammount
	,convert(varchar, a.Order_Updated_At) as Order_Updated_At
	,convert(varchar, a.Order_Created_At) as Order_Created_At
	,a.Fulfillment_Status
	,a.Financial_Status
	,a.Order_Status_Url
	,a.Billing_Address
	,convert(varchar, c.FechaVigenciaGuia) AS FechaVigenciaGuia
	,'*Tel(1):' +' ' + a.Shipping_Address_Phone + ' ' + '*Tel(2):' + ' ' + a.Billing_Address_Phone + ' ' + '*Email' + ' ' + a.Email AS Contacto
	,b.Estafeta_EstatusEntrega AS Estafeta_EstatusEntrega
	,c.Courier_Name 
	, (select top 1 ' ' + l.DescripcionServicio + ' ' + '||' + ' ' + 'Total:' + '$'+ convert(varchar, l.CostoTotal) + '-->' + '(tb $'+convert(varchar, l.TarifaBase)+')' +' ' + '(CCtb $'+convert(varchar, l.CCTarifaBase)+')' + ' ' + '(sp '+convert(varchar, l.SobrePeso)+' kg)' + ' ' + '(CCsp '+convert(varchar, l.CCSobrePeso)+')' from Shopify_Orders k
	left outer join Estafeta_Order l
	on k.Order_Id = l.Order_Id
	where l.Order_Id = a.Order_Id order by k.Order_Id) AS Description
	,c.Estafeta_Guia
	,case when g.Id is not null 
	then 
	'ID ' +ISNULL(convert(varchar, g.Id),'') + '||' + 'Name ' +ISNULL( g.Name,'') + '-> ' + 'p' + '('+ISNULL(convert(varchar, g.Peso),'') +' kg' +')' + ' ' + 'h'+'('+ISNULL(convert(varchar,g.Alto),'')+' cm' +')'+'l'+'('+ISNULL(convert(varchar,g.Largo),'')+' cm'+')'+'a'+'('+ISNULL(convert(varchar,g.Ancho),'')+' cm'+')' 
	end Paquete_Recomendado
	,case when h.Id is not null
	then 
	'ID ' +ISNULL(convert(varchar, h.Id),'') + '||' + 'Name ' +ISNULL( h.Name,'') + '-> ' + 'p' + '('+ISNULL(convert(varchar, h.Peso),'') +' kg' +')' + ' ' + 'h'+'('+ISNULL(convert(varchar,h.Alto),'')+' cm' +')'+'l'+'('+ISNULL(convert(varchar,h.Largo),'')+' cm'+')'+'a'+'('+ISNULL(convert(varchar,h.Ancho),'')+' cm'+')' 
	end Paquete_Seleccionado
	,sum(e.Product_Quantity) AS TotalUnidades
	,sum(i.Peso) AS Peso
	,ISNULL(f.First_Name, '') + ' ' + ISNULL(f.Last_Name, '') AS Customer_Name
	,c.Peso_Final_Paquete
	from Shopify_Orders a
	left outer join Estafeta_Guias b
	on a.Order_Id = b.Order_Id
	left outer join Estafeta_Order_Especificaciones c
	on a.Order_Id = c.Order_Id
	left outer join Estafeta_TiposServicio d
	on c.Estafeta_TiposServicio_Id = d.Id
	left outer join Shopify_Order_Products e
	on a.Order_Id = e.Order_Id
	left outer join Shopify_Customers f
	on a.Customer_Id = f.Customer_Id
	left outer join Maestro_Paquetes g
	on c.Maestro_Paquetes_Recommended_Id = g.Id
	left outer join Maestro_Paquetes h
	on c.Maestro_Paquetes_Id = h.Id
	left outer join Shopify_Products i
	on e.Product_Id = i.Product_Id

	where 1 = 1
		group by 
			a.Id
		,a.Order_Id
		,a.Order_Number
		,a.Customer_Id
		,a.Shipping_Address
		,a.Shipping_Address_Country
		,a.Shipping_Address_Country_Code
		,a.Shipping_Address_City
		,a.Shipping_Address_Province
		,a.Shipping_Address_Province_Code
		,a.Shipping_Address_Zip
		,a.Shipping_Address_Latitude
		,a.Shipping_Address_Longitude
		,a.Shipping_Address_Phone
		,a.Billing_Address_Phone
		,convert(float, a.Order_Ammount) 
		,convert(varchar, a.Order_Updated_At) 
		,convert(varchar, a.Order_Created_At)
		,a.Fulfillment_Status
		,a.Financial_Status
		,a.Order_Status_Url
		,a.Billing_Address
		,c.Estafeta_Guia
		,'*Tel(1):' +' ' + a.Shipping_Address_Phone + ' ' + '*Tel(2):' + ' ' + a.Billing_Address_Phone + ' ' + '*Email' + ' ' + a.Email 
		,b.Estafeta_EstatusEntrega
		,c.Courier_Name 
		,case when g.Id is not null then 
		'ID ' +ISNULL(convert(varchar, g.Id),'') + '||' + 'Name ' +ISNULL( g.Name,'') + '-> ' + 'p' + '('+ISNULL(convert(varchar, g.Peso),'') +' kg' +')' + ' ' + 'h'+'('+ISNULL(convert(varchar,g.Alto),'')+' cm' +')'+'l'+'('+ISNULL(convert(varchar,g.Largo),'')+' cm'+')'+'a'+'('+ISNULL(convert(varchar,g.Ancho),'')+' cm'+')'
		end  
		,case when h.Id is not null
		then 
		'ID ' +ISNULL(convert(varchar, h.Id),'') + '||' + 'Name ' +ISNULL( h.Name,'') + '-> ' + 'p' + '('+ISNULL(convert(varchar, h.Peso),'') +' kg' +')' + ' ' + 'h'+'('+ISNULL(convert(varchar,h.Alto),'')+' cm' +')'+'l'+'('+ISNULL(convert(varchar,h.Largo),'')+' cm'+')'+'a'+'('+ISNULL(convert(varchar,h.Ancho),'')+' cm'+')' 
		end
		,ISNULL(f.First_Name, '') + ' ' + ISNULL(f.Last_Name, '')
		,c.Peso_Final_Paquete
		,convert(varchar, c.FechaVigenciaGuia)
		order by a.Id desc
END

If @Action = 'Read_Orders_Id'
BEGIN
select 
	a.Id
	,a.Order_Id
	,a.Order_Number
	,a.Customer_Id
	,a.Shipping_Address
	,a.Shipping_Address_Country
	,a.Shipping_Address_Country_Code
	,a.Shipping_Address_City
	,a.Shipping_Address_Province
	,a.Shipping_Address_Province_Code
	,a.Shipping_Address_Zip
	,a.Shipping_Address_Latitude
	,a.Shipping_Address_Longitude
	,a.Shipping_Address_Phone
	,a.Billing_Address_Phone
	,convert(float, a.Order_Ammount) AS Order_Ammount
	,convert(varchar, a.Order_Updated_At) as Order_Updated_At
	,convert(varchar, a.Order_Created_At) as Order_Created_At
	,a.Fulfillment_Status
	,a.Financial_Status
	,a.Order_Status_Url
	,a.Billing_Address
	,convert(varchar, c.FechaVigenciaGuia) AS FechaVigenciaGuia
	,'*Tel(1):' +' ' + a.Shipping_Address_Phone + ' ' + '*Tel(2):' + ' ' + a.Billing_Address_Phone + ' ' + '*Email' + ' ' + a.Email AS Contacto
	,b.Estafeta_EstatusEntrega AS Estafeta_EstatusEntrega
	,c.Courier_Name 
	, (select top 1 ' ' + l.DescripcionServicio + ' ' + '||' + ' ' + 'Total:' + '$'+ convert(varchar, l.CostoTotal) + '-->' + '(tb $'+convert(varchar, l.TarifaBase)+')' +' ' + '(CCtb $'+convert(varchar, l.CCTarifaBase)+')' + ' ' + '(sp '+convert(varchar, l.SobrePeso)+' kg)' + ' ' + '(CCsp '+convert(varchar, l.CCSobrePeso)+')' from Shopify_Orders k
	left outer join Estafeta_Order l
	on k.Order_Id = l.Order_Id
	where l.Order_Id = a.Order_Id order by k.Order_Id) AS Description
	,c.Estafeta_Guia
	,case when g.Id is not null 
	then 
	'ID ' +ISNULL(convert(varchar, g.Id),'') + '||' + 'Name ' +ISNULL( g.Name,'') + '-> ' + 'p' + '('+ISNULL(convert(varchar, g.Peso),'') +' kg' +')' + ' ' + 'h'+'('+ISNULL(convert(varchar,g.Alto),'')+' cm' +')'+'l'+'('+ISNULL(convert(varchar,g.Largo),'')+' cm'+')'+'a'+'('+ISNULL(convert(varchar,g.Ancho),'')+' cm'+')' 
	end Paquete_Recomendado
	,case when h.Id is not null
	then 
	'ID ' +ISNULL(convert(varchar, h.Id),'') + '||' + 'Name ' +ISNULL( h.Name,'') + '-> ' + 'p' + '('+ISNULL(convert(varchar, h.Peso),'') +' kg' +')' + ' ' + 'h'+'('+ISNULL(convert(varchar,h.Alto),'')+' cm' +')'+'l'+'('+ISNULL(convert(varchar,h.Largo),'')+' cm'+')'+'a'+'('+ISNULL(convert(varchar,h.Ancho),'')+' cm'+')' 
	end Paquete_Seleccionado
	,sum(e.Product_Quantity) AS TotalUnidades
	,sum(i.Peso) AS Peso
	,ISNULL(f.First_Name, '') + ' ' + ISNULL(f.Last_Name, '') AS Customer_Name
	,c.Peso_Final_Paquete
	from Shopify_Orders a
	left outer join Estafeta_Guias b
	on a.Order_Id = b.Order_Id
	left outer join Estafeta_Order_Especificaciones c
	on a.Order_Id = c.Order_Id
	left outer join Estafeta_TiposServicio d
	on c.Estafeta_TiposServicio_Id = d.Id
	left outer join Shopify_Order_Products e
	on a.Order_Id = e.Order_Id
	left outer join Shopify_Customers f
	on a.Customer_Id = f.Customer_Id
	left outer join Maestro_Paquetes g
	on c.Maestro_Paquetes_Recommended_Id = g.Id
	left outer join Maestro_Paquetes h
	on c.Maestro_Paquetes_Id = h.Id
	left outer join Shopify_Products i
	on e.Product_Id = i.Product_Id

	where 1 = 1
		and a.Order_Id = @Order_Id
		group by 
			a.Id
		,a.Order_Id
		,a.Order_Number
		,a.Customer_Id
		,a.Shipping_Address
		,a.Shipping_Address_Country
		,a.Shipping_Address_Country_Code
		,a.Shipping_Address_City
		,a.Shipping_Address_Province
		,a.Shipping_Address_Province_Code
		,a.Shipping_Address_Zip
		,a.Shipping_Address_Latitude
		,a.Shipping_Address_Longitude
		,a.Shipping_Address_Phone
		,a.Billing_Address_Phone
		,convert(float, a.Order_Ammount) 
		,convert(varchar, a.Order_Updated_At) 
		,convert(varchar, a.Order_Created_At)
		,a.Fulfillment_Status
		,a.Financial_Status
		,a.Order_Status_Url
		,a.Billing_Address
		,c.Estafeta_Guia
		,'*Tel(1):' +' ' + a.Shipping_Address_Phone + ' ' + '*Tel(2):' + ' ' + a.Billing_Address_Phone + ' ' + '*Email' + ' ' + a.Email 
		,b.Estafeta_EstatusEntrega
		,c.Courier_Name 
		,case when g.Id is not null then 
		'ID ' +ISNULL(convert(varchar, g.Id),'') + '||' + 'Name ' +ISNULL( g.Name,'') + '-> ' + 'p' + '('+ISNULL(convert(varchar, g.Peso),'') +' kg' +')' + ' ' + 'h'+'('+ISNULL(convert(varchar,g.Alto),'')+' cm' +')'+'l'+'('+ISNULL(convert(varchar,g.Largo),'')+' cm'+')'+'a'+'('+ISNULL(convert(varchar,g.Ancho),'')+' cm'+')'
		end  
		,case when h.Id is not null
		then 
		'ID ' +ISNULL(convert(varchar, h.Id),'') + '||' + 'Name ' +ISNULL( h.Name,'') + '-> ' + 'p' + '('+ISNULL(convert(varchar, h.Peso),'') +' kg' +')' + ' ' + 'h'+'('+ISNULL(convert(varchar,h.Alto),'')+' cm' +')'+'l'+'('+ISNULL(convert(varchar,h.Largo),'')+' cm'+')'+'a'+'('+ISNULL(convert(varchar,h.Ancho),'')+' cm'+')' 
		end
		,ISNULL(f.First_Name, '') + ' ' + ISNULL(f.Last_Name, '')
		,c.Peso_Final_Paquete
		,convert(varchar, c.FechaVigenciaGuia)
		order by a.Id desc
END

IF @Action = 'GET_Product'
BEGIN
	select 
	c.Id
	,c.Name
	,c.SKU 
	,c.Barcode
	,c.Peso
	,c.Alto
	,c.Ancho
	,c.Largo
	,c.Price
	,c.price * convert(float, b.Product_Quantity) AS subtotal
	,CAST(b.Product_Quantity AS int) AS Product_Quantity
	from Shopify_Orders a
	left outer join Shopify_Order_Products b
	on a.Order_Id = b.Order_Id
	left outer join Shopify_Products c
	on b.Product_Id = c.Product_Id
	where 1 = 1 
		and a.Order_Id = @Order_Id
		order by a.Order_Number desc
END
--------------------------------------ConsoleApp_Shopify_UpdateInformation Begin------------------------
if @Action = 'Get_ImagenShopify'
begin
	select 
		a.Id
		,a.Product_id
		,a.Image_id
		,a.SRC
		,a.[Name]
	from Shopify_Products_Images a
	where 1 = 1
		and a.ServerPath is null
end
--------------------------------------ConsoleApp_Shopify_UpdateInformation End------------------------
