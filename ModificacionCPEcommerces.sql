select 
	a.Order_Id
	,a.Order_Number
	,a.Billing_Address_Zip 
	,b.Estafeta_Guia
from Shopify_Orders a
	left outer join Estafeta_Order_Especificaciones b
	on a.Order_Id = b.Order_Id
where 1 = 1
 and a.Order_Number in (17975,17890,17920,17892)

 return

 update a
	set
		a.Billing_Address_Zip = 32576
 from Shopify_Orders a
where 1 = 1
 and a.Order_Number = 17975