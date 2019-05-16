set lines 300 pages 100
col USERNAME for a12
col MACHINE for a25
COLUMN module FORMAT A15
COLUMN machine FORMAT A10
COLUMN program FORMAT A45
SELECT
    USERNAME,
    SID,
    SERIAL#,
    STATUS,
    substr(machine,1,8) as machine,
    LOCKWAIT,MODULE,PROGRAM,
    TO_CHAR(logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM V$SESSION 
order by status;






SET LINESIZE 500 PAGESIZE 100
COLUMN username FORMAT A12
COLUMN osuser FORMAT A15
COLUMN spid FORMAT A10
COLUMN service_name FORMAT A15
COLUMN module FORMAT A20
COLUMN machine FORMAT A10
COLUMN program FORMAT A18
COLUMN logon_time FORMAT A20
SELECT NVL(s.username, '(oracle)') AS username,
       s.osuser,
       s.sid,
       s.serial#,
       p.spid,
       s.lockwait,
       s.status,
     --  s.service_name,
       s.module,
       substr(s.machine,1,8) as machine,
       s.program,
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM   v$session s,
       v$process p
WHERE  s.paddr = p.addr
ORDER BY s.username, s.osuser;

SET PAGESIZE 14 LINESIZE 70








set lines 300 pages 100
col USERNAME for a20
col MACHINE for a20
break on sid skip 3
SELECT nvl(ses.username,'ORACLE PROC')||' ('||ses.sid||')' USERNAME,
       SID,   
       substr(MACHINE,1,8) MACHINE, 
       REPLACE(SQL.SQL_TEXT,CHR(10),'') STMT, 
      ltrim(to_char(floor(SES.LAST_CALL_ET/3600), '09')) || ':'
       || ltrim(to_char(floor(mod(SES.LAST_CALL_ET, 3600)/60), '09')) || ':'
       || ltrim(to_char(mod(SES.LAST_CALL_ET, 60), '09'))    RUNT 
from v$SESSION SES, v$SQLtext_with_newlines SQL 
where SES.STATUS = 'ACTIVE'
   and SES.USERNAME is not null
   and SES.SQL_ADDRESS    = SQL.ADDRESS 
   and SES.SQL_HASH_VALUE = SQL.HASH_VALUE 
   and Ses.AUDSID <> userenv('SESSIONID') 
order by runt desc, 1,sql.piece;

SET PAGESIZE 14 LINESIZE 70


