/*
select * from AspNetUsers
where 1 = 1
	and Nombres like '%jovan%'

select * from AspNetUsers
where 1 = 1
	and Nombres like '%nora%'

*/

declare 
	 @de varchar(max) = 'af6897fd-2e4a-4511-bf37-c06b2f472988'
	,@a varchar(max) = 'af6897fd-2e4a-4511-bf37-c06b2f472988'
	
	,@Consulta int = 1
	,@Migrar int = 0

if @Consulta = 1
begin
	select * from Facturacion_Solicitud
	where 1 = 1
		and UserId = @de

	select * from Facturacion_Solicitud
	where 1 = 1
		and UserId_Facturacion_Estatus = @de

	select * from Facturacion_Solicitud
	where 1 = 1
		and isCxCResponsable_UserId = @de

	select * from Facturacion_Solicitud
	where 1 = 1
		and isInfoIncomplete_UserId = @de

	select * from Facturacion_Estatus_Log
	where 1 = 1
		and UserId_Facturacion_Estatus = @de

	select * from Facturacion_Estatus_Log
	where 1 = 1
		and isIssue_UserId = @de	
	
	select * from Facturacion_Solicitud_TrackingIssue_Log
	where 1 = 1
		and isIssue_UserId = @de

	select * from Facturacion_Solicitud_TrackingIssue_Forum
	where 1 = 1
		and Message_Posted_UserId = @de

	select * from Facturacion_Solicitud_InfoIncomplete_Log
	where 1 = 1
		and isInfoIncomplete_UserId = @de

	select * from Facturacion_Solicitud_Evidencia
	where 1 = 1
		and UserId_Upload = @de
end

if @Migrar = 1
begin
	update a 
		set UserId = @a
	from Facturacion_Solicitud a
	where 1 = 1
		and UserId = @de

	update a 
		set UserId_Facturacion_Estatus = @a
	from Facturacion_Solicitud a
	where 1 = 1
		and UserId_Facturacion_Estatus = @de

	update a
		set isCxCResponsable_UserId = @a
	from Facturacion_Solicitud a
	where 1 = 1
		and isCxCResponsable_UserId = @de

	update a
		set isInfoIncomplete_UserId = @a
	from Facturacion_Solicitud a
	where 1 = 1
		and isInfoIncomplete_UserId = @de

	update a 
		set UserId_Facturacion_Estatus = @a
	from Facturacion_Estatus_Log a
	where 1 = 1
		and UserId_Facturacion_Estatus = @de

	update a 
		set isIssue_UserId = @a
	from Facturacion_Estatus_Log a
	where 1 = 1
		and isIssue_UserId = @de	
	
	update a 
		set isIssue_UserId = @a
	from Facturacion_Solicitud_TrackingIssue_Log a
	where 1 = 1
		and isIssue_UserId = @de

	update a 
		set Message_Posted_UserId = @a 
	from Facturacion_Solicitud_TrackingIssue_Forum a
	where 1 = 1
		and Message_Posted_UserId = @de

	update a 
		set isInfoIncomplete_UserId = @a 
	from Facturacion_Solicitud_InfoIncomplete_Log a
	where 1 = 1
		and isInfoIncomplete_UserId = @de

	update a
		set a.UserId_Upload = @a
	from Facturacion_Solicitud_Evidencia a
	where 1 = 1
		and UserId_Upload = @de
end