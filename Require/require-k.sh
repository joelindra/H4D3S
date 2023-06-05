#!/usr/bin/bash

RED="\e[31m"
GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
MAGENTA="\e[35m"
EN="\e[0m"

apt install figlet
salam(){
clear
figlet -w 100 -f small Requirements
echo -e $MAGENTA""
}
salam
mkdir /root/.config
apt update && apt upgrade -y
apt install dnsx git subjack seclists massdns ffuf nikto nmap golang subfinder toilet pip python3-pip npm -y
apt install zsh curl wget -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
touch ~/.hushlogin
cd /root
wget https://raw.githubusercontent.com/blechschmidt/massdns/master/lists/resolvers.txt && cp resolvers.txt /usr/share/seclists/
cd /root && resolvers.txt
cd /root && git clone https://github.com/tomnomnom/gf.git
cd /usr/local/ && mkdir go 
cd /root
cd /usr/local/go && mkdir src bin
cd /root/gf && cp *.zsh /usr/local/go/src
cd /root && git clone https://github.com/1ndianl33t/Gf-Patterns.git
go install -v github.com/tomnomnom/gf@latest
cp /root/go/bin/gf /usr/local/go/bin/
cd /root
echo source /usr/local/go/src/gf-completion.zsh >> ~/.zshrc
source ~/.zshrc
cd /root && cp -r gf/examples ~/.gf
cd /root && cp Gf-Patterns/*.json ~/.gf

mid(){
clear
figlet -w 100 -f small Install-Tools
}
mid

go install -v github.com/tomnomnom/unfurl@latest
echo "DONE Successfully"
go install -v github.com/lukasikic/subzy@latest
echo "DONE Successfully"
go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
echo "DONE Successfully"
go install -v github.com/hahwul/dalfox/v2@latest
echo "DONE Successfully"
go install -v github.com/OWASP/Amass/v3/...@master 
echo "DONE Successfully"
go install -v github.com/projectdiscovery/notify/cmd/notify@latest
echo "DONE Successfully"
go install -v github.com/tomnomnom/qsreplace@latest
echo "DONE Successfully"
go install -v github.com/hakluke/hakrawler@latest 
echo "DONE Successfully"
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo "DONE Successfully"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest 
echo "DONE Successfully"
go install -v github.com/tomnomnom/httprobe@latest
echo "DONE Successfully"
go install -v github.com/tomnomnom/waybackurls@latest
echo "DONE Successfully"
go install -v github.com/tomnomnom/assetfinder@latest
echo "DONE Successfully"
go install -v github.com/tomnomnom/fff@latest
echo "DONE Successfully"
go install -v github.com/tomnomnom/anew@latest
echo "DONE Successfully"
go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest
echo "DONE Successfully"
go install github.com/lc/gau/v2/cmd/gau@latest
echo "DONE Successfully"
go install -v github.com/musana/mx-takeover@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/Ice3man543/SubOver@latest
go install -v github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest
go install github.com/ezekg/git-hound@latest
echo "DONE Successfully"

cd /root && git clone https://github.com/r0oth3x49/ghauri.git \
  && cd ghauri \
  && python3 -m pip install --upgrade -r requirements.txt \
  && python3 setup.py install \
  && ghauri --help
echo "DONE Successfully"

mod(){
clear
figlet -w 100 -f small CopyAllFiles
echo -e $MAGENTA""
}
mod

cp /root/go/bin/* /usr/bin/
mkdir -p /root/.config/
mkdir -p /root/.config/notify
echo '
slack:
  - id: "slack"
    slack_channel: "hacker"
    slack_username: "anonre"
    slack_format: "{{data}}"
    slack_webhook_url: "https://hooks.slack.com/services/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"
' >> /root/.config/notify/provider-config.yaml