#!/bin/bash
export LIBRARY_PG_CONN="host=10.239.42.46 port=5432 dbname=library user=postgres password=123"
./library_flutter_frontend &
sleep 2
./library_backend init
wait
