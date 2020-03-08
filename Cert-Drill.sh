curl https://www.threatcrowd.org/searchApi/v2/domain/report/\?domain=$1 | jq .subdomains |grep -o "\w.*$1" > tmp.txt
curl https://api.hackertarget.com/hostsearch/\?q\=$1 | grep -o "\w.*$1" >> tmp.txt
curl https://crt.sh/?q=%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | sort -u >> tmp.txt
curl https://certspotter.com/api/v0/certs?domain=dav.org | grep  -o '\[\".*\"\]' | sed -e 's/\[//g' | sed -e 's/\"//g' | sed -e 's/\]//g' | sed -e "s/\*\.$1//g" | sed -e 's/\,/\n/g' >> tmp.txt
cat tmp.txt | sort -u > subdomains-$1.txt
rm -f tmp.txt
