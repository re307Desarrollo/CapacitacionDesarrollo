create table #Oxxo(
	cliente varchar(max),
	folio varchar(max),
	Codigo varchar(max),
	CB varchar(max),
	fecha date,
	unidades int,
	importe float,
	cadena varchar(max),
	Item varchar(max),

)
BULK INSERT #Oxxo FROM 'H:\Desarrollo\Concentrado Dropbox\Oxxo.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 2);

select 'Tabla completa' presenta
select * from #Oxxo

select 'Tabla Agrupada' presenta
select 
	a.cliente,
	a.folio,
	a.Codigo,
	a.CB,
	a.fecha,
	SUM(a.unidades)unidades,
	SUM(a.importe)importe,
	a.cadena,
	a.Item
from #Oxxo a
group by
	a.cliente,
	a.folio,
	a.Codigo,
	a.CB,
	a.fecha,
	a.unidades,
	a.importe,
	a.cadena,
	a.Item 

--select 'Subiran' presenta
select 
	a.cliente,
	a.folio,
	a.Codigo,
	a.CB,
	a.fecha,
	SUM(a.unidades)unidades,
	SUM(a.importe)importe,
	a.cadena,
	a.Item,
	GETDATE() FechaSubida
	into #subiran
from #Oxxo a
where 1 = 1
	and not exists (select * from Devoluciones_COMMEX_Reporte_Acumulado_porItem b
					where 1 = 1
						and a.cliente = b.cliente
						and a.folio = b.folio
						and a.Item = b.Item
						)
group by
	a.cliente,
	a.folio,
	a.Codigo,
	a.CB,
	a.fecha,
	a.unidades,
	a.importe,
	a.cadena,
	a.Item 

select COUNT(*) Subiran from #subiran

insert into Devoluciones_Oxxo_Reporte_Acumulado_porItem
select 
	a.cliente,
	a.folio,
	a.Codigo,
	a.CB,
	a.fecha,
	SUM(a.unidades)unidades,
	SUM(a.importe)importe,
	a.cadena,
	a.Item,
	GETDATE()
from #Oxxo a
where 1 = 1
	and not exists (select * from Devoluciones_COMMEX_Reporte_Acumulado_porItem b
					where 1 = 1
						and a.cliente = b.cliente
						and a.folio = b.folio
						and a.Item = b.Item
						)
group by
	a.cliente,
	a.folio,
	a.Codigo,
	a.CB,
	a.fecha,
	a.unidades,
	a.importe,
	a.cadena,
	a.Item 

drop table #Oxxo,#subiran