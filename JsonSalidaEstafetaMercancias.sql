
select 
	a.Order_Id
	,(
		select c.Clave from [Global].dbo.CartaPorte_UnidadPeso c
		where 1 = 1
			and c.Id = 213
	) weightUnitCode
	,b.Grams
	into #Shopify_Order_Products
from Shopify_Order_Products a
	left outer join Shopify_Products b
	on a.Product_Id = b.Product_Id
where 1 = 1
	and a.Order_Id = '4659149570292'

select 
	a.Order_Id
	,a.weightUnitCode
	,(SUM(a.Grams)/1000) totalGrossWeight
	into #merchandises
from #Shopify_Order_Products a
where 1 = 1
	and a.Order_Id = '4659149570292'
group by 
	a.Order_Id
	,a.weightUnitCode

declare 
	@JsonMercancia varchar(max) = null

set @JsonMercancia =(

select 
	CAST(a.totalGrossWeight as decimal(18,2)) as [merchandises.totalGrossWeight]
	,a.weightUnitCode as [merchandises.weightUnitCode]
	,(
		select 
			CAST(c.[Price] as decimal(18,2)) as [merchandiseValue]
			,'MXN' as [currency]
			,(select e.Clave_producto from [Global].dbo.CartaPorte_ClaveProdServCP e
			 where 1 = 1 and e.Id = 8633) as [productServiceCode]
			,CAST(b.Product_Quantity as decimal(18,6)) as [merchandiseQuantity]
			,(select e.c_ClaveUnidad from [Global].dbo.CartaPorte_ClaveUnidad e
			 where 1 = 1 and e.Id = 798) as [measurementUnitCode]
			,CONVERT(bit,0) as [isInternational]
			,CONVERT(bit,0) as [isImport]
			,CONVERT(bit,0) as [isHazardousMaterial]
			,(select e.Clave from [Global].dbo.CartaPorte_TipoEmbalaje e
			 where 1 = 1 and e.Id = 23) as [packagingCode]
		from Shopify_Order_Products b
			left outer join Shopify_Products c
			on b.Product_Id = c.Product_Id
		where 1 = 1
			and b.Order_Id = a.Order_Id
		FOR JSON PATH
	)as [merchandises.merchandise]
from #merchandises a
where 1 = 1
	and a.Order_Id = '4659149570292'
FOR JSON PATH)


set @JsonMercancia = SUBSTRING(@JsonMercancia,CHARINDEX(':{',@JsonMercancia,0)+1,(LEN(@JsonMercancia)-CHARINDEX(':{',@JsonMercancia,0))-2)

select @JsonMercancia
-- drop table #merchandises
-- drop table #Shopify_Order_Products

select LEN('[{"merchandises":{"totalGrossWeight":0.20,"weightUnitCode":"XPK","merchandise":[{"merchandiseValue":309.90,"currency":"MXN","productServiceCode":"31181701","merchandiseQuantity":1.000000,"measurementUnitCode":"F63","isInternational":false,"isImport":false,"isHazardousMaterial":false,"packagingCode":"4G"},{"merchandiseValue":309.90,"currency":"MXN","productServiceCode":"31181701","merchandiseQuantity":1.000000,"measurementUnitCode":"F63","isInternational":false,"isImport":false,"isHazardousMaterial":false,"packagingCode":"4G"}]}}]')