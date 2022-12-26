#!/bin/bash

binancedatas=$(curl -s https://rest.coinapi.io/v1/exchanges --request GET --header "X-CoinAPI-Key: A0C3673F-2BA1-432F-BA47-995C6154E45C" | grep -Poz '(?s)("BINANCE",)*n.*("KRAKEN")')
volume=$(echo $binancedatas | grep -oP '(?<="volume_1hrs_usd":)[^,]*' )

sqlite3 /home/ubuntu/api/BinanceVolume.db <<EOF
insert into Volume (binancevolume,date) values ($volume,datetime('now', 'localtime'));
EOF
