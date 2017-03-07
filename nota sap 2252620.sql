SELECT  T0.middleName 
	   ,T0.empID
FROM  OHEM T0
INNER JOIN OUSR T1
ON  T1.USERID = T0.userId
LEFT OUTER JOIN USR6 T2
ON   T2.BPLId = T0.BPLId
AND   T1.USER_CODE = T2.UserCode
WHERE    T2.BPLId IS NULL
AND   T0.BPLId> 0



--UPDATE  OHEM

--SET            BPLId = null
-- WHERE   empID IN
--(      SELECT  T0.empID
--       FROM    OHEM T0
--       INNER JOIN OUSR T1
--              ON      T1.USERID = T0.userId
--       LEFT OUTER JOIN USR6 T2
--              ON      T2.BPLId = T0.BPLId
--              AND  T1.USER_CODE = T2.UserCode
--       WHERE   T2.BPLId IS NULL

--              AND  T0.BPLId> 0)