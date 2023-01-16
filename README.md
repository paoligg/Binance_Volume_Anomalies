# Binance_Volume_Anomalies

This is my project created as part of an Operating Systems course. 

This Project uses the Coin Api to scrap the Volume of the last hour for Binance in USD. 
The API used is https://www.coinapi.io/ 

It detects anomalies given a confidence interval of 95%. 

It is linked to a website that gives an history of all the anomalies registered, and it sends a Telegram notification with the newly added anomalies. 
The address is the following :  http://3.83.91.134/ 

You can deploy your own website with APACHE or NGINX. 

You can host this script on your machine, or on any remote server. 
You can clone this repo : 

```Bash
$ git clone <this repo url>
```

Launch the createtable.sh script :

```Bash
$ source createtable.sh
```

Then use a cronjob to make it run every hour : 

* Open your crontab file :
```Bash
$ crontab -e
```
* And write your command in it : 

```Bash
0 */1 * * * <Path to your apibot.sh>
0 */1 * * * <Path to your detectanomalies.sh>
```


