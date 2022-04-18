use [Ecommerce_TuShoppi]
select 
	a.Order_Id
	,a.Order_Number
	,a.Billing_Address_Zip 
	,a.Shipping_Address_Zip 
	,b.Estafeta_Guia
from Shopify_Orders a
	left outer join Estafeta_Order_Especificaciones b
	on a.Order_Id = b.Order_Id
where 1 = 1
 and a.Order_Number in (18904,18949)

 return

 update a
	set
		a.Shipping_Address_Zip = '32695'
 from Shopify_Orders a
where 1 = 1
 and a.Order_Number = 18949 