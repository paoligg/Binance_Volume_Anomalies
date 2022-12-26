#!/bin/bash

sqlite3 BinanceVolume.db  "create table Volume(binancevolume VARCHAR(50) NOT NULL, date DATETIME NOT NULL, PRIMARY KEY (binancevolume));"
sqlite3 BinanceVolume.db  "create table Anomalie(binancevolume VARCHAR(50) NOT NULL, date DATETIME NOT NULL, PRIMARY KEY (binancevolume));"
