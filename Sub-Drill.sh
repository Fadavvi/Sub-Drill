touch /tmp/sub-drill-tmp.txt
####################################################
# ?full=1 doesn't work properly!
response=$(curl --silent --insecure --tcp-fastopen --tcp-nodelay -m 15 "https://rapiddns.io/subdomain/$1?page=1")
total=$(echo "$response" | grep 'Total:' | cut -d'>' -f3 | cut -d'<' -f1)
total=$((total))
echo $response | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u >> /tmp/sub-drill-tmp.txt
max_page=$((total / 100))
if [ $((total % 100)) -ne 0 ]; then
    max_page=$((max_page + 1))
fi
for page in $(seq 2 $max_page) 
do
    curl --silent --insecure --tcp-fastopen --tcp-nodelay  -m 15 "https://rapiddns.io/subdomain/$1?page=$page" | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u >> /tmp/sub-drill-tmp.txt &
done
####################################################
# curl --silent --insecure --tcp-fastopen --tcp-nodelay "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" | sed -e 's_https*://__' -e "s/\/.*//" | sort -u >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay -m 20 "https://crt.sh/?q=%.$1&group=none" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay -m 20 "https://crt.sh/?q=%.%.$1" | grep -oP "\<TD\>\K.*\.$1" | sed -e 's/\<BR\>/\n/g' | sed -e 's/[\<|\>]//g' | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay -m 20 "https://crt.sh/?q=%.%.%.$1" | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay -m 20 "https://crt.sh/?q=%.%.%.%.$1" | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | grep -o -E "[a-zA-Z0-9._-]+\.$1" |  sort -u >> /tmp/sub-drill-tmp.txt &
#curl --silent --insecure --tcp-fastopen --tcp-nodelay https://otx.alienvault.com/api/v1/indicators/domain/$1/passive_dns | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
#curl --silent --insecure --tcp-fastopen --tcp-nodelay https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://api.hackertarget.com/hostsearch/?q=$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://api.certspotter.com/v1/issuances?domain=$1&include_subdomains=true&expand=dns_names&expand=issuer.caa_domains" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
#curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://spyse.com/target/domain/$1" | grep -E -o "button.*>.*\.$1\/button>" |  grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
#curl --silent --insecure --tcp-fastopen --tcp-nodelay https://tls.bufferover.run/dns?q=$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
#curl --silent --insecure --tcp-fastopen --tcp-nodelay https://dns.bufferover.run/dns?q=.$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://urlscan.io/api/v1/search/?q=$1&size=10000" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://api.synapsint.com/subdomains/$1" -H "X-Api-Key: 67d70885-65ea-4693-b30f-139c0623b7ff" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://jldc.me/anubis/subdomains/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://sonar.omnisint.io/subdomains/$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://riddler.io/search/exportcsv?q=pld:$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" >> /tmp/sub-drill-tmp.txt &
#curl --silent --insecure --tcp-fastopen --tcp-nodelay -X POST https://suip.biz/?act=amass -d "url=$1&Submit1=Submit"  | grep $1 | cut -d ">" -f 2 | awk 'NF' >> /tmp/sub-drill-tmp.txt &
#curl --silent --insecure --tcp-fastopen --tcp-nodelay -X POST https://suip.biz/?act=subfinder -d "url=$1&Submit1=Submit"  | grep $1 | cut -d ">" -f 2 | awk 'NF' >> /tmp/sub-drill-tmp.txt &
#curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://securitytrails.com/list/apex_domain/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | grep ".$1" | sort -u >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://certificatedetails.com/$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sed -e 's/^.//g' | sort -u >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://columbus.elmasy.com/report/$1" | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u >> /tmp/sub-drill-tmp.txt &
#curl --silent --insecure --tcp-fastopen --tcp-nodelay https://webscout.io/lookup/$1 | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://api.subdomain.center/?domain=$1&engine=cuttlefish" | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u >> /tmp/sub-drill-tmp.txt &
curl --silent --insecure --tcp-fastopen --tcp-nodelay "https://ip.thc.org/api/v1/subdomains/download?domain=$1&limit=50000" | grep -$1 | sort -u >> /tmp/sub-drill-tmp.txt &

wait

if [[ $# -eq 2 ]]; then
    cat /tmp/sub-drill-tmp.txt | sed -e "s/\*\.$1//g" | sed -e "s/^\..*//g" | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u > $2
else
    cat /tmp/sub-drill-tmp.txt | sed -e "s/\*\.$1//g" | sed -e "s/^\..*//g" | grep -o -E "[a-zA-Z0-9._-]+\.$1" | sort -u
fi
rm -f /tmp/sub-drill-tmp.txt
