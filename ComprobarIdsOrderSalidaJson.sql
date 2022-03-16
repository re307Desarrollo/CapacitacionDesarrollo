declare
	--GeneracionGuiaEstafeta API
	--Origen
	@GenerarGuia_origenAddress1 varchar(max)= 'Calz. Lucio Blanco'
	,@GenerarGuia_origenAddress2 varchar(max)= 'E:435'
	,@GenerarGuia_origenCity varchar(max)= 'Azcapotzalco'
	,@GenerarGuia_origenContactName varchar(max)= 'Aaron Bolaños'
	,@GenerarGuia_origenCorporateName varchar(max)= 'FUS'
	,@GenerarGuia_origenCustomerNumber1 varchar(max)= '0000000'
	,@GenerarGuia_origenNeighborhood varchar(max)= 'San Juan Tlihuaca'
	,@GenerarGuia_origenPhoneNumber varchar(max)= null
	,@GenerarGuia_origenCellPhoneNumber varchar(max)= null
	,@GenerarGuia_origenState varchar(max)= 'Ciudad de México (DF)'
	,@GenerarGuia_origineCountry varchar(max) = 'MEX'
	,@GenerarGuia_zipOrigen varchar(max)= '02400'
	,@GenerarGuia_originExternalNumber varchar(max)= '1003'
	,@GenerarGuia_origintaxPayerCode varchar(max) ='DIN8705087D7'
	,@GenerarGuia_destinationtaxPayerCode varchar(max) ='XAXX010101000'
	,@Order_Id varchar(max) = '4694188556532'
	,@JsonMercancia varchar(max) = null
	,@JSON varchar(max) = null

select 
	a.Order_Id
	,(
		select c.Clave from [Global].dbo.CartaPorte_UnidadPeso c
		where 1 = 1
			and c.Id = 213
	) weightUnitCode
	,b.Grams
	into #Shopify_Order_Products_A
from Shopify_Order_Products a
	left outer join Shopify_Products b
	on a.Product_Id = b.Product_Id
where 1 = 1
	and a.Order_Id = @Order_Id

select 
	a.Order_Id
	,a.weightUnitCode
	,(SUM(a.Grams)/1000) totalGrossWeight
	into #merchandises
from #Shopify_Order_Products_A a
where 1 = 1
	and a.Order_Id = @Order_Id
group by 
	a.Order_Id
	,a.weightUnitCode


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
	and a.Order_Id = @Order_Id
FOR JSON PATH)

set @JsonMercancia = SUBSTRING(@JsonMercancia,CHARINDEX(':{',@JsonMercancia,0)+1,(LEN(@JsonMercancia)-CHARINDEX(':{',@JsonMercancia,0))-2)

select @JsonMercancia jsonmercacias

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
	,isnull(CAST(b.Peso_Final_Paquete as decimal(18,2)),0)as [labelDefinition.itemDescription.weight]
	,ISNULL(CONVERT(int,f.Alto),0) as [labelDefinition.itemDescription.height]
	,ISNULL(CONVERT(int,f.Largo),0) as [labelDefinition.itemDescription.length]
	,ISNULL(CONVERT(int,f.Ancho),0) as [labelDefinition.itemDescription.width]
	,'constructor' as [labelDefinition.itemDescription.merchandises]
	,ISNULL(REPLACE(CONVERT(varchar,b.FechaVigenciaGuia),'-',''),'20211201') as[labelDefinition.serviceConfiguration.effectiveDate]
	,'Shipment contents' as[labelDefinition.serviceConfiguration.insurance.contentDescription]
	,CAST(a.Order_Ammount as decimal(18,2)) as[labelDefinition.serviceConfiguration.insurance.declaredValue]
	,CONVERT(bit,1) as[labelDefinition.serviceConfiguration.isInsurance]
	,CONVERT(bit,0) as[labelDefinition.serviceConfiguration.isReturnDocument]
	,1 as[labelDefinition.serviceConfiguration.quantityOfLabels]
	,ISNULL(OrigenDestino.Origen_CodigoPosOri,'02400') as[labelDefinition.serviceConfiguration.originZipCodeForRouting]
	,'112' as[labelDefinition.serviceConfiguration.salesOrganization]
	,ISNULL(e.TipoServicio_Clave,'70') as[labelDefinition.serviceConfiguration.serviceTypeId]
	,CONVERT(bit,0) as[labelDefinition.location.origin.address.bUsedCode]
	--countryName
	,@GenerarGuia_origineCountry as[labelDefinition.location.origin.address.countryName]
	--roadTypeAbbName
	,'Calzada' as[labelDefinition.location.origin.address.roadTypeAbbName]
	--settlementTypeAbbName
	,'Col' as[labelDefinition.location.origin.address.settlementTypeAbbName]
	--,'Frente Cementerio' as[labelDefinition.location.origin.address.addressReference]
	--,'Calz. Renacimiento' as[labelDefinition.location.origin.address.betweenRoadName1]
	--,'Manuel Salazar' as[labelDefinition.location.origin.address.betweenRoadName2]
	--,'484' as[labelDefinition.location.origin.address.countryCode]
	,@GenerarGuia_originExternalNumber as[labelDefinition.location.origin.address.externalNum]
	--,'A' as[labelDefinition.location.origin.address.indoorInformation]
	--,'-99.12' as[labelDefinition.location.origin.address.latitude]
	--,'19.48' as[labelDefinition.location.origin.address.longitude]
	--,'NA999' as[labelDefinition.location.origin.address.nave]
	--,'P199' as[labelDefinition.location.origin.address.platform]
	,@GenerarGuia_origenAddress1 as[labelDefinition.location.origin.address.roadName]
	--,'001' as[labelDefinition.location.origin.address.roadTypeCode]
	,@GenerarGuia_origenNeighborhood as[labelDefinition.location.origin.address.settlementName]
	--,'001' as[labelDefinition.location.origin.address.settlementTypeCode]
	--,'02' as[labelDefinition.location.origin.address.stateCode]
	--,'08-019' as[labelDefinition.location.origin.address.townshipCode]
	,@GenerarGuia_zipOrigen as[labelDefinition.location.origin.address.zipCode]
	,'5555555544' as[labelDefinition.location.origin.contact.cellPhone]
	,@GenerarGuia_origenContactName as[labelDefinition.location.origin.contact.contactName]
	,@GenerarGuia_origenCorporateName as[labelDefinition.location.origin.contact.corporateName]
	,'na@na.na' as[labelDefinition.location.origin.contact.email]
	,'NA' as[labelDefinition.location.origin.contact.phoneExt]
	,'NA' as[labelDefinition.location.origin.contact.telephone]
	,@GenerarGuia_origintaxPayerCode as[labelDefinition.location.origin.contact.taxPayerCode]
	,CONVERT(bit,0) as[labelDefinition.location.isDRAAlternative]
	,'null' as[labelDefinition.location.destination.deliveryPUDOCode]
	,CONVERT(bit,0) as[labelDefinition.location.destination.homeAddress.address.bUsedCode]
	--countryName
	,@GenerarGuia_origineCountry as[labelDefinition.location.destination.homeAddress.address.countryName]
	--roadTypeAbbName
	,'Calle' as[labelDefinition.location.destination.homeAddress.address.roadTypeAbbName]
	--settlementTypeAbbName
	,'Col' as[labelDefinition.location.destination.homeAddress.address.settlementTypeAbbName]
	,'NA' as[labelDefinition.location.destination.homeAddress.address.addressReference]
	--,'La Morelos' as[labelDefinition.location.destination.homeAddress.address.betweenRoadName1]
	--,'Los Estrada' as[labelDefinition.location.destination.homeAddress.address.betweenRoadName2]
	--,'484' as[labelDefinition.location.destination.homeAddress.address.countryCode]
	,'NA' as[labelDefinition.location.destination.homeAddress.address.externalNum]
	--,'A' as[labelDefinition.location.destination.homeAddress.address.indoorInformation]
	,a.Billing_Address_Longitude as[labelDefinition.location.destination.homeAddress.address.latitude]
	,a.Billing_Address_Latitude as[labelDefinition.location.destination.homeAddress.address.longitude]
	--,'NA999' as[labelDefinition.location.destination.homeAddress.address.nave]
	--,'P199' as[labelDefinition.location.destination.homeAddress.address.platform]
	--,a.Billing_Address as[labelDefinition.location.destination.homeAddress.address.roadName]
	,(case
		when LEN(a.Billing_Address) > 50 then SUBSTRING(a.Billing_Address,0,49)
		else a.Billing_Address 
	end
	)as[labelDefinition.location.destination.homeAddress.address.roadName]
	--,'001' as[labelDefinition.location.destination.homeAddress.address.roadTypeCode]
	,ISNULL(b.Colonia_Envio,'NA') as[labelDefinition.location.destination.homeAddress.address.settlementName]
	--,'001' as[labelDefinition.location.destination.homeAddress.address.settlementTypeCode]
	--,'02' as[labelDefinition.location.destination.homeAddress.address.stateCode]
	--,'08-019' as[labelDefinition.location.destination.homeAddress.address.townshipCode]
	,a.Billing_Address_Zip as[labelDefinition.location.destination.homeAddress.address.zipCode]
	,ISNULL(a.Shipping_Address_Phone,'NA') as[labelDefinition.location.destination.homeAddress.contact.cellPhone]
	,a.Shipping_Address_First_Name+' '+a.Shipping_Address_Last_Name as[labelDefinition.location.destination.homeAddress.contact.contactName]
	,a.Shipping_Address_First_Name+' '+a.Shipping_Address_Last_Name as[labelDefinition.location.destination.homeAddress.contact.corporateName]
	,ISNULL(a.Email,'na@na.na') as[labelDefinition.location.destination.homeAddress.contact.email]
	,'null' as[labelDefinition.location.destination.homeAddress.contact.phoneExt]
	,ISNULL(a.Billing_Address_Phone,'NA') as[labelDefinition.location.destination.homeAddress.contact.telephone]
	,@GenerarGuia_destinationtaxPayerCode as[labelDefinition.location.destination.homeAddress.contact.taxPayerCode]
	,CONVERT(bit,0) as[labelDefinition.location.destination.isDeliveryToPUDO]
from Shopify_Orders a
	left outer join Estafeta_Order_Especificaciones b
	on a.Order_Id = b.Order_Id
	left outer join Estafeta_TiposServicio e
	on b.Estafeta_TiposServicio_Id = e.Id
	left outer join Maestro_Paquetes f
	on b.Maestro_Paquetes_Id = f.Id
	left outer join Estafeta_Order_OrigenDestino OrigenDestino
	on a.Order_Id = OrigenDestino.Order_Id
where 1 = 1
	and b.Estafeta_Guia is null
	and a.Order_Id = @Order_Id
FOR JSON PATH
)

select REPLACE(REPLACE(REPLACE(REPLACE(@Json,'"null"','null'),'[',''),']',''),'"constructor"',@JsonMercancia)  JsonResult

drop table #merchandises,#Shopify_Order_Products_A