declare
	@Archivo varchar(max)=  '6'
	,@Accion varchar(max)= '1'


if @Accion = '1'
	execute ValidarFoliosDevolucion_Chedraui @Archivo
if @Accion = '2'
	execute Subir_Z_DV_Chedraui_Sucursal @Archivo