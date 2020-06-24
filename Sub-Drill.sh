curl --silent https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1 | grep -o -E "[a-zA-Z0-9._-]+\.\.$1" > tmp.txt
curl --silent https://api.hackertarget.com/hostsearch/?q=$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent https://crt.sh/?q=%.$1  | grep -oP "\<TD\>\K.*\.$1" | sed -e 's/\<BR\>/\n/g' | grep -oP "\K.*\.$1" | sed -e 's/[\<|\>]//g'  >> tmp.txt
curl --silent https://crt.sh/?q=%.%.$1 | grep -oP "\<TD\>\K.*\.$1" | sed -e 's/\<BR\>/\n/g' | sed -e 's/[\<|\>]//g' >> tmp.txt
curl --silent https://crt.sh/?q=%.%.%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | sort -u >> tmp.txt
curl --silent https://crt.sh/?q=%.%.%.%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | sort -u >> tmp.txt
curl --silent https://certspotter.com/api/v0/certs?domain=$1 | grep  -o '\[\".*\"\]' | sed -e 's/\[//g' | sed -e 's/\"//g' | sed -e 's/\]//g' | sed -e 's/\,/\n/g' >> tmp.txt
curl --silent https://spyse.com/target/domain/$1 | grep -E -o "button.*>.*\.$1\/button>" |  grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent https://tls.bufferover.run/dns?q=$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
if [[ $# -eq 2 ]]; then
    cat tmp.txt | sed -e "s/\*\.$1//g" | sed -e "s/^\..*//g" | sort -u > $2
else
    cat tmp.txt | sed -e "s/\*\.$1//g" | sed -e "s/^\..*//g" | sort -u
fi
rm -f tmp.txt
