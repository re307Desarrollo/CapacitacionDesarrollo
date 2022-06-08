select a.* from ControlDocumental_LI a
	right outer join E_Carta_de_Rutas b
	on a.Oracle  = b.No_Cliente
where 1 = 1
	and a.Unidades is null
	and a.Importe is null
	and a.IsTransactionClosed = 0
	and a.Sucursal = b.Codigo_Sucursal
