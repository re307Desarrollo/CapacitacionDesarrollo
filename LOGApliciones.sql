--APPS
use [Global]
SELECT [Sp]
      ,[Tabla]
      ,[Inicio_Actualiza]
      ,[Fin_Actualiza]
         ,DATEDIFF(HH, [Inicio_Actualiza], [Fin_Actualiza]) DiferenciaHoras
         ,DATEDIFF(MI, [Inicio_Actualiza], [Fin_Actualiza]) DiferenciaMinutos
         ,DATEDIFF(SS, [Inicio_Actualiza], [Fin_Actualiza]) DiferenciaSegundos
         ,DATEDIFF(DD, [Inicio_Actualiza], [Fin_Actualiza]) DiferenciaDías
      ,[Sp_Padre]
         ,[Comentarios]
FROM [Global].[dbo].[Subidas_Log_Gral] 
where 1 = 1
       --and Sp_Padre = 'Subir_PC'
       --and Tabla = 'C_VentasPortal'
	   --and Tabla = 'Maestro_Actividades_Cadenas'
       --and Sp = 'Subir_AP_Gral'
       --and Sp_Padre = 'Subir_DV'
       --and Sp = 'Subir_VP_Bulks'
       --and Sp = 'Subir_BA'
	   --and Sp = 'Consumo'
	   and Sp_Padre like '%Carga%'
       --and Sp_Padre like '%Control%'
       --or Tabla like '%Control%'
       --and Sp_Padre = 'Subir_DV'
       --and Sp_Padre like '%Empty%'
       --and Sp = 'Subir_AcreditacionPortalesWeb'
       --and Sp = 'Subir_Devoluciones_Carga_ORACLE_Auditoria'
       --and Sp_Padre = 'Devoluciones_Master_Subir'
	   --and Tabla like '%Programa%'
       
  --order by Sp asc
  order by Inicio_Actualiza desc
return

select * from Control_Entregas_Devoluciones a
where 1 = 1
	and CONVERT(date, a.AltaSistema) = '2021-07-22'
order by a.AltaSistema desc


 -- ---Cuando no se carga datos a twi
 -- exec [consumo2.0] @Accion = 'Control_Entregas_Devolucion_Consumo'
 -- exec [consumo2.0] @Accion = 'Control_Entregas_Concentrado_Factura_Consumo'

 -- -----PC no se ejecuto correctamente
 -- select top 100 * from Programa_Circulacion_Completo
 -- exec carga 'Programa_Circulacion_Completo_Carga'

 -- ----Cuando no se puede ver venta en aduana
	--select top 100 *  from [CORPSFEVEXTSQLP.CORP.TELEVISA.COM.MX,2020].[Global].[dbo].Maestro_Actividades_Cadenas
	--select top 100 * from Maestro_Actividades_Cadenas
	--exec Carga 'Maestro_Actividades_Cadenas_Carga'
 


 -- ---Cargar devoluciones al IPM
execute Carga 'Control_Entregas_Devolucion_Carga' -- 20:59 min 1472*/

