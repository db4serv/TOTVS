
col message for a100
select ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE",
        SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
              message,to_char(sysdate,'dd-mm-yyyy hh24:mi:ss'),
             to_char(START_TIME,'dd-mm-yyyy hh24:mi:ss') START_TIME,
             to_char(LAST_UPDATE_TIME,'dd-mm-yyyy hh24:mi:ss') LAST_UPDATE_TIME
         from v$session_longops
       where totalwork !=0
         and sofar!=totalwork
         AND    OPNAME NOT LIKE '%aggregate%'
         and opname like 'RMAN%';


col message for a100
select ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE",
        SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
              message,to_char(sysdate,'dd-mm-yyyy hh24:mi:ss'),
             to_char(START_TIME,'dd-mm-yyyy hh24:mi:ss') START_TIME,
             to_char(LAST_UPDATE_TIME,'dd-mm-yyyy hh24:mi:ss') LAST_UPDATE_TIME
         from v$session_longops
       where totalwork !=0
         and sofar!=totalwork
         AND    OPNAME  LIKE '%aggregate%'
         and opname like 'RMAN%'; 


SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   V$SESSION_LONGOPS
WHERE  OPNAME LIKE 'RMAN%'
AND    OPNAME NOT LIKE '%aggregate%'
AND    TOTALWORK != 0
AND    SOFAR <> TOTALWORK;



---------------tomazini prefere assim-------------
SELECT SID, SERIAL#, OPNAME,CONTEXT, SOFAR, TOTALWORK,
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   V$SESSION_LONGOPS
WHERE  OPNAME LIKE 'RMAN%'
AND    TOTALWORK != 0
AND    SOFAR <> TOTALWORK;



