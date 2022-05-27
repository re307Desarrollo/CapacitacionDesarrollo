declare
	@Accion int = 0
	,@Id int = 34

if @Accion = 0
begin
	select * from ControlDocumental_LoteEnvio_Detalle a
	where 1 = 1
		and a.ControlDocumental_LoteEnvio_Id = @Id
end
if @Accion = 1
begin
	delete a
	from ControlDocumental_LoteEnvio_Detalle a
	where 1 = 1
		and a.ControlDocumental_LoteEnvio_Id = @Id
end