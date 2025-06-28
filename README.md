<p align="center">
  <img src="assets/Q-TEAM.png" width="200">
</p>

<p align="center">
  <a href="./releases">
    <img src="https://img.shields.io/badge/RELEASES-v1.0.0-blue.svg" alt="Release">
  </a>
  &nbsp;&nbsp;&nbsp;
  <a href="https://github.com/Qteam-official/ICMPTunnel/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/LICENSE-Q T E A M-red.svg" alt="License">
  </a>
   &nbsp;&nbsp;&nbsp;
  <a href="https://t.me/Qteam_official">
    <img src="https://img.shields.io/badge/Telegram-Q T E A M-green.svg" alt="Telegram">
  </a>
</p>



---

# ICMPTunnel

**ICMPTunnel** is a proprietary binary tool developed by **Q-TEAM**.  
It demonstrates tunneling over the ICMP protocol (commonly used by ping).


---

## 🛠️ How to Use

### 📥 1. One-Line Installer ( Recommended )

Just run this command to download and start :

```bash
bash <(curl -Ls https://raw.githubusercontent.com/Qteam-official/ICMPTunnel/main/install.sh)
```

### This will:

  📦 Download the latest binary

  🎛 Ask: Client or Server mode

  🚀 Launch the selected mode with pre-set parameters

  🌐 Typical Usage (Two Machines)

  To establish the tunnel, you need two systems:
  🖥️ On the Client machine (e.g. VPS, user-side)

### When prompted, select:

  ➡️ Your choice [0/1/2]: 1

  Then enter your server’s public IP (e.g. 123.123.123.123).

###🔌 This will:

  Launch the client tunnel

  Start a SOCKS5 proxy at 127.0.0.1:1010

  You can use that proxy in apps like browsers, Telegram, etc.

  🛡️ On the Server machine (e.g. your remote VPS)

###When prompted, select:

  ➡️ Your choice [0/1/2]: 2

  This starts the server-side listener waiting for ICMP traffic from your client.

  ✅ No additional setup needed — works out-of-the-box.

###🔐 Requirements

  Ensure ICMP (ping) is allowed on both sides (no firewall blocks)

  Root is NOT required in most modern systems

  No ports need to be opened manually — it works via ICMP!

---


## 🧱 Binary Distribution

This repository contains the official binary release of **ICMPTunnel**, developed by **Q-TEAM**.

It is provided as a ready-to-use executable with no additional components.

---

## 🚫 Usage Restrictions

This binary is the **intellectual property of Q-TEAM**.

You are **not allowed** to:
- Copy or redistribute this binary
- Modify or reverse engineer it
- Use it for unauthorized or illegal purposes

without **explicit written permission** from Q-TEAM.


---


## ⚠️ Disclaimer

ICMP-based tunneling may be restricted on some networks.  
Use of this tool is limited to **legal, educational, or testing purposes in controlled environments only**.

**Q-TEAM is not responsible for any misuse of this software.**

---

© 2025 Q-TEAM. All rights reserved.
