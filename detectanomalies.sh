#!/bin/bash

datas=$(sqlite3 /home/ubuntu/api/BinanceVolume.db  "SELECT * from Volume;")
mean=$(sqlite3 /home/ubuntu/api/BinanceVolume.db  "SELECT avg(binancevolume) from Volume;")
volumes=$(sqlite3 /home/ubuntu/api/BinanceVolume.db  "SELECT binancevolume from Volume;")
size=$(sqlite3 /home/ubuntu/api/BinanceVolume.db "SELECT COUNT(*) from Volume;")
sum=0
for volume in $volumes
do
    sum=`echo "$sum + ($volume - $mean) * ($volume - $mean)" | bc -l`
done
variance=`echo "$sum / ($size - 1)" | bc -l`

std=`echo "sqrt($variance)" | bc -l`
lower=`echo "$mean-1.96*$std/sqrt($size)" | bc -l`
upper=`echo "$mean+1.96*$std/sqrt($size)" | bc -l`

echo "95% confidence interval: $lower - $upper"

echo "Anomalies:"
for volume in $volumes
do
    if [ $(echo "$volume < $lower" | bc -l) -eq 1 ] || [ $(echo "$volume > $upper" | bc -l) -eq 1 ]
    then
        echo $volume
        zero=0
        test=$(sqlite3 /home/ubuntu/api/BinanceVolume.db "SELECT COUNT(*) from Anomalie where binancevolume=$volume;")
        if [ "$test" -eq "$zero" ]
        then
                sqlite3 /home/ubuntu/api/BinanceVolume.db "insert into Anomalie (binancevolume,date) values ($volume,datetime('now', 'localtime'));"
                date=$(date)
                message=$(echo "Anomaly detected: $volume, $date")
                URL="https://api.telegram.org/bot5622861740:AAG3BTjR4QnNxjaS1yKfFO-n1HQEs23nI_s/sendMessage"
                curl -s -X POST $URL --data "text=$message" --data "chat_id=-1001825184996"
        fi
    fi
done

anomalies=$(sqlite3 /home/ubuntu/api/BinanceVolume.db "SELECT * from Anomalie ORDER BY date ASC;")

for anomaly in $anomalies
do
        echo "<p>$anomaly</p>">>anomalies.txt
done
anomalydata=$(head -n 100 anomalies.txt)
sudo cat > /var/www/binancevolume/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
   <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Anomalies</title>
        </head>
        <body>
                <h1>Anomalies in the 24h Volume of Binance</h1>
                <p>Mean : $mean</p>
                <p>Confidence Interval : $lower - $upper</p>

                <h2>History of Anomalies</h2>
                <div>$anomalydata</div>

        </body>
</html>
EOF