===============QUERYS MAIS CUSTOSAS=================

alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
set lines 300
col segment_name for a35
select owner,segment_name,segment_type,tablespace_name,bytes/1024/1024 MB 
from dba_segments where segment_name like '%/WATP/TMOBMRIA%';