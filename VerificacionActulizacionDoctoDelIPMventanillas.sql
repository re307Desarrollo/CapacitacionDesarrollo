declare
	@Accion int  = 1
	,@Documento varchar(max) = '6978268'


if @Accion = 1
begin
	select 
		* 
	from Control_Entregas_Concentrado a
	where 1 = 1
		and a.Tipo_Documento = 'Factura'
		and a.Docto_Num = @Documento
end
if @Accion = 2
begin

	update [Control_Entregas_Concentrado]
	set [Status_Entrega] = 'Pendiente'
		,[Acuse_Recibo] = null
		,[Ejemplares_Rechazados] = null
		,[MotivoRechazo] = null
		,[Observaciones] = null
		,[MotivoDiferencia] = null
		,[Folio_Recibo] = null
		,[Operador_Responsable_Liquidacion] = null
		,[Folio_Liquidacion] = null
		,[Liquida_Usuario] = null
		,[Liquida_Timestamp] = null
		,[IndicadorC] = null
		,Operador_Responsable_Entrega = '-'
	where 1 = 1
		and Tipo_Documento = 'Factura'
		and Docto_Num = @Documento
	--and Docto_Num in ('6855325')
	--and Docto_Num in ('6973760')

end

return

