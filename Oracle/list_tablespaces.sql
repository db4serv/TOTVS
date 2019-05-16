SET linesize 130
SET pagesize 60
break ON tablespace_name skip 1
col tablespace_name format a15
col file_name format a50
col tablespace_kb heading 'TABLESPACE|TOTAL KB'
col kbytes_free heading 'TOTAL FREE|KBYTES'
 
SELECT dd.tablespace_name tablespace_name, dd.file_name file_name, dd.bytes/1024 TABLESPACE_KB, SUM(fs.bytes)/1024 KBYTES_FREE, MAX(fs.bytes)/1024 NEXT_FREE
FROM sys.dba_free_space fs, sys.dba_data_files dd
WHERE dd.tablespace_name = fs.tablespace_name
AND dd.file_id = fs.file_id
GROUP BY dd.tablespace_name, dd.file_name, dd.bytes/1024
ORDER BY dd.tablespace_name, dd.file_name;