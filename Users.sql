---Correr en servidor de apps
use [Global]
declare 
	@Nombre varchar(max) = 'gustavo' --Nombre del usuario 
			  ,@VERIFICAR INT = 1 --1 verificas, 2 desbloqueas
		,@Accion varchar(max)= 'f' --F:Logistica Directa --D:Logistica Inversa
if @VERIFICAR = 1
begin
	select * from Control_Entregas_Usuarios
	where 1 = 1
		and Nombre like '%'+ @Nombre +'%'
		and Usuario like '%'+ @Nombre +'%'  --Si no te dan el nombre y te dan Usuario 

end

if @VERIFICAR = 2
begin
	if @Accion = 'F'
	begin
		update Control_Entregas_Usuarios
		set SessionOpen = 'False'
		where 1 = 1
			and Nombre like '%'+ @Nombre +'%'
			and Usuario like '%'+ @Nombre +'%'
		and Tipo_Documento = 'Control Documental Facturas' --Logistica Directa
		--and Tipo_Documento = 'Control Documental Devoluciones'  --Logistica Inversa
	end

	if @Accion = 'D'
	begin
		update Control_Entregas_Usuarios
		set SessionOpen = 'False'
		where 1 = 1
			and Nombre like '%'+ @Nombre +'%'
			--and Usuario like '%'+ @Nombre +'%'
		and Tipo_Documento = 'Control Documental Devoluciones'  --Logistica Inversa
	end
	select * from Control_Entregas_Usuarios
	where 1 = 1
		and Nombre like '%'+ @Nombre +'%'
end

--Carga de Información de Devoluciones
--Este query sólo se ejecuta desde el server de apps

  