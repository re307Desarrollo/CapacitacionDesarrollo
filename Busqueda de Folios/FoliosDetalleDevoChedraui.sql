select b.Sucursal ,a.*, c.* from ControlDocumental_LI a
	left outer join E_Carta_de_Rutas b
	on a.Oracle = b.No_Cliente
	left outer join ControlDocumental_LI_Detalle c
	on a.Id = c.ControlDocumental_LI_Id
where 1 = 1
	and a.Folio like '%6804060126%'