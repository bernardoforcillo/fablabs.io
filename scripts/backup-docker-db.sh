docker exec fablabsio_db_1 pg_dumpall -c -U postgres > backup/dump_`date +%Y-%m-%d"_"%H_%M_%S`.sql
