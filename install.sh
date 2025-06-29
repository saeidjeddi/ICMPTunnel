#!/bin/bash

set -a


if [ "$EUID" -ne 0 ]; then
  echo "🛡️ Please enter your password to run as root..."
  exec sudo bash "$0" "$@"
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'
PORT=1010
REPO="Qteam-official/ICMPTunnel"
GITHUB_API="https://api.github.com/repos/$REPO/releases/latest"
BINARY_NAME="ICMPTunnel"
INSTALL_PATH="/usr/local/bin/$BINARY_NAME"
SERVICE_CLIENT="icmptunnel-client.service"
SERVICE_SERVER="icmptunnel-server.service"
MODE_FILE="/opt/icmptunnel/mode.conf"

function install_icmp() {
  while true; do
    clear
    echo
    echo -e "${CYAN}"
    echo "╭────────────────────────────────────────────────────────────╮"
    echo "│                  🚀  ICMPTunnel Installer                  │"
    echo "│                                                            │"
    echo "│      🛰  Lightweight Tunneling over ICMP Protocol          │"
    echo "│      🧠  Developed with 💙  by Q-TEAM                      │"
    echo "│      📢  Telegram: @Qteam_official                        │"
    echo "╰────────────────────────────────────────────────────────────╯"
    echo -e "${NC}"
    echo
    echo -e "${YELLOW}💡 Select mode to install:${NC}"
    echo -e "${CYAN}1)${NC} Client"
    echo -e "${CYAN}2)${NC} Server"
    read -p "➡️  Your choice [1/2]: " mode
    if [[ "$mode" == "1" || "$mode" == "2" ]]; then
      break
    else
      echo -e "${RED}❌ Invalid option. Please choose 1 or 2.${NC}"
    fi
  done

  mkdir -p /opt/icmptunnel
  echo "$mode" > "$MODE_FILE"

  if [[ "$mode" == "1" ]]; then
    read -p "🖥 Enter server IP address: " SERVER_IP
  fi

  echo -e "${CYAN}📦 Downloading latest release...${NC}"
  URL=$(curl -s $GITHUB_API | grep browser_download_url | grep "$BINARY_NAME" | cut -d '"' -f 4)

  if [[ -z "$URL" ]]; then
    echo -e "${RED}❌ Failed to fetch download URL.${NC}"
    exit 1
  fi

  TMP_BIN="/tmp/$BINARY_NAME"

  echo -e "${YELLOW}⬇️ Downloading from: $URL${NC}"
  curl -L -# -o "$TMP_BIN" "$URL"
  chmod +x "$TMP_BIN"
  mv "$TMP_BIN" "$INSTALL_PATH"

  cat <<EOF > /usr/local/bin/icmptunnel-updater.sh
#!/bin/bash
set -e
MODE_FILE="$MODE_FILE"
INSTALL_PATH="$INSTALL_PATH"
BINARY_NAME="$BINARY_NAME"
GITHUB_API="$GITHUB_API"

if [[ -f "\$MODE_FILE" ]]; then
  MODE=\$(cat "\$MODE_FILE")
else
  echo "Could not detect mode."
  exit 1
fi

SERVICE=""
[[ "\$MODE" == "1" ]] && SERVICE="$SERVICE_CLIENT"
[[ "\$MODE" == "2" ]] && SERVICE="$SERVICE_SERVER"

URL=\$(curl -s \$GITHUB_API | grep browser_download_url | grep "\$BINARY_NAME" | cut -d '"' -f 4)
TMP_BIN="/tmp/\$BINARY_NAME.new"
curl -sL "\$URL" -o "\$TMP_BIN"
chmod +x "\$TMP_BIN"
if ! cmp -s "\$TMP_BIN" "\$INSTALL_PATH"; then
  echo "Updating \$BINARY_NAME..."
  mv "\$TMP_BIN" "\$INSTALL_PATH"
  systemctl restart \$SERVICE || true
else
  rm -f "\$TMP_BIN"
fi
EOF
  chmod +x /usr/local/bin/icmptunnel-updater.sh

cat <<'EOF' > /usr/local/bin/q-icmp
if [ "$EUID" -ne 0 ]; then
  echo "🛡️ Root access required. Relaunching with sudo..."
  exec sudo bash /opt/icmptunnel/q-icmp-panel.sh
else
  bash /opt/icmptunnel/q-icmp-panel.sh
fi
EOF
  chmod +x /usr/local/bin/q-icmp

  cat <<EOF > /opt/icmptunnel/q-icmp-panel.sh
#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

MODE_FILE="$MODE_FILE"
INSTALL_PATH="$INSTALL_PATH"
if [[ -f "\$MODE_FILE" ]]; then
  MODE=\$(cat "\$MODE_FILE")
else
  echo -e "\${RED}❌ No installation mode found. Please run install.sh first.\${NC}"
  exit 1
fi

if [[ "\$MODE" == "1" ]]; then
  ACTIVE_SERVICE="$SERVICE_CLIENT"
elif [[ "\$MODE" == "2" ]]; then
  ACTIVE_SERVICE="$SERVICE_SERVER"
else
  echo -e "\${RED}❌ Invalid mode in config file.\${NC}"
  exit 1
fi
while true; do
  if systemctl is-active --quiet "\$ACTIVE_SERVICE"; then
    statusservice="RUNNING"
  else
    statusservice="STOPPED"
  fi
  clear
  echo
  echo -e "\${CYAN}"
  echo "╭──────────────────────────────────────────"
  echo "│        ⚙️  ICMPTunnel Control Panel      "
  echo -e "│        ⚙️  Status : \${GREEN}\${statusservice}\${NC}"
  echo "╰──────────────────────────────────────────"
  echo -e "\${NC}"

  echo -e "\${YELLOW}Choose an action:\${NC}"
  echo -e "  \${CYAN}1)\${NC} Start Service"
  echo -e "  \${CYAN}2)\${NC} Stop Service"
  echo -e "  \${CYAN}3)\${NC} Restart Service"
  echo -e "  \${CYAN}4)\${NC} Show Status"
  echo -e "  \${CYAN}5)\${NC} Manual Update"
  echo -e "  \${CYAN}6)\${NC} Uninstall Everything"
  echo -e "  \${CYAN}0)\${NC} Exit"
  echo
  read -p "➡️ Your choice: " choice

  case \$choice in
    1) systemctl start \$ACTIVE_SERVICE || true ;;
    2) systemctl stop \$ACTIVE_SERVICE || true ;;
    3) systemctl restart \$ACTIVE_SERVICE || true ;;
    4) systemctl status \$ACTIVE_SERVICE || true ;;
    5) /usr/local/bin/icmptunnel-updater.sh ;;
    6)
      echo -e "\${RED}⚠️ This will remove everything related to ICMPTunnel!\${NC}"
      read -p "Are you sure? (yes/no): " confirm
      if [[ "\$confirm" == "yes" ]]; then
        systemctl stop \$ACTIVE_SERVICE || true
        systemctl disable \$ACTIVE_SERVICE || true
        systemctl stop icmptunnel-updater.timer || true
        systemctl disable icmptunnel-updater.timer || true
        rm -f /etc/systemd/system/\$ACTIVE_SERVICE
        rm -f /etc/systemd/system/icmptunnel-updater.service
        rm -f /etc/systemd/system/icmptunnel-updater.timer
        rm -f \$INSTALL_PATH
        rm -f /usr/local/bin/icmptunnel-updater.sh
        rm -f /usr/local/bin/q-icmp
        rm -rf /opt/icmptunnel
        systemctl daemon-reload
        echo -e "\${GREEN}✅ ICMPTunnel completely removed.\${NC}"
      else
        echo "❌ Cancelled."
      fi
      ;;
    0)
      echo "👋 Bye!"
      exit 0
      ;;
    *) echo -e "\${RED}❌ Invalid choice\${NC}" ;;
  esac 
done
EOF
  if [[ "$mode" == "1" ]]; then
      
      PIDS=$(timeout 2s lsof -ti tcp:$PORT 2>/dev/null)

      if [ -n "$PIDS" ]; then
        kill -9 $PIDS
      else
        echo "✅ Port $PORT is not in use."
      fi

      if timeout 2s pgrep -x "$BINARY_NAME" > /dev/null; then
        pkill -9 "$BINARY_NAME"
      else
        echo "✅ No running process named '$BINARY_NAME'."
      fi


    
    cat <<EOF > "/etc/systemd/system/$SERVICE_CLIENT"
[Unit]
Description=ICMPTunnel Client Mode
After=network.target

[Service]
ExecStart=$INSTALL_PATH -type client -l :1010 -s $SERVER_IP -tcp_gz 1024 -sock5 1
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
    systemctl enable $SERVICE_CLIENT
    systemctl start $SERVICE_CLIENT
  else
    cat <<EOF > "/etc/systemd/system/$SERVICE_SERVER"
[Unit]
Description=ICMPTunnel Server Mode
After=network.target

[Service]
ExecStart=$INSTALL_PATH -type server
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
    systemctl enable $SERVICE_SERVER
    systemctl start $SERVICE_SERVER
  fi

  cat <<EOF > /etc/systemd/system/icmptunnel-updater.service
[Unit]
Description=ICMPTunnel Auto Updater

[Service]
Type=oneshot
ExecStart=/usr/local/bin/icmptunnel-updater.sh
EOF

  cat <<EOF > /etc/systemd/system/icmptunnel-updater.timer
[Unit]
Description=Run ICMPTunnel updater hourly

[Timer]
OnBootSec=2min
OnUnitActiveSec=1h
Persistent=true

[Install]
WantedBy=timers.target
EOF

  systemctl daemon-reexec
  systemctl daemon-reload
  systemctl enable icmptunnel-updater.timer
  systemctl start icmptunnel-updater.timer
  clear
  echo -e "${GREEN}✅ Installation complete!${NC}"
  echo -e "${CYAN}🛠 You can manage with command: ${YELLOW}q-icmp${NC}"
  clear
  sudo q-icmp
}

install_icmp
