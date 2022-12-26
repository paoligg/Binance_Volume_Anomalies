#!/bin/bash

sqlite3 /home/ubuntu/api/BinanceVolume.db <<'END_SQL'
SELECT * FROM Volume
END_SQL

echo "Next Table"
sqlite3 /home/ubuntu/api/BinanceVolume.db <<'END_SQL'
SELECT * FROM Anomalie
END_SQL
