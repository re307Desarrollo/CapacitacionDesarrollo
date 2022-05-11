CREATE TABLE [dbo].[Subidas_Log_Gral_BotsRetail](
	[Id] int identity(1,1),
	[Cadena] [varchar](max) NULL,
	[Rubro] [varchar](max) NULL,
	[Tabla] [varchar](max) NULL,
	[Inicio_Actualiza] [datetime] NULL,
	[Fin_Actualiza] [datetime] NULL,
	[Sp_Padre] [varchar](max) NULL,
	[Comentarios] [varchar](max) NULL
)

Insert into [dbo].[Subidas_Log_Gral_BotsRetail] values
('Walmart','DEV','Z_DV_Pendientes_Walmart',null,null,null,null),
('Chedraui','DEV','Z_DV_Chedraui',null,null,null,null),
('Chedraui','DEV','Z_DV_Chedraui_Sucursal',null,null,null,null),
('Liverpool','DEV','Z_DV_Liverpool',null,null,null,null),
('Liverpool','DEV','Z_DV_Liverpool_SKU',null,null,null,null),
('Soriana','DEV','Z_DV_Soriana',null,null,null,null),
('Sanborns','DEV','Z_DV_Sanborns',null,null,null,null),
('CityFresko','DEV','Z_DV_CityFresko',null,null,null,null),
('HEB','DEV','Z_DV_HEB',null,null,null,null),
('Walmart','VE','Z_VE_Walmart',null,null,null,null),
('Chedraui','VE','Z_VE_Chedraui',null,null,null,null),
('Liverpool','VE','Z_VE_Liverpool',null,null,null,null),
('Sanborns','VE','Z_VE_Sanborns',null,null,null,null),
('CityFresko','VE','Z_VE_CityFresko',null,null,null,null),
('HEB','VE','Z_VT_HEB',null,null,null,null),
('Walmart','AR','Z_AR_Walmart',null,null,null,null),
('Walmart','AR','Z_FAC_Walmart',null,null,null,null),
('Soriana','AR','Z_AR_Soriana',null,null,null,null),
('CityFresko','AR','Z_AR_CityFresko',null,null,null,null),
('HEB','AR','Z_AR_HEB',null,null,null,null),
('Walmart','CAT','Z_CAT_Walmart',null,null,null,null),
('Sanborns','CAT','Z_CAT_Sanborns',null,null,null,null),
('CityFresko','CAT','Z_CAT_CityFresko',null,null,null,null),
('Chedraui','CAT','Z_CAT_Chedraui',null,null,null,null)


