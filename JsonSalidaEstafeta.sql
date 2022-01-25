select top 1 
	[itemDescription].Order_Id as [itemDescription.parcelId]
	,isnull(b.Peso ,0)as [itemDescription.weight]
	,ISNULL(b.Alto,0) as [itemDescription.height]
	,ISNULL(b.Largo,0) as [itemDescription.length]
	,ISNULL(b.Ancho,0) as [itemDescription.width]
	,121.1 as [itemDescription.merchandises.totalGrossWeight]
	,'XLU' as[itemDescription.merchandises.weightUnitCode]
	,product.Price as[itemDescription.merchandises.merchandise.merchandiseValue]
	,'MXN' as[itemDescription.merchandises.merchandise.currency]
	,'10131508' as[itemDescription.merchandises.merchandise.productServiceCode]
	,c.Product_Quantity as[itemDescription.merchandises.merchandise.merchandiseQuantity]
	,'F63' as[itemDescription.merchandises.merchandise.measurementUnitCode]
from Shopify_Orders [itemDescription]
	left outer join Estafeta_Order_Especificaciones b
	on [itemDescription].Order_Id = b.Order_Id
	left outer join Shopify_Order_Products c
	on [itemDescription].Order_Id = c.Order_Id
	left outer join Shopify_Products product
	on c.Product_Id = product.Product_Id
where 1 = 1
	and b.Estafeta_Guia is null
	and itemDescription.Order_Id = '4649319399668'
FOR JSON PATH