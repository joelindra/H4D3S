#!/usr/bin/bash

display_help() {
    local OS=$(uname)
    local GREEN=''
    local YELLOW=''
    local NC=''

    if [[ $OS == 'Linux' ]]; then
        GREEN=("\033[0;31m" "\033[0;32m" "\033[0;33m" "\033[0;34m" "\033[0;35m" "\033[0;36m" "\033[0;37m") 
        YELLOW=("\033[1;31m" "\033[1;32m" "\033[1;33m" "\033[1;34m" "\033[1;35m" "\033[1;36m" "\033[1;37m")
        NC='\033[0m'
    elif [[ $OS == 'Darwin' ]]; then
        GREEN=("\033[31m" "\033[32m" "\033[33m" "\033[34m" "\033[35m" "\033[36m" "\033[37m")
        YELLOW=("\033[1;31m" "\033[1;32m" "\033[1;33m" "\033[1;34m" "\033[1;35m" "\033[1;36m" "\033[1;37m")
        NC='\033[0m'
    fi
    echo ""
    echo -e ${YELLOW}"Usage: ./hades [options]"
    echo -e ""
    echo -e "Options:"
    echo -e "  [ -s ] Single Domain Reccon & Assessments"
    echo -e "  [ -m ] Multi Domain Assessments"
    echo -e "  [ -d ] Multi Domain Reccon"
    echo -e "  [ -b ] Blackhat Attacker"
    echo -e "  [ -x ] Automate XSS Attack"
    echo -e "  [ -i ] Install Requirements"${NC}
}
if [[ $# -eq 0 ]]; then
    display_help
    exit 0
fi

while getopts "smdbix" opt; do
    case $opt in
    s)
        echo ""
        clear
        figlet -w 100 -f small SDomain
        echo -e $MAGENTA
        read -p "Input Domain Here λ " domain
        clear
        folder(){
        mkdir -p $domain $domain/sources $domain/result $domain/result/wayback $domain/result/gf $domain/result/nuclei/
        }
        folder
        wayback(){
        echo "https://$domain/" | waybackurls | anew $domain/result/wayback/wayback-tmp.txt 
        cat $domain/result/wayback/wayback-tmp.txt | command egrep -v "\.woff|\.ttf|\.svg|\.eot|\.png|\.jpeg|\.jpg|\.png|\.css|\.ico" |  sed 's/:80//g;s/:443//g' | sort -u > $domain/result/wayback/wayback.txt
        rm $domain/result/wayback/wayback-tmp.txt
        }
        wayback
        valid_url(){
        ffuf -c -u "FUZZ" -w $domain/result/wayback/wayback.txt -of csv -o $domain/result/wayback/valid-tmp.txt
        cat $domain/result/wayback/valid-tmp.txt | grep http | awk -F "," '{print $1}' >> $domain/result/wayback/valid.txt
        rm $domain/result/wayback/valid-tmp.txt
        }
        valid_url
        gf_patt(){
        gf xss $domain/result/wayback/valid.txt | tee $domain/result/gf/xss.txt
        gf sqli $domain/result/wayback/valid.txt | tee $domain/result/gf/sql.txt
        gf ssrf $domain/result/wayback/valid.txt | tee $domain/result/gf/ssrf.txt
        gf redirect $domain/result/wayback/valid.txt | tee $domain/result/gf/redirect.txt
        gf rce $domain/result/wayback/valid.txt | tee $domain/result/gf/rce.txt
        gf idor $domain/result/wayback/valid.txt | tee $domain/result/gf/idor.txt
        gf lfi $domain/result/wayback/valid.txt | tee $domain/result/gf/lfi.txt
        gf ssti $domain/result/wayback/valid.txt | tee $domain/result/gf/ssti.txt
        gf debug_logic $domain/result/wayback/valid.txt | tee $domain/result/gf/debug_logic.txt
        gf img-traversal $domain/result/wayback/valid.txt | tee $domain/result/gf/img-traversal.txt
        gf interestingparams $domain/result/wayback/valid.txt | tee $domain/result/gf/interestingparams.txt
        gf aws-keys $domain/result/wayback/valid.txt | tee $domain/result/gf/aws.txt
        gf base64 $domain/result/wayback/valid.txt | tee $domain/result/gf/base64.txt
        gf cors $domain/result/wayback/valid.txt | tee $domain/result/gf/cors.txt
        gf http-auth $domain/result/wayback/valid.txt | tee $domain/result/gf/http-auth.txt
        gf php-errors $domain/result/wayback/valid.txt | tee $domain/result/gf/phpe.txt
        gf takeovers $domain/result/wayback/valid.txt | tee $domain/result/gf/takes.txt
        gf urls $domain/result/wayback/valid.txt | tee $domain/result/gf/urls.txt
        gf s3-buckets $domain/result/wayback/valid.txt | tee $domain/result/gf/s3.txt
        gf strings $domain/result/wayback/valid.txt | tee $domain/result/gf/strings.txt
        gf upload-fields $domain/result/wayback/valid.txt | tee $domain/result/gf/ups.txt
        gf servers $domain/result/wayback/valid.txt | tee $domain/result/gf/server.txt
        gf ip $domain/result/wayback/valid.txt | tee $domain/result/gf/ip.txt
        }
        gf_patt
        nucle(){
        echo "https://$domain/" | nuclei -severity low,medium,high,critical -o $domain/result/nuclei/vuln.txt | notify
        }
        nucle
        echo "done_$domain" | notify -silent
        ;;
    m)
        echo ""
        inputtarget(){
        clear
        figlet -w 100 -f small MADomain
        echo -e $MAGENTA
        read -p "Input Domain Here λ " domain
        }
        inputtarget
        clear
        domain_enum(){
        mkdir -p $domain $domain/sources $domain/result $domain/result/nuclei $domain/result/httpx $domain/result/exploit
        subfinder -d $domain -o $domain/sources/subfinder.txt
        assetfinder -subs-only $domain | tee $domain/sources/assetfinder.txt
        amass enum -passive -d $domain -o $domain/sources/amass.txt
        cat $domain/sources/*.txt > $domain/sources/all.txt
        }
        domain_enum
        httprobe(){
        cat $domain/sources/all.txt | httpx -o $domain/result/httpx/httpx.txt
        }
        httprobe
        nucle(){
        cat $domain/result/httpx/httpx.txt | nuclei -severity low,medium,high,critical -o $domain/result/nuclei/vuln.txt | notify
        }
        nucle
        echo "done_$domain" | notify -silent
        ;;
    d)
        echo ""
        inputtarget(){
        clear
        figlet -w 100 -f small MDomain
        echo -e $MAGENTA
        read -p "Input Domain Here λ " domain
        }
        inputtarget
        clear
        domain_enum(){
        mkdir -p $domain $domain/sources $domain/result $domain/result/files $domain/result/httpx $domain/result/wayback $domain/result/gf
        subfinder -d $domain -o $domain/sources/subfinder.txt
        assetfinder -subs-only $domain | tee $domain/sources/assetfinder.txt
        amass enum -passive -d $domain -o $domain/sources/amass.txt
        cat $domain/sources/*.txt > $domain/sources/all.txt
        }
        domain_enum
        httprobe(){
        cat $domain/sources/all.txt | httpx -silent -t 200 -o $domain/result/httpx/httpx.txt
        }
        httprobe
        wayback(){
        cat $domain/result/httpx/httpx.txt | waybackurls | tee $domain/result/wayback/tmp.txt
        cat $domain/result/wayback/tmp.txt | command egrep -v "\.woff|\.ttf|\.svg|\.eot|\.png|\.jpeg|\.jpg|\.png|\.css|\.ico" |  sed 's/:80//g;s/:443//g' | sort -u > $domain/result/wayback/wayback.txt
        rm $domain/result/wayback/tmp.txt
        }
        wayback
        valid_url(){
        ffuf -c -u "FUZZ" -w $domain/result/wayback/wayback.txt -of csv -o $domain/result/wayback/valid-tmp.txt
        cat $domain/result/wayback/valid-tmp.txt | grep http | awk -F "," '{print $1}' >> $domain/result/wayback/valid.txt
        rm $domain/result/wayback/valid-tmp.txt
        rm $domain/result/wayback/wayback.txt
        }
        valid_url
        gf_patt(){
        gf xss $domain/result/wayback/valid.txt | tee $domain/result/gf/xss.txt
        gf sqli $domain/result/wayback/valid.txt | tee $domain/result/gf/sql.txt
        gf ssrf $domain/result/wayback/valid.txt | tee $domain/result/gf/ssrf.txt
        gf redirect $domain/result/wayback/valid.txt | tee $domain/result/gf/redirect.txt
        gf rce $domain/result/wayback/valid.txt | tee $domain/result/gf/rce.txt
        gf idor $domain/result/wayback/valid.txt | tee $domain/result/gf/idor.txt
        gf lfi $domain/result/wayback/valid.txt | tee $domain/result/gf/lfi.txt
        gf ssti $domain/result/wayback/valid.txt | tee $domain/result/gf/ssti.txt
        gf debug_logic $domain/result/wayback/valid.txt | tee $domain/result/gf/debug_logic.txt
        gf img-traversal $domain/result/wayback/valid.txt | tee $domain/result/gf/img-traversal.txt
        gf interestingparams $domain/result/wayback/valid.txt | tee $domain/result/gf/interestingparams.txt
        gf aws-keys $domain/result/wayback/valid.txt | tee $domain/result/gf/aws.txt
        gf base64 $domain/result/wayback/valid.txt | tee $domain/result/gf/base64.txt
        gf cors $domain/result/wayback/valid.txt | tee $domain/result/gf/cors.txt
        gf http-auth $domain/result/wayback/valid.txt | tee $domain/result/gf/http-auth.txt
        gf php-errors $domain/result/wayback/valid.txt | tee $domain/result/gf/phpe.txt
        gf takeovers $domain/result/wayback/valid.txt | tee $domain/result/gf/takes.txt
        gf urls $domain/result/wayback/valid.txt | tee $domain/result/gf/urls.txt
        gf s3-buckets $domain/result/wayback/valid.txt | tee $domain/result/gf/s3.txt
        gf strings $domain/result/wayback/valid.txt | tee $domain/result/gf/strings.txt
        gf upload-fields $domain/result/wayback/valid.txt | tee $domain/result/gf/ups.txt
        gf servers $domain/result/wayback/valid.txt | tee $domain/result/gf/server.txt
        gf ip $domain/result/wayback/valid.txt | tee $domain/result/gf/ip.txt
        }
        gf_patt
        echo "done_$domain" | notify -silent
        ;;
    b)
        echo ""
        inputtarget(){
        clear
        figlet -w 100 -f small Blackhat Exploit
        echo -e $MAGENTA
        read -p "Input Domain Here λ " domain
        }
        inputtarget
        clear
        folder(){
        mkdir -p $domain $domain/sources $domain/result $domain/result/nuclei/
        subfinder -d $domain -o $domain/sources/subfinder.txt
        assetfinder -subs-only $domain | tee $domain/sources/assetfinder.txt
        amass enum -passive -d $domain -o $domain/sources/amass.txt
        cat $domain/sources/*.txt > $domain/sources/all.txt
        }
        folder
        httprobe(){
        cat $domain/sources/all.txt | httpx -t 200 -o $domain/result/httpx.txt
        }
        httprobe
        nucle(){
        cat $domain/result/httpx.txt | nuclei -severity high,critical -o $domain/result/nuclei/critical.txt | notify
        }
        nucle
        echo "done_$domain" | notify -silent
        ;;
    i)
        main(){
            cd Require && bash require-k.sh
        }
        main
        ;;
    x)
        echo ""
        inputtarget(){
        clear
        figlet -w 100 -f small Automate XSS Attack
        echo -e $MAGENTA
        read -p "Input Domain Here λ " domain
        }
        inputtarget
        clear
        folder(){
        mkdir -p $domain $domain/sources $domain/result $domain/result/xss
        subfinder -d $domain -o $domain/sources/subfinder.txt
        assetfinder -subs-only $domain | tee $domain/sources/assetfinder.txt
        amass enum -passive -d $domain -o $domain/sources/amass.txt
        cat $domain/sources/*.txt > $domain/sources/all.txt
        }
        folder
        xss(){
        cat $domain/sources/all.txt | dnsx | waybackurls | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt|js)" | uro | dalfox pipe -b anonres.xss.ht -o $domain/result/xss/xss.txt | notify
        }
        xss
        ;;
    \?)
        echo "Invalid option: -$OPTARG"
        exit 1
        ;;
    esac
done
