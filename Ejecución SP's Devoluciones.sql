--Devoluciones
---------------------------------------------------
----EXEC [Devoluciones_Liverpool_Subir_2.0]
EXEC [Devoluciones_HEB_Subir_2.0]
--EXEC [Devoluciones_Chedraui_Subir_2.0]
--EXEC [Devoluciones_Cityfresko_Subir_2.0]
--EXEC [Devoluciones_Sanborns_Subir_2.0]
--EXEC [Devoluciones_Walmart_Subir_2.0] 
--EXEC [Devoluciones_Walmart_Subir_2.0_SinIVA]

-------EXEC [Devoluciones_Soriana_Subir_2.0] 
-------EXEC [Devoluciones_7ELEVEN_Subir_2.0]
-------EXEC [Devoluciones_OXXO_Subir_2.0] 
-------EXEC [Devoluciones_COMMEX_Subir_2.0]


--EXEC [Control_Entregas_AlimentarDevoluciones]
--EXEC [dbo].[Devoluciones_ConcentradoTotal_Subir]
--EXEC [dbo].[Devoluciones_ConcentradoTotalCabecero_Subir]


--Carga de Informaci�n de Devoluciones
--Este query s�lo se ejecuta desde el server de apps
USE Global
execute Carga 'Control_Entregas_Devolucion_Carga' -- 20:59 min 1472*/
