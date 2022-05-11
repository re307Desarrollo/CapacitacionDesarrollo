select 
	GETDATE() actual
	,DATEADD(hh,2,DATEADD(dd,1,GETDATE())) siguiente
	,CONVERT(time,GETDATE()-DATEADD(hh,2,DATEADD(dd,1,GETDATE())))diferencia_aritmetica
	,DATEDIFF(DAY,GETDATE(),DATEADD(hh,2,DATEADD(dd,1,GETDATE()))) diferencia

select 
	a.OpenSessionAt
	,a.Id
	,DATEDIFF(HH,a.OpenSessionAt,ISNULL(a.ClosedSessionAt,GETDATE()))
	,(
		case
			when DATEDIFF(DAY,a.OpenSessionAt,ISNULL(a.ClosedSessionAt,GETDATE())) >= 1 
				then (
					case
						when DATEDIFF(HH,a.OpenSessionAt,ISNULL(a.ClosedSessionAt,GETDATE())) >= 24
						then convert(varchar,DATEDIFF(DAY,a.OpenSessionAt,ISNULL(a.ClosedSessionAt,GETDATE())))+' d '+ CONVERT(varchar,CONVERT(time,ISNULL(a.ClosedSessionAt,GETDATE())-a.OpenSessionAt),20)+''
						else CONVERT(varchar,CONVERT(time,ISNULL(a.ClosedSessionAt,GETDATE())-a.OpenSessionAt),20)
					end
				)
			else CONVERT(varchar,CONVERT(time,ISNULL(a.ClosedSessionAt,GETDATE())-a.OpenSessionAt),20)
		end
	)Diferencia
from AspNetSessionActive a
	left outer join AspNetUsers b
	on a.UserId = b.Id
where 1 = 1
	and b.Email like '%remendezp%'
	and a.ClosedSessionAt is null

--update a
--	set
--		a.ClosedSessionAt = GETDATE()
--from AspNetSessionActive a
--where 1 = 1
--	and a.Id in (56,66)