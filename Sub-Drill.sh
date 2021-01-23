curl --silent --insecure https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" > tmp.txt
curl --silent --insecure https://api.hackertarget.com/hostsearch/?q=$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure https://crt.sh/?q=%.$1  | grep -oP "\<TD\>\K.*\.$1" | sed -e 's/\<BR\>/\n/g' | grep -oP "\K.*\.$1" | sed -e 's/[\<|\>]//g' | grep -o -E "[a-zA-Z0-9._-]+\.$1"  >> tmp.txt
curl --silent --insecure https://crt.sh/?q=%.%.$1 | grep -oP "\<TD\>\K.*\.$1" | sed -e 's/\<BR\>/\n/g' | sed -e 's/[\<|\>]//g' | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure https://crt.sh/?q=%.%.%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u >> tmp.txt
curl --silent --insecure https://crt.sh/?q=%.%.%.%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | grep -o -E "[a-zA-Z0-9._-]+\.$1" |  sort -u >> tmp.txt
curl --silent --insecure https://certspotter.com/api/v0/certs?domain=$1 | grep  -o '\[\".*\"\]' | sed -e 's/\[//g' | sed -e 's/\"//g' | sed -e 's/\]//g' | sed -e 's/\,/\n/g' | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure https://spyse.com/target/domain/$1 | grep -E -o "button.*>.*\.$1\/button>" |  grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure https://tls.bufferover.run/dns?q=$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure https://dns.bufferover.run/dns?q=.$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure https://urlscan.io/api/v1/search/?q=$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure -X POST https://synapsint.com/report.php -d "name=http%3A%2F%2F$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure https://jldc.me/anubis/subdomains/$1 | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" >> tmp.txt
curl --silent --insecure https://sonar.omnisint.io/subdomains/$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure https://otx.alienvault.com/api/v1/indicators/domain/$1/passive_dns | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure https://riddler.io/search/exportcsv?q=pld:$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> tmp.txt
curl --silent --insecure -X POST https://suip.biz/?act=amass -d "url=$1&Submit1=Submit"  | grep $1 | cut -d ">" -f 2 | awk 'NF' >> tmp.txt
curl --silent --insecure -X POST https://suip.biz/?act=subfinder -d "url=$1&Submit1=Submit"  | grep $1 | cut -d ">" -f 2 | awk 'NF' >> tmp.txt
curl --silent --insecure "https://rapiddns.io/subdomain/$1?full=1#result" | grep "<td><a" | cut -d '"' -f 2 | grep http | cut -d '/' -f3 | sed 's/#results//g' | sort -u >> tmp.txt
curl --silent --insecure "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" | sed -e 's_https*://__' -e "s/\/.*//" | sort -u >> tmp.txt

if [[ $# -eq 2 ]]; then
    cat tmp.txt | sed -e "s/\*\.$1//g" | sed -e "s/^\..*//g" | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u > $2
else
    cat tmp.txt | sed -e "s/\*\.$1//g" | sed -e "s/^\..*//g" | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u
fi
rm -f tmp.txt
