declare 
	@Accion int = 0
	,@Folio varchar(max) = ''
	,@Oracle int = 0

if @Accion = 0
begin

	select *
	from ControlDocumental_LI_Lote_Recepcion_Detalle a
		left outer join ControlDocumental_LI b
		on a.ControlDocumental_LI_Id = b.Id
	where 1 = 1
		and b.Folio = @Folio
		and b.Oracle = @Oracle

	select *
	from ControlDocumental_LI_Detalle_Scan a
		left outer join ControlDocumental_LI b
		on a.ControlDocumental_LI_Id = b.Id
	where 1 = 1
		and b.Folio = @Folio
		and b.Oracle = @Oracle

	select *
	from ControlDocumental_LI_Detalle a
		left outer join ControlDocumental_LI b
		on a.ControlDocumental_LI_Id = b.Id
	where 1 = 1
		and b.Folio = @Folio
		and b.Oracle = @Oracle

	select *
	from ControlDocumental_LI a
	where 1 = 1
		and a.Folio = @Folio
		and a.Oracle = @Oracle

end
if @Accion = 1
begin
	delete a
	from ControlDocumental_LI_Lote_Recepcion_Detalle a
		left outer join ControlDocumental_LI b
		on a.ControlDocumental_LI_Id = b.Id
	where 1 = 1
		and b.Folio in ('6779', '940')

	
	delete a
	from ControlDocumental_LI_Detalle_Scan a
		left outer join ControlDocumental_LI b
		on a.ControlDocumental_LI_Id = b.Id
	where 1 = 1
		and b.Folio in ('6779', '940')


	delete a
	from ControlDocumental_LI_Detalle a

		left outer join ControlDocumental_LI b
		on a.ControlDocumental_LI_Id = b.Id

	where 1 = 1
		and b.Folio in ('6779', '940')


	delete a
	from ControlDocumental_LI a
	where 1 = 1
		and Folio in ('6779', '940')

end
	