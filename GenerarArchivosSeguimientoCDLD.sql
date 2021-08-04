declare
	@FechaSubida date = DATEADD(dd,-1,GETDATE())--solo diminuir el -1, para los fines de semana que seria hasta -3
	,@Fecha varchar(max) = null
	,@Valida int = 0
	,@DocumentoDuplicado int = 0

set @Fecha = convert(varchar,@FechaSubida)
select @Fecha FechaValidar

if @Valida = 1
	execute GeneradorArchivo_SeguimientoControlDocumental_LD @fecha = @Fecha

if @DocumentoDuplicado = 1
	execute GeneradorArchivo_SeguimientoControlDocumental_LD_Documento_con_LineasDobles @fecha = @Fecha

--https://1drv.ms/u/s!AiuElLQ5TpfEhfQryWHURoPziWPjVg?e=5bhL0r //subir los archivos a esta liga de onedriver, perdir acceso a Gio.
