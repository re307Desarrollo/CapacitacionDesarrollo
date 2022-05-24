
--Insert into Z_DV_Pendientes_Walmart
select 
	*
from Z_DV_Pendientes_Walmart_DescargaIncompleta a
where 1 = 1
	and not exists(select * from Z_DV_Pendientes_Walmart b
					where 1 = 1
						and a.Tienda = b.Tienda
						and a.Folio = b.Folio
						and a.DET_UPC = b.DET_UPC)
	and a.Tienda is not null
	and a.Folio is not null
	and a.DET_UPC is not null

Insert into Z_DV_Pendientes_Walmart
select top 1
	a.CIA
	,a.IdMov
	,a.Tienda
	,a.Depto
	,a.Folio
	,a.Factura
	,a.FechaPago
	,a.FechaPago
	,a.Importe
	,'' Estatus
	,a.OrdenCompra
	,a.IVA
	,null
	,a.IVABebidaEnerg
	,a.IVABebidaM20G
	,a.IVACerveza
	,a.IVABebidaH20G
	,a.IVACalorifico
	,a.IVAVinos
	,a.IVACoolers
	,a.IVAPlaguisida6
	,a.IVAPlaguisida7
	,a.IVAPlaguisida9
	,a.IDFactura
	,a.UUID
	,a.Base
	,a.DET_IDFactura
	,a.DET_Folio
	,a.DET_IDMov
	,a.DET_Tienda
	,a.DET_OrdenCompra
	,a.DET_UPC
	,a.DET_Desc
	,a.DET_Cantidad
	,a.DET_Costo
	,a.[DET_IVA%]
	,a.[DET_IVA]
	,a.[DET_IEPS%]
	,a.[DET_IEPS]
	,a.DET_Subtotal
	,a.DET_ImporteTotal
	,a.COD_P
	,a.FechaSubida
from Z_DV_Pagadas_Walmart a
where 1 = 1
	and not exists(select * from Z_DV_Pendientes_Walmart b
					where 1 = 1
						and a.Tienda = b.Tienda
						and a.Folio = b.Folio
						and a.DET_UPC = b.DET_UPC)
	and a.Tienda is not null
	and a.Folio is not null
	and a.DET_UPC is not null

Insert into Z_DV_Pendientes_Walmart
select top 1
	a.CIA
	,a.IdMov
	,a.Tienda
	,a.Depto
	,a.Folio
	,a.Factura
	,a.FechaPago
	,a.FechaPago
	,a.Importe
	,'' Estatus
	,a.OrdenCompra
	,a.IVA
	,null
	,a.IVABebidaEnerg
	,a.IVABebidaM20G
	,a.IVACerveza
	,a.IVABebidaH20G
	,a.IVACalorifico
	,a.IVAVinos
	,a.IVACoolers
	,a.IVAPlaguisida6
	,a.IVAPlaguisida7
	,a.IVAPlaguisida9
	,a.IDFactura
	,a.UUID
	,a.Base
	,a.DET_IDFactura
	,a.DET_Folio
	,a.DET_IDMov
	,a.DET_Tienda
	,a.DET_OrdenCompra
	,a.DET_UPC
	,a.DET_Desc
	,a.DET_Cantidad
	,a.DET_Costo
	,a.[DET_IVA%]
	,a.[DET_IVA]
	,a.[DET_IEPS%]
	,a.[DET_IEPS]
	,a.DET_Subtotal
	,a.DET_ImporteTotal
	,a.COD_P
	,a.FechaSubida
from Z_DV_Pagadas_Walmart_DescargaIncompleta a
where 1 = 1
	and not exists(select * from Z_DV_Pendientes_Walmart b
					where 1 = 1
						and a.Tienda = b.Tienda
						and a.Folio = b.Folio
						and a.DET_UPC = b.DET_UPC)
	and a.Tienda is not null
	and a.Folio is not null
	and a.DET_UPC is not null

return