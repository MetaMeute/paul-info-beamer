#!/bin/sh

TARGET=$1

wget -qO"$1" http://api.openweathermap.org/data/2.5/weather?q=L%C3%BCbeck,DE 
