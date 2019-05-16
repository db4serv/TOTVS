
set lines 300
select  (select username from v$session where sid=a.sid) blockeando,
           a.sid,
           ' blockeado --> ', 
           (select username from v$session where sid=b.sid) Esperando,  
           b.sid     
from v$lock a, v$lock b    
where a.block = 1     
and b.request > 0      
and a.id1 = b.id1
and a.id2 = b.id2;







set lines 300
select substr(decode (s.lockwait, NULL,'** BLOCKER','== WAITER') || '...............',1,13) ||
           substr(' - ' || s.sid || '..........',1,9) ||
           substr(' - ' || s.username || '..........................',1,24) ||
           substr(' - ' || 'kill -9 ' || p.spid || '       ............',1,24) ||
           substr(' - ' || s.lockwait || '.............................',1,24) ||
           substr(' - ' || 'kill -9 ' || p.spid || '       ...................',1,24) ||
           substr(' - ' || s.status || '..........',1,11)||
           substr(' - ' || s.sql_hash_value ||'........',1,30)||
           substr(' - ' || s.last_call_et ||'........',1,30) as string_tt
    from ( select unique raddr, saddr, request from v$_lock where request > 0) waiter,
         ( select raddr, saddr, request from v$_lock where request = 0) blocker,
            v$session s,
     v$process p
    where waiter.raddr = blocker.raddr
    and (waiter.saddr= s.saddr or blocker.saddr = s.saddr)
    and (s.paddr = p.addr)
/



set linesize 300
select substr(decode (s.lockwait, NULL,'** BLOCKER','== WAITER') || '...............',1,13) ||
           substr(' - ' || s.sid || '..........',1,9) ||
           substr(' - ' || s.username || '..........................',1,26) ||
           substr(' - ' || 'kill -9 ' || p.spid || '       ............',1,25) ||
           substr(' - ' || s.lockwait || '.............................',1,25) ||
           substr(' - ' || 'kill -9 ' || p.spid || '       ...................',1,25) ||
           substr(' - ' || s.status || '..........',1,11)||
           substr(' - ' || s.sql_hash_value ||'........',1,30)||
           substr(' - ' || s.last_call_et ||'........',1,30) as string_tt
    from ( select unique raddr, saddr, request from v$_lock where request > 0) waiter,
         ( select raddr, saddr, request from v$_lock where request = 0) blocker,
            v$session s,
     v$process p
    where waiter.raddr = blocker.raddr
    and (waiter.saddr= s.saddr or blocker.saddr = s.saddr)
    and (s.paddr = p.addr)
/





set lines 300
select /*+ ordered */ a.serial#, a.sid, a.username, b.id1, c.sql_text
from v$lock b, v$session a, v$sqltext c
where b.id1 in
(select /*+ ordered */ distinct e.id1
from v$lock e, v$session d
where d.lockwait = e.kaddr)
and a.sid = b.sid
and c.hash_value = a.sql_hash_value
and b.request = 0;




select /*+ ordered */ b.username, b.serial#, d.id1, a.sql_text
from v$lock d, v$session b, v$sqltext a
where b.lockwait = d.kaddr
and a.address = b.sql_address
and a.hash_value = b.sql_hash_value;

set lines 70







