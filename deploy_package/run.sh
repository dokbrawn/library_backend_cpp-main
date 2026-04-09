cd "$(dirname "$0")"
export LIBRARY_PG_CONN="host=localhost port=5432 dbname=library user=postgres password=123"
./flutter-pi --release ./flutter_assets
