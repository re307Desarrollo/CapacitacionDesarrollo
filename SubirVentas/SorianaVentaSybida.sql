USE GLOBAL
exec Automatizacion_Soriana @Accion ='ConsultaVta_Soriana',@Bandera='1',@Fecha='2021-02-02'
return
exec Automatizacion_Soriana @Accion ='Subir_Ventas_Soriana',@Bandera='1'


--Subir_Ventas_Soriana_Espejo
exec Automatizacion_Soriana @Accion ='Subir_Ventas_Soriana_Espejo',@FileName='VTA764120210601-1.txt',@Bandera='0'
exec Automatizacion_Soriana @Accion ='Subir_Ventas_Soriana_Espejo',@FileName='VTA764120210317-1-DiaAnt.txt',@Bandera='1'

select 
	a.Fecha
	,a.Bandera
	,sum(a.Unidades)Unidades
from Z_VE_Soriana_Espejo a
where 1 = 1
and a.Fecha in ('2021-05-30','2021-06-01')
group by a.Fecha
		,a.Bandera
order by a.Fecha 


delete a
from Z_VE_Soriana_Espejo a
where 1 = 1
and a.Fecha in ('2021-05-30','2021-06-01')
