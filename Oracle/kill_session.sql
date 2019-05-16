
---------verifica processos do oracle no so---------
ps -ef | grep LOCAL=NO

---------------mata processos----------------
kill -9 23406



SELECT SID, SERIAL#, USERNAME FROM V$SESSION;
