#!/bin/bash
# stock-conky.sh by livibetter 2010-08-17
# Usage: stock-conky.sh <chart_small|chart_large|header|quote> [ticker symbol] [x y]

case "$1" in
  chart_small)
    wget -q "http://ichart.finance.yahoo.com/t?s=$2&lang=en-US&region=US" -O "/tmp/yahoo.finance.$2.png"
    echo "\${image /tmp/yahoo.finance.$2.png -p $3,$4 -s 192x96 -f 60}"
    ;;
  chart_large)
    wget -q "http://ichart.finance.yahoo.com/b?s=$2&lang=en-US&region=US" -O "/tmp/yahoo.finance.$2.png"
    echo "\${image /tmp/yahoo.finance.$2.png -p $3,$4 -s 512x288 -f 60}"
    ;;
  header)
    echo 'Symbol${goto 130}Last${goto 180}Change${goto 300}Open${goto 350}High${goto 400}Low${goto 450}Volume${goto 500}Date${goto 570}Time'
    ;;
  quote)
    wget -q "http://download.finance.yahoo.com/d/quotes.csv?s=$2&f=sl1d1t1c1ohgvp2&e=.csv" -O - | awk -F "\"*,\"*" '{
ticker = substr(substr($1, 2, length($1) - 1), 1, 8);
printf("%-8s ${goto 130}%7.2f ", ticker, $2);

if ($5 > 0)
  printf("${color green}")
else if ($5 < 0)
  printf("${color red}")
else
  printf("${color black}");

if ($5 == "N/A")
  printf("${goto 180}${color}N/A (   N/A) ")
else
  printf("${goto 180}%7.2f (%5.2f%%)$color ", $5, $10)

if ($6 == "N/A")
  printf("${goto 300}N/A ")
else
  printf("${goto 300}%7.2f ", $6);

if ($7 == "N/A")
  printf("${goto 300}N/A ")
else
  printf("${goto 350}%7.2f ", $7);

if ($8 == "N/A")
  printf("${goto 400}N/A ")
else
  printf("${goto 400}%7.2f ", $8);

if ($9 == "N/A")
  printf("${goto 450}%10s ", "N/A")
else
  printf("${goto 450}%10d ", $9);

printf("${goto 500}%10s${goto 570}%7s", $3, $4);
printf("\n");
}'
    ;;
esac
