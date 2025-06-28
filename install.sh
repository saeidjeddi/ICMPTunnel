#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo "🛡️ Please enter your password to run as root..."
  exec sudo bash "$0" "$@"
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO="Qteam-official/ICMPTunnel"
GITHUB_API="https://api.github.com/repos/$REPO/releases/latest"
BINARY_NAME="ICMPTunnel"
FILENAME="$BINARY_NAME"

clear
echo -e "${CYAN}"
echo "╭────────────────────────────────────────────────────────────╮"
echo "│                  🚀  ICMPTunnel Installer                   │"
echo "│                                                            │"
echo "│   🛰  Lightweight Tunneling over ICMP Protocol             │"
echo "│   🧠  Developed with 💙  by Q-TEAM                          │"
echo "│   📢  Telegram: @Qteam_official                            │"
echo "╰────────────────────────────────────────────────────────────╯"
echo -e "${NC}"

echo -e "${YELLOW}📦 Fetching latest release from GitHub...${NC}"
URL=$(curl -s $GITHUB_API | grep browser_download_url | grep "$BINARY_NAME" | cut -d '"' -f 4)

if [ -z "$URL" ]; then
  echo -e "${RED}❌ Failed to find download link for '$BINARY_NAME'.${NC}"
  exit 1
fi

echo -e "${CYAN}🔗 File: ${NC}$URL"

if [ -f "$FILENAME" ]; then
  PID=$(lsof -t "./$FILENAME" 2>/dev/null || true)
  if [ -n "$PID" ]; then
    echo -e "${YELLOW}⚠️ Killing previous running instance (PID: $PID)...${NC}"
    kill -9 "$PID"
    sleep 1
  fi
  echo -e "${YELLOW}🗑 Removing old binary: $FILENAME${NC}"
  rm -f "$FILENAME"
fi

echo -e "${YELLOW}⬇️ Downloading latest version...${NC}"
if command -v aria2c >/dev/null 2>&1; then
  aria2c -x 16 -s 16 "$URL" -o "$FILENAME"
else
  curl -L --retry 3 --connect-timeout 5 --max-time 60 --progress-bar -o "$FILENAME" "$URL"
fi
chmod +x "$FILENAME"

echo -e "${GREEN}✅ Downloaded and ready: $FILENAME${NC}"

while true; do
  echo
  echo -e "${YELLOW}💡 Select mode:${NC}"
  echo -e "  ${CYAN}1)${NC} Client"
  echo -e "  ${CYAN}2)${NC} Server"
  echo -e "  ${CYAN}0)${NC} Exit"
  echo
  read -p "➡️ Your choice [0/1/2]: " mode_raw
  mode=$(echo "$mode_raw" | xargs)

  if [[ "$mode" == "1" ]]; then
    read -p "🖥 Enter server IP: " ip_raw
    ip=$(echo "$ip_raw" | xargs)

    PORT=1010
    PORT_PID=$(lsof -ti tcp:$PORT 2>/dev/null || true)
    if [ -n "$PORT_PID" ]; then
      echo -e "${YELLOW}⚠️ Port $PORT is in use (PID: $PORT_PID), killing...${NC}"
      kill -9 "$PORT_PID"
      sleep 1
    fi

    echo -e "${GREEN}🚀 Starting client mode...${NC}"
    ./"$FILENAME" -type client -l :$PORT -s "$ip" -tcp_gz 1024 -sock5 1
    break

  elif [[ "$mode" == "2" ]]; then
    echo -e "${GREEN}🚀 Starting server mode...${NC}"
    echo -e "${GREEN}✅ Core started successfully ( ${RED}Server${GREEN} )${NC}"
    ./"$FILENAME" -type server
    break

  elif [[ "$mode" == "0" ]]; then
    echo -e "${YELLOW}👋 Exiting. Goodbye!${NC}"
    exit 0

  else
    echo -e "${RED}❌ Invalid option. Please try again.${NC}"
  fi
done
