Select
B.Zona --
,B.Oracle No_Cliente
,B.Razon_Social
,B.Nombre_Sucursal Sucursal
,B.Denominacion_CC Denominación
,B.Estado
,B.Alcaldia_Municipio Población
,B.Ruta_Maquina
,B.Direccion_Envio
,B.Num_Sucursal Codigo_Sucursal
,B.Cedi_Ruta_Porteo
,B.Ruta_Cedi_Mex
,B.Denom_Operativa Den_Comer
,Null Telefonos
,B.Zona_Comercial
,Null ZonaComDet
,B.Supervisor_Dist Supervisor
,B.Estatus Status
,B.Canal
,Null Comentarios_Estatus
,null Memorandum
,B.Canal Canal_de_Ventas
,null Tiempo_de__Regreso
,Null Tiempo_Captura
,Null Tiempo_Total__hasta_el_Estatus
,(case when B.Dia_Visita_Dist like '%Sab%' or B.Dia_Visita_Dist like '%Sáb%' then 1 else 0 end) S --
,(case when B.Dia_Visita_Dist like '%Dom%' then 1 else 0 end) D --
,(case when B.Dia_Visita_Dist like '%Lun%' then 1 else 0 end) L --
,(case when B.Dia_Visita_Dist like '%Mar%' then 1 else 0 end) M
,(case when B.Dia_Visita_Dist like '%Mie%' or B.Dia_Visita_Dist like '%Mié%' then 1 else 0 end) W --
,(case when B.Dia_Visita_Dist like '%Jue%' then 1 else 0 end) J --
,(case when B.Dia_Visita_Dist like '%Vie%' then 1 else 0 end) V --
,(case when B.Dia_Visita_Dist like '%Sab2%' then 1 else 0 end) S2 --
,B.Dia_Visita_Dist Días_de_Vistisa
,B.Dia_Embarque Día_de_Embarque
,B.Promotor Nombrepromotor
,B.Supervisor_Prom
,Lunes --
,Martes --
,Miercoles --
,Jueves --
,Viernes --
,Sabado --
,B.Dia_Visita_Prom
,Num_Visitas_Prom Visitas_Semanales --
,B.Estatus
,Null Sem_sin_Fact_2017
 
from [168_5_Carta_de_Rutas] B
where 1 = 1
	and not exists (select * from E_Carta_de_Rutas c
					where 1 = 1
						and b.Oracle = c.No_Cliente)
	--and a.Canal_de_Ventas =
	and b.Oracle = 21768