#!/usr/bin/env bash

# ======================================================
# Fake Wi-Fi Monitor Mode Scanner (Demo / Visual Only)
# Modes:
#   default      -> AP scan only
#   --station    -> APs + STATIONS
#   --handshake  -> APs + STATIONS + WPA handshake animation
# ======================================================

# ------------------ Colors ------------------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
WHITE="\e[97m"
DIM="\e[2m"
BOLD="\e[1m"
RESET="\e[0m"

# ------------------ Help Menu ------------------
show_help() {
  printf "%b\n" \
"${CYAN}Fake Wi-Fi Monitor Mode Scanner${RESET} ${DIM}(Visual Demo Only)${RESET}

${BOLD}Usage:${RESET}
  ${GREEN}fake_wifi_scan.sh${RESET} ${YELLOW}[options]${RESET}

${BOLD}Options:${RESET}
  ${YELLOW}--station${RESET}     Show fake client (${MAGENTA}STATION${RESET}) list
  ${YELLOW}--handshake${RESET}   Show STATION list and ${GREEN}WPA handshake${RESET} animation
  ${YELLOW}--help, -h${RESET}    Display this help menu and exit
"
}

# ------------------ Flags ------------------
SHOW_STATIONS=false
SHOW_HANDSHAKE=false

for arg in "$@"; do
  case "$arg" in
    --station)
      SHOW_STATIONS=true
      ;;
    --handshake)
      SHOW_STATIONS=true
      SHOW_HANDSHAKE=true
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Use --help for usage."
      exit 1
      ;;
  esac
done

# ------------------ Config ------------------
MON="wlan0mon"
HOP_DELAY=0.6

CHANNELS_24=(1 3 6 9 11)
CHANNELS_5=(36 40 44 48 149 153 157 161)

SSIDS=(
  "CoffeeShop_WiFi"
  "NETGEAR-5G"
  "AndroidAP"
  "linksys_ext"
  "xfinitywifi"
  "ATT-WIFI"
  "HomeLab"
  "Free_Public_WiFi"
  "FBI_Van"
  "HoneyPot"
  "GetHackedHere"
)

ENCRYPTION=("WPA2" "WPA3")
PROBES=("DIRECT-XY" "HP-Setup" "Chromecast" "AndroidAP" "NETGEAR")

# ------------------ Helpers ------------------
rand_mac() {
  printf "%02X:%02X:%02X:%02X:%02X:%02X\n" \
    $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) \
    $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))
}

print_ap_header() {
  echo -e "\n${CYAN}CH  ${WHITE}PWR  ${GREEN}BSSID              ${YELLOW}ENC   ${BLUE}ESSID${RESET}"
  echo -e "${DIM}------------------------------------------------------------${RESET}"
}

print_station_header() {
  echo -e "\n${MAGENTA}STATION            ${WHITE}PWR  ${CYAN}Rate  ${GREEN}Lost  ${YELLOW}Frames  ${BLUE}BSSID${RESET}"
  echo -e "${DIM}----------------------------------------------------------------------------${RESET}"
}

handshake_animation() {
  local BSSID="$1"
  local SSID="$2"

  echo -e "\n${YELLOW}${BOLD}[ WPA HANDSHAKE ]${RESET} ${WHITE}Detected activity on ${CYAN}${SSID}${RESET}"
  sleep 0.6
  echo -e "${CYAN}[*] ${WHITE}Waiting for EAPOL packets...${RESET}"
  sleep 0.8

  for step in 1 2 3 4; do
    echo -e "${GREEN}[+] ${WHITE}EAPOL packet ${step}/4 captured (${CYAN}${BSSID}${RESET}${WHITE})"
    sleep 0.6
  done

  echo -e "${BOLD}${GREEN}[✓] WPA handshake captured!${RESET} ${WHITE}(${CYAN}${SSID}${WHITE})"
  echo -e "${DIM}[*] Saved as ${YELLOW}capture-${SSID// /_}.cap${RESET}"
  sleep 1
}

# ------------------ UI Startup ------------------
clear
echo -e "${CYAN}[*] ${WHITE}Killing conflicting processes...${RESET}"
sleep 0.8
echo -e "${GREEN}[+] ${WHITE}Monitor mode enabled on ${YELLOW}${MON}${RESET}"
sleep 1

echo -e "\n${MAGENTA}Interface\tChipset\t\tDriver${RESET}"
echo -e "${WHITE}${MON}\tRTL8812AU\taircrack-ng${RESET}"
sleep 1.2

print_ap_header

# ------------------ Main Loop ------------------
while true; do
  for BAND in "2.4GHz" "5GHz"; do
    [[ "$BAND" == "2.4GHz" ]] && CHANNELS=("${CHANNELS_24[@]}") || CHANNELS=("${CHANNELS_5[@]}")

    for CH in "${CHANNELS[@]}"; do
      echo -ne "${CYAN}[*] ${WHITE}Hopping to channel ${YELLOW}${CH}${WHITE} (${BAND})...\r${RESET}"
      sleep $HOP_DELAY

      AP_COUNT=$((RANDOM % 3 + 2))
      BSSIDS=()
      AP_NAMES=()

      for ((i=0; i<AP_COUNT; i++)); do
        BSSID=$(rand_mac)
        SSID=${SSIDS[RANDOM % ${#SSIDS[@]}]}
        ENC=${ENCRYPTION[RANDOM % ${#ENCRYPTION[@]}]}
        PWR=$((RANDOM % 40 - 90))

        BSSIDS+=("$BSSID")
        AP_NAMES+=("$SSID")

        printf "${CYAN}%-3s ${RED}%4s ${GREEN}%-18s ${YELLOW}%-7s ${BLUE}%s${RESET}\n" \
          "$CH" "$PWR" "$BSSID" "$ENC" "$SSID"
      done

      # -------- Stations --------
      if $SHOW_STATIONS; then
        print_station_header
        STATION_COUNT=$((RANDOM % 4 + 1))

        for ((s=0; s<STATION_COUNT; s++)); do
          STATION=$(rand_mac)
          IDX=$((RANDOM % ${#BSSIDS[@]}))
          AP=${BSSIDS[$IDX]}
          PWR=$((RANDOM % 30 - 80))
          RATE="${RANDOM%300}e-${RANDOM%300}e"
          LOST=$((RANDOM % 10))
          FRAMES=$((RANDOM % 500 + 20))

          printf "${MAGENTA}%-18s ${RED}%4s  ${CYAN}%-7s ${GREEN}%-5s ${YELLOW}%-7s ${BLUE}%s${RESET}\n" \
            "$STATION" "$PWR" "$RATE" "$LOST" "$FRAMES" "$AP"
        done
      fi

      # -------- Handshake --------
      if $SHOW_HANDSHAKE && (( RANDOM % 4 == 0 )); then
        IDX=$((RANDOM % ${#BSSIDS[@]}))
        handshake_animation "${BSSIDS[$IDX]}" "${AP_NAMES[$IDX]}"
      fi

      # -------- Probes --------
      if $SHOW_STATIONS && (( RANDOM % 3 == 0 )); then
        echo -e "${DIM}STATION ${CYAN}$(rand_mac) ${WHITE}probing for ${YELLOW}${PROBES[RANDOM % ${#PROBES[@]}]}${RESET}"
      fi

      sleep 1.2
      echo
    done
  done
done
