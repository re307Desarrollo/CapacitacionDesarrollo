create table #LiverpoolSKU(
	columna1 varchar(max)
	,columna2 varchar(max)
	,columna3 varchar(max)
	,columna4 varchar(max)
	,columna5 varchar(max)
	,columna6 varchar(max)
	,columna7 varchar(max)
	,columna8 varchar(max)
	,columna9 varchar(max)
	,columna10 varchar(max)
	,columna11 varchar(max)
	,columna12 varchar(max)
	,columna13 varchar(max)
	,columna14 varchar(max)
	,columna15 varchar(max)
	,columna16 varchar(max)
	,columna17 varchar(max)
	,columna18 varchar(max)
	,columna19 varchar(max)
	,columna20 varchar(max)
	,columna21 varchar(max)
	,columna22 varchar(max)
	,columna23 varchar(max)
	,columna24 varchar(max)
	,columna25 varchar(max)
	,columna26 varchar(max)
	,columna27 varchar(max)
	,columna28 varchar(max)
	,columna29 varchar(max)
	,columna31 varchar(max)
	,columna32 varchar(max)
	,columna33 varchar(max)
	,columna34 varchar(max)
	,columna35 varchar(max)
	,columna36 varchar(max)
	,columna37 varchar(max)
	,columna38 varchar(max)
	,columna39 varchar(max)
	,columna40 varchar(max)
	,columna41 varchar(max)
	,columna42 varchar(max)
	,columna43 varchar(max)
	,columna44 varchar(max)
	,columna45 varchar(max)
	,columna46 varchar(max)
	,columna47 varchar(max)
	,columna48 varchar(max)
	,columna49 varchar(max)
	,columna50 varchar(max)
	,columna51 varchar(max)
	,columna52 varchar(max)
	,columna53 varchar(max)
	,columna54 varchar(max)
)

BULK INSERT #LiverpoolSKU FROM 'H:\Desarrollo\Liverpool_SKU.txt' WITH (FIELDTERMINATOR= '	',FIRSTROW = 2);

insert into Z_DV_Liverpool_SKU
select 
	a.columna1 Tipo_Reg
	,a.columna2 Provedor
	,a.columna3 Material
	,a.columna4 Ean
	,'00' Cat_Articulo
	,ISNULL(a.columna6,'') Art_General
	,a.columna7 Desc_Art
	,'99' Estatus
	,a.columna9 Tp_Art
	,a.columna10 Art_Proveedor
	,a.columna11 Gpo_Art
	,a.columna12 Texto_Adicional
	,a.columna13 Negocio
	,a.columna14 Submarca
	,a.columna15 Desc_Sumarca
	,a.columna16 Licencia
	,ISNULL(a.columna17,'') Desc_Licencia
	,a.columna18 Temporada
	,CONVERT(float,a.columna19) Peso_Bruto
	,CONVERT(float,a.columna20) Peso_Neto
	,a.columna21 Unidad_Peso
	,CONVERT(float,a.columna22) Volumen
	,ISNULL(a.columna23,'') Unidad_Volumen
	,CONVERT(float,a.columna24) Longitud
	,CONVERT(float,a.columna25) Ancho
	,CONVERT(float,a.columna26) Altura
	,ISNULL(a.columna27,'') Unidad_L_A_A
	,ISNULL(a.columna28,'') Armado
	,ISNULL(a.columna29,'') Manipulacion
	,ISNULL(a.columna31,'') Almacenamiento
	,ISNULL(a.columna32,'') Servicio
	,CONVERT(float,a.columna34) Costo_Bruto
	,a.columna35 Inicio_Costo_Bruto
	,CONVERT(float,a.columna36) Costo_Bruto_p_Apl
	,a.columna37 Inicio_Costo_Bruto_p_Apl
	,CONVERT(float,a.columna38)Descuento1
	,CONVERT(float,a.columna39)Descuento2
	,CONVERT(float,a.columna40)Descuento3
	,CONVERT(float,a.columna41)Descuento4
	,CONVERT(float,a.columna42)Costo_Neto
	,CONVERT(float,a.columna43)Precio_venta
	,a.columna44 Inicio_Precio_Venta
	,CONVERT(float,a.columna45)Precio_venta_p_Apl
	,a.columna46 Inicio_Precio_venta_p_Apl
	,a.columna47 Etiqueta
	,ISNULL(a.columna48,'') Evento
	,ISNULL(a.columna49,'') Texto_datos_Basicos
	,ISNULL(a.columna50,'') Gr_Moda
	,ISNULL(a.columna51,'') Des_Gr_Moda
	,a.columna52 Pais
	,a.columna53 Descr_Pais
	,'' Region
	,'' Descr_Region
	,GETDATE() Fecha_Subida
from #LiverpoolSKU a
where 1 = 1
	and not exists (select * from Z_DV_Liverpool_SKU b
					where 1 = 1
						and a.columna3 = b.Material
						and a.columna4 = b.Ean) 

--select top 2 * from Z_DV_Liverpool_SKU

drop table #LiverpoolSKU