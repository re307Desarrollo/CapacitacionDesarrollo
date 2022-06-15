declare 
	@FileName varchar(max) = '20'
	,@Valida int = 1
	,@SubeInformacion int = 0


if @Valida = 1
	execute ValidarFoliosDevolucion_Chedraui @FileName

if @SubeInformacion = 1
	execute Subir_Z_DV_Chedraui_Sucursal @FileName
 
