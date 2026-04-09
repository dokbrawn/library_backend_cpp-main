#!/bin/bash
export LIBRARY_PG_CONN="host=localhost port=5432 dbname=library user=postgres password=123"
./library_flutter_frontend &
sleep 2
./library_backend init
wait
