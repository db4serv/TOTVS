-- GERAR LOG EM ARQUIVO TEXTO
SPOOL C:\VALIDACAO_BACKUP_LOG.txt;

-- INSTANCE
set pages 100
set lines 200
col dbname for a30
col hostname for a30
select user as usuario
      ,sys_context('userenv','db_name') as dbname
      ,sys_context('USERENV', 'SERVER_HOST') as HOSTNAME 
from dual;

-- set lines 300 pages 500
-- col name for a65
-- select INST_ID,name,CHECKPOINT_TIME from gv$datafile;

prompt
prompt
prompt #####################################
prompt ### Verifica BKPs RMAN executados ###
prompt #####################################
prompt
prompt
prompt ### CF: Number of controlfile backups included in the backup set 
prompt ### DF: Number of datafile full backups included in the backup set 
prompt ### I0: Number of datafile incremental level-0 backups included in the backup set 
prompt ### I1: Number of datafile incremental level-1 backups included in the backup set 
prompt ###  L: Number of archived log backups included in the backup set
prompt

prompt
prompt ### Qual INPUT_TYPE vc quer???
prompt

prompt ### --> DB FULL
prompt ### --> RECVR AREA
prompt ### --> DB INCR
prompt ### --> DATAFILE FULL
prompt ### --> DATAFILE INCR
prompt ### --> ARCHIVELOG
prompt ### --> CONTROLFILE
prompt ### --> SPFILE
prompt
prompt


set lines 300 pages 1000 verify off
col cf for 9,999
col df for 9,999
col elapsed_seconds for 99999999 heading "ELAPSED|SECONDS"
col i0 for 9,999
col i1 for 9,999
col  l for 9,999
col output_mbytes for 99,999,999 heading "OUTPUT|MBYTES"
col session_recid for 999999 heading "SESSION|RECID"
col session_stamp for 99999999999 heading "SESSION|STAMP"
col status for a10 trunc
col time_taken_display for a10 heading "TIME|TAKEN"
col output_instance for 9999 heading "OUT|INST"
col OUTPUT_BYTES_PER_SEC_DISPLAY for a9 heading "OUTPUT | RATE|(PER SEC)"
col incremental_level heading "INC_LEVEL" trunc
select
 -- j.session_recid, j.session_stamp, 
  to_char(j.start_time, 'yyyy-mm-dd hh24:mi:ss') start_time,                       
  to_char(j.end_time, 'yyyy-mm-dd hh24:mi:ss') end_time,
  (j.output_bytes/1024/1024) output_mbytes, j.status, j.input_type, incremental_level,
  decode(to_char(j.start_time, 'd'), 1, 'Sunday', 2, 'Monday',
                                     3, 'Tuesday', 4, 'Wednesday',
                                     5, 'Thursday', 6, 'Friday',
                                     7, 'Saturday') day_week,
  j.elapsed_seconds, j.time_taken_display,
  x.cf, x.df, x.i0, x.i1, x.l    , j.OUTPUT_BYTES_PER_SEC_DISPLAY                    
 -- ,ro.inst_id output_instance
from V$RMAN_BACKUP_JOB_DETAILS j
  left outer join (select 
                     d.session_recid, d.session_stamp,
                     sum(case when d.controlfile_included = 'YES' then d.pieces else 0 end) CF,
                     sum(case when d.controlfile_included = 'NO'
                               and d.backup_type||d.incremental_level = 'D' then d.pieces else 0 end) DF,
                     sum(case when d.backup_type||d.incremental_level = 'D0' then d.pieces else 0 end) I0,
                     sum(case when d.backup_type||d.incremental_level = 'I1' then d.pieces else 0 end) I1,
                     sum(case when d.backup_type = 'L' then d.pieces else 0 end) L , d.incremental_level
                   from
                     V$BACKUP_SET_DETAILS d
                     join V$BACKUP_SET s on s.set_stamp = d.set_stamp and s.set_count = d.set_count     and d.incremental_level = s.incremental_level
                   where s.input_file_scan_only = 'NO'
                   group by d.session_recid, d.session_stamp,d.incremental_level) x
    on x.session_recid = j.session_recid and x.session_stamp = j.session_stamp                          and incremental_level = incremental_level
  left outer join (select o.session_recid, o.session_stamp, min(inst_id) inst_id
                   from GV$RMAN_OUTPUT o
                   group by o.session_recid, o.session_stamp)
    ro on ro.session_recid = j.session_recid 
       and ro.session_stamp = j.session_stamp                                and incremental_level = incremental_level
where j.start_time > trunc(sysdate)-&NUMBER_OF_DAYS
and j.input_type = '&INPUT_TYPE'
order by j.start_time
/




prompt
prompt ###############################
prompt ## Volumetria Database geral ##
prompt ###############################
prompt

set lines 300 pages 100
col "%FREE" for 99.99
col "DatabaseSize MB" for 999,999,999,999
col "Usedspace MB" for 999,999,999,999
col "Freespace MB" for 999,999,999,999
SELECT ROUND(SUM(used.BYTES)/1024/1024) "DatabaseSize MB",
       ROUND(SUM(used.BYTES)/1024/1024)-ROUND(free.p/1024/1024) "Usedspace MB",
       ROUND(free.p/1024/1024/1024) "Freespace MB",
       (ROUND(free.p/1024/1024)*100)/(ROUND(sum(used.BYTES)/1024/1024)) "%FREE"
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




undef NUMBER_OF_DAYS
undef INPUT_TYPE
set verify on



-- DESATIVA SPOOL
SPOOL OFF




