spool c:\volumetria_database.log

prompt
prompt ###############################
prompt ## Volumetria Database geral ##
prompt ###############################
prompt

set lines 300 pages 100
col "%FREE" for 99.99
col "DatabaseSize GB" for 999,999,999,999
col "Usedspace GB" for 999,999,999,999
col "Freespace GB" for 999,999,999,999
SELECT ROUND(SUM(used.BYTES)/1024/1024/1024) "DatabaseSize GB",
       ROUND(SUM(used.BYTES)/1024/1024/1024)-ROUND(free.p/1024/1024/1024) "Usedspace GB",
       ROUND(free.p/1024/1024/1024) "Freespace GB",
       (ROUND(free.p/1024/1024/1024)*100)/(ROUND(sum(used.BYTES)/1024/1024/1024)) "%FREE"
FROM (SELECT BYTES
      FROM v$datafile
      UNION ALL
      SELECT BYTES
      FROM v$tempfile
      UNION ALL
      SELECT BYTES
      FROM v$log) used,
     (SELECT SUM (BYTES) AS p
      FROM dba_free_space) free
GROUP BY free.p;

prompt
prompt ########################################
prompt ## Volumetria Datafiles, TEMP e REDOs ##
prompt ########################################
prompt

set lines 300
col Fisico_MB for 999,999,999
col "MB" for 999,999,999
set lines 300 pages 100
col TAM_MB for 999,999,999,999
select sum(MB) Fisico_MB
from (select round(sum(bytes/1024/1024),0) as "MB"
from dba_data_files
union
select round(sum(bytes/1024/1024),0) as "MB"
from dba_temp_files
union
select sum(v.BYTES/1024/1024) TAM_MB
from v$logfile f, v$log v
where f.group# = v.group#);

prompt
prompt #################################
prompt ## Volumetria OBJs do Database ##
prompt #################################
prompt

col TAM_MB for 999,999,999,999,999,999
select round(sum(bytes/1024/1024),0) TAM_MB from dba_segments;












prompt
prompt #####################
prompt ## FREE TABLESPACE ##
prompt #####################
prompt


set pagesize 50
set linesize 120
break on report
comp sum of ocup on report
comp sum of aloc on report
comp sum of free on report
col tablespace_name format a25
col ocup format 99,999,999,999,999
col aloc format 99,999,999,999,999
col free format 99,999,999,999,999
col "%FREE"  format 999.99
select   a.tablespace_name,a.bytes-b.bytes ocup , 
a.bytes aloc ,b.bytes free ,
round((b.bytes/a.bytes)*100,2) "%FREE"
from (select sum(bytes) bytes,tablespace_name 
      from dba_data_files 
      group by tablespace_name ) a, 
     ( select sum(bytes) bytes , tablespace_name
       from dba_free_space  
       group by tablespace_name ) b
where a.tablespace_name=b.tablespace_name
order by 5 desc
/















prompt
prompt ############
prompt ## TABLES ##
prompt ############
prompt



set lines 300 pages 100
COLUMN OWNER           FORMAT A15
COLUMN SEGMENT_NAME    FORMAT A33
COLUMN SEGMENT_type    FORMAT A19
COLUMN TABLESPACE_NAME FORMAT A15
COLUMN BYTES           FORMAT 999,999,999,999,999
COLUMN EXTENTS         FORMAT 999,999,999
COLUMN NEXT_EXTENT     FORMAT 999,999,999,999,999
select owner, segment_name, tablespace_name, segment_type, bytes, extents, NEXT_EXTENT, MAX_EXTENTS
from dba_segments
where segment_type like '%TABLE%' 
-- AND TABLESPACE_NAME LIKE UPPER('%&TABLESP%')
-- AND segment_name NOT LIKE('WK_%')
AND owner not in('SYS','SYSTEM')
ORDER BY bytes
/






prompt
prompt #############
prompt ## INDEXES ##
prompt #############
prompt



set linesize 300 pages 100
COLUMN OWNER           FORMAT A15
COLUMN SEGMENT_NAME    FORMAT A30
COLUMN TABLESPACE_NAME FORMAT A25
COLUMN BYTES           FORMAT 999,999,999,999,999
COLUMN EXTENTS         FORMAT 999,999,999
COLUMN NEXT_EXTENT     FORMAT 999,999,999,999,999
COLUMN SEGMENT_TYPE    FORMAT A16
COLUMN MAX_EXTENTS     FORMAT 999,999,999,999,999
select owner, segment_name, tablespace_name, segment_type, bytes, extents, NEXT_EXTENT, MAX_EXTENTS
from dba_segments
where segment_type = 'INDEX' 
-- AND TABLESPACE_NAME LIKE UPPER('%&TABLESP%')
AND owner not in('SYS','SYSTEM')
ORDER BY bytes
/





spool off



