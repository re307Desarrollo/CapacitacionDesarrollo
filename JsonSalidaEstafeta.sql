declare 
	@Json varchar(max) = null
	,@NULL varchar(max) = null


set @Json = (

select top 1
	'01' as [identification.suscriberId]
	,'0000000' as [identification.customerNumber]
	,'AP01' as [systemInformation.id]
	,'AP01' as [systemInformation.name]
	,'1.10.20' as [systemInformation.version]
	,'COLLECCION' as [labelDefinition.wayBillDocument.aditionalInfo]
	,'Documents' as [labelDefinition.wayBillDocument.content]
	,'SPMXA12345' as [labelDefinition.wayBillDocument.costCenter]
	,'null' as [labelDefinition.wayBillDocument.customerShipmentId]
	,'null' as [labelDefinition.wayBillDocument.groupShipmentId]
	,'PRUEBASESTAFETALABELQA' as [labelDefinition.wayBillDocument.referenceNumber]
	,4 as [labelDefinition.itemDescription.parcelId]
	,isnull(CAST(b.Peso as decimal(18,2)),0)as [labelDefinition.itemDescription.weight]
	,ISNULL(CONVERT(int,CEILING(b.Alto)),0) as [labelDefinition.itemDescription.height]
	,ISNULL(CONVERT(int,CEILING(b.Largo)),0) as [labelDefinition.itemDescription.length]
	,ISNULL(CONVERT(int,CEILING(b.Ancho)),0) as [labelDefinition.itemDescription.width]
	,ISNULL(CONVERT(varchar,b.FechaVigenciaGuia),'20211201') as[labelDefinition.serviceConfiguration.effectiveDate]
	,'Shipment contents' as[labelDefinition.serviceConfiguration.insurance.contentDescription]
	,CAST(a.Order_Ammount as decimal(18,2)) as[labelDefinition.serviceConfiguration.insurance.declaredValue]--
	,CONVERT(bit,1) as[labelDefinition.serviceConfiguration.isInsurance]
	,CONVERT(bit,0) as[labelDefinition.serviceConfiguration.isReturnDocument]
	,1 as[labelDefinition.serviceConfiguration.quantityOfLabels]
	,ISNULL(OrigenDestino.Origen_CodigoPosOri,'NoAsig') as[labelDefinition.serviceConfiguration.originZipCodeForRouting]
	,'112' as[labelDefinition.serviceConfiguration.salesOrganization]
	,'70' as[labelDefinition.serviceConfiguration.serviceTypeId]
	,'null' as[labelDefinition.location.destination.deliveryPUDOCode]
	,CONVERT(bit,1) as[labelDefinition.location.destination.homeAddress.address.bUsedCode]
	,'Frente Cementerio' as[labelDefinition.location.destination.homeAddress.address.addressReference]
	,'La Morelos' as[labelDefinition.location.destination.homeAddress.address.betweenRoadName1]
	,'Los Estrada' as[labelDefinition.location.destination.homeAddress.address.betweenRoadName2]
	,'484' as[labelDefinition.location.destination.homeAddress.address.countryCode]
	,'1003' as[labelDefinition.location.destination.homeAddress.address.externalNum]
	,'A' as[labelDefinition.location.destination.homeAddress.address.indoorInformation]
	,'-99.12' as[labelDefinition.location.destination.homeAddress.address.latitude]
	,'19.48' as[labelDefinition.location.destination.homeAddress.address.longitude]
	,'NA999' as[labelDefinition.location.destination.homeAddress.address.nave]
	,'P199' as[labelDefinition.location.destination.homeAddress.address.platform]
	,'Lucio Blanco' as[labelDefinition.location.destination.homeAddress.address.roadName]
	,'001' as[labelDefinition.location.destination.homeAddress.address.roadTypeCode]
	,'Julio Medrano' as[labelDefinition.location.destination.homeAddress.address.settlementName]
	,'001' as[labelDefinition.location.destination.homeAddress.address.settlementTypeCode]
	,'02' as[labelDefinition.location.destination.homeAddress.address.stateCode]
	,'08-019' as[labelDefinition.location.destination.homeAddress.address.townshipCode]
	,OrigenDestino.Destino_CpDestino as[labelDefinition.location.destination.homeAddress.address.zipCode]
	,'7771798529' as[labelDefinition.location.destination.homeAddress.contact.cellPhone]
	,a.Shipping_Address_First_Name+' '+a.Shipping_Address_Last_Name as[labelDefinition.location.destination.homeAddress.contact.contactName]
	,a.Shipping_Address_First_Name+' '+a.Shipping_Address_Last_Name as[labelDefinition.location.destination.homeAddress.contact.corporateName]
	,'ericka.godezg@mailito.com' as[labelDefinition.location.destination.homeAddress.contact.email]
	,'null' as[labelDefinition.location.destination.homeAddress.contact.phoneExt]
	,'7771011300' as[labelDefinition.location.destination.homeAddress.contact.telephone]
	,CONVERT(bit,0) as[labelDefinition.location.destination.isDeliveryToPUDO]
	,CONVERT(bit,0) as[labelDefinition.location.isDRAAlternative]
	,CONVERT(bit,1) as[labelDefinition.location.origin.address.bUsedCode]
	,'Frente Cementerio' as[labelDefinition.location.origin.address.addressReference]
	,'La Morelos' as[labelDefinition.location.origin.address.betweenRoadName1]
	,'Los Estrada' as[labelDefinition.location.origin.address.betweenRoadName2]
	,'484' as[labelDefinition.location.origin.address.countryCode]
	,'1003' as[labelDefinition.location.origin.address.externalNum]
	,'A' as[labelDefinition.location.origin.address.indoorInformation]
	,'-99.12' as[labelDefinition.location.origin.address.latitude]
	,'19.48' as[labelDefinition.location.origin.address.longitude]
	,'NA999' as[labelDefinition.location.origin.address.nave]
	,'P199' as[labelDefinition.location.origin.address.platform]
	,'Lucio Blanco' as[labelDefinition.location.origin.address.roadName]
	,'001' as[labelDefinition.location.origin.address.roadTypeCode]
	,'Julio Medrano' as[labelDefinition.location.origin.address.settlementName]
	,'001' as[labelDefinition.location.origin.address.settlementTypeCode]
	,'02' as[labelDefinition.location.origin.address.stateCode]
	,'08-019' as[labelDefinition.location.origin.address.townshipCode]
	,OrigenDestino.Origen_CodigoPosOri as[labelDefinition.location.origin.address.zipCode]
	,'5555555544' as[labelDefinition.location.origin.contact.cellPhone]
	,'Julio Medrano' as[labelDefinition.location.origin.contact.contactName]
	,'Distribuidora Intermex, S.A. de C.V.' as[labelDefinition.location.origin.contact.corporateName]
	,'jmedranop@mailito.com' as[labelDefinition.location.origin.contact.email]
	,'2013' as[labelDefinition.location.origin.contact.phoneExt]
	,'5555555555' as[labelDefinition.location.origin.contact.telephone]
from Shopify_Orders a
	left outer join Estafeta_Order_Especificaciones b
	on a.Order_Id = b.Order_Id
	left outer join Shopify_Order_Products c
	on a.Order_Id = c.Order_Id
	left outer join Shopify_Products product
	on c.Product_Id = product.Product_Id
	left outer join Estafeta_Order_OrigenDestino OrigenDestino
	on a.Order_Id = OrigenDestino.Order_Id
where 1 = 1
	and b.Estafeta_Guia is null
	and a.Order_Id = '3020973899926'
FOR JSON PATH
)

select REPLACE(REPLACE(REPLACE(@Json,'"null"','null'),'[',''),']','')  JsonResult