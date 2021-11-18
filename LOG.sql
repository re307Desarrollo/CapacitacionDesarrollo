SELECT [Sp]
      ,[Tabla]
      ,[Inicio_Actualiza]
      ,[Fin_Actualiza]
      ,DATEDIFF(HH, [Inicio_Actualiza], [Fin_Actualiza]) DiferenciaHoras
      ,DATEDIFF(MI, [Inicio_Actualiza], [Fin_Actualiza]) DiferenciaMinutos
      ,DATEDIFF(SS, [Inicio_Actualiza], [Fin_Actualiza]) DiferenciaSegundos
      ,DATEDIFF(DD, [Inicio_Actualiza], [Fin_Actualiza]) DiferenciaDias
      ,[Sp_Padre]
      ,[Comentarios]
FROM [Global].[dbo].[Subidas_Log_Gral] 
where 1 = 1
	
	
	--and Sp_Padre = 'Automatizacion_Liverpool'
	--and Sp like '%Automatizacion_Liverpool_SKU%'

	--and Sp like '%Control_Entregas_AlimentarDevoluciones%'
   
   --and Sp_Padre = 'Devoluciones_Master_Subir'
   --and Sp_Padre = 'Subir_Catalogacion_Concentrado'

   --and sp like '%Control%'
   --and Sp_Padre like '%Subir_Kardex%'
    --and Sp_Padre = 'Subir_PC' 
    --and Sp_Padre = 'Control_Entregas_Devolucion_Fisica_Confirmada_Subir'                    --Devoluci�nF�sica
    --and Sp = 'ReporteDiferencias_Transacciones_Subir'                                              --Transacciones Completo
    --and Sp like '%Subir_DV%'                                                                                    --Diario de Ventas
    --and Sp = 'ReporteDiferencias_Pedidos_Subir'                                                    --Pedidos
		--and Sp = 'Subir_Vouchers_NotasCredito'                                                       --Vouchers Notas de Credito
      --and Sp = 'Subir_88_8_Entradas_MC'                                                                        --Entradas Mesa de Control
       --and Sp = 'Subir_R88_1_Canceladas_Remision_Detalle'                                    --Remisiones
       --and Sp = '[Subir_88_7_Transacciones_Sucursales]'                                             --Transacciones Sucursales
	  --and Sp = 'Subir_VP'
	   --and Sp_Padre like '%execute TresxTres_CodigosSeguridad_3%'
    --and Tabla = 'C_VentasPortal'
    --and Sp = 'Subir_AP_Gral'
    --and Sp_Padre = 'Subir_DV'
    --and Sp = 'Subir_VP_Bulks'
    --and Sp = 'Subir_BA'
    --and Sp_Padre like '%Empty%'
    --and Sp = 'Subir_AcreditacionPortalesWeb'
    --and sp like '%CR%'
	--and sp like '%Subir_CR%'
    --and sp like '%CCC%' 
    --and sp like '%LP%'
    --and Sp like '%SUBIR%'


	/*Ventas de Portal Start*/
		--and Sp = 'Subir_VP_Bulks'
		--and Tabla = 'C_VentasPortal' and Sp = 'Subir_VP'
		--and Sp = 'Subir_VP'
		--and Sp_Padre = 'Subir_VP'
		--and Sp = 'Flash_ActualizacionDiaria_DiasVenta'
		--and Sp = 'Subir_AP_Gral'
		--and Sp = 'C_VentasPortal_DV_AlimentacionDiaria'
		--and Sp = 'CATMAN_SP_Acumulado'
		--and Sp = 'Acumulado_Bidetails_VP_in'
		--and Sp = '27_IndicadorOperativo'
	/*Ventas de Portal End*/


	and Sp_Padre = 'Automatizacion_Chedraui'
	--and Tabla = 'Devoluciones_Soriana'

	--and Sp = 'TresxTres_AlimentacionDevolucionesPortal_AsignacionFechaRecoleccion_1'
	--and Sp = 'Subir_PC'
	--and Sp = 'Subir_VP'
	--and Sp_Padre = 'Subir_VP'
	--and Sp = 'TresxTres_CodigosSeguridad_3'---<---
	--and Sp = 'Devoluciones_Pagos_Subir' or Sp_Padre = 'Devoluciones_Master_Subir'
	--and Sp_Padre = 'Devoluciones_Master_Subir'
	--and Sp = 'Subir_Z_AR_MatrizDocumentos'
	--and Sp = 'Subir_Z_AR_MatrizDocumentos_AsignacionDocumentosIntermex'
	--and Sp = 'Subir_Z_AR_MatrizDocumentos_AsignacionDocumentosIntermex_Parche'
	--and Sp = 'Reporte_ControlDocumental_LD_Nuevo'
	--and Sp = 'Subir_Maestro_Productos'
	--and Sp = 'Subir_FlashConcentrado_Items'---<-----
	--and Sp = 'Subir_FlashConcentrado_ForecastSystem'
	--and Sp = 'Subir_Catalogacion_Concentrado'
	--and Sp_Padre = 'Reporte_Incidencias' 
	--and Sp_Padre = 'Subir_Maestro_Control_Documental_LD_Documentos'
	--and Sp_Padre = 'Subir_TresxTres_MaestroDevoluciones'
	--and  CONVERT(date,Inicio_Actualiza) < '2020-01-01'
	
  order by Inicio_Actualiza desc

  /*

  execute EmptyTransactionLog;

  */
  

  return 



