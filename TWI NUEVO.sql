declare 
	@serieConsulta varchar(max) = '8010'
	,@FechaConsulta date = DATEADD(dd,-1,GETDATE())
	,@Logistica int = 0 --1:REC 2:REMI

	select @FechaConsulta FechaConsulta,@serieConsulta Serie,(case @Logistica
																	when 0 then 'Elije tipo'
																	when 1 then 'REC'
																	when 2 then 'REMI'
																end )Archivo

if @Logistica = 1
	EXEC [TWI_Salida_LD_(REC)] @FechaOperacion = @FechaConsulta ,@Serie = @serieConsulta

if @Logistica = 2
	EXEC [TWI_Salida_LI_(REMI)] @FechaOperacion = @FechaConsulta ,@Serie = @serieConsulta

--series no ocupadas
--LD 7881 2021-07-10
--LD 7893 2021-07-24
--LD 7917 2021-08-21
--LD 7929 2021-09-04
--LD 7935 2021-09-11
--LD 7946 2021-09-25
--LD 7952 2021-10-02
--LD 7958 2021-10-09
--LD 7964 2021-10-16
--LD 7970 2021-10-23
--LD 7976 2021-10-30
--LD 7998 2021-11-27

--https://1drv.ms/u/s!AiuElLQ5TpfEh4pBEs20hQPD706t3w?e=m8as0j //subir los archivos a esta liga de onedriver, perdir acceso a Gio.