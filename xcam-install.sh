#!/bin/bash

printf "\e[1;32m  ================================================================\e[0m\n"
printf "\e[1;32m  #  X Cam - Easy Install - Infinity x White Devels Team          #\e[0m\n"
printf "\e[1;32m  ================================================================\e[0m\n\n"

printf "\e[1;32m[+] Installing dependencies...\e[0m\n"

if command -v apt-get > /dev/null 2>&1; then
    sudo apt-get update -qq && sudo apt-get install -y php ssh wget unzip 2>/dev/null
    printf "\e[1;31m[\e[1;91m*\e[1;31m] Done (apt)\e[0m\n"
elif command -v pkg > /dev/null 2>&1; then
    pkg install -y php openssh 2>/dev/null
    printf "\e[1;32m[*] Done (Termux)\e[0m\n"
elif command -v brew > /dev/null 2>&1; then
    brew install php 2>/dev/null
    printf "\e[1;32m[*] Done (macOS)\e[0m\n"
else
    printf "\e[1;33m[!] Please install PHP and SSH manually.\e[0m\n"
fi

chmod +x xcam.sh xcam-cleanup.sh 2>/dev/null
printf "\e[1;32m[*] Run: bash xcam.sh\e[0m\n\n"
