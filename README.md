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

### 📥 Installer ( Recommended )

+ 1 - Just run this command to download and start :

```bash
bash <(curl -Ls https://raw.githubusercontent.com/Qteam-official/ICMPTunnel/main/install.sh)
```

+ 2 - Then type
```bash
q-icmp
```

### 📦 Offline Installation (Internet restrictions)

If you want to install ICMPTunnel without downloading from GitHub (for example, in an offline environment), follow these steps:

1. **Download the latest release binary** (`ICMPTunnel`) from the [Releases page](https://github.com/Qteam-official/ICMPTunnel/releases) using another computer with internet access.
2. **Copy** both `install.sh` and the downloaded `ICMPTunnel` binary to your target (offline) Linux machine, placing them in the same directory.
3. **Make sure both files are executable:**

```bash
chmod +x install.sh ICMPtunnel
```

4. **Run the installer:**

```bash
sudo ./install.sh
```

5. When prompted, select `2` for **Offline Installation**.
6. Follow the interactive prompts to choose Client or Server mode and complete the setup.

After installation, you can manage the tunnel using:

```bash
q-icmp
```

> **Note:** The binary file must be named exactly `ICMPTunnel` and be in the same directory as `install.sh` during installation.


---

## **🔐 Requirements 👇🏻**

# ✅ Supported Platforms ( linux/amd64 ) :
  + 🐧 Ubuntu 18.04, 20.04, 22.04 and newer
  + 🐧 Debian 10, 11, 12+
  + 🐧 Kali Linux
  + 🐧 Linux Mint
  + 🐧 Fedora
  + 🐧 CentOS / AlmaLinux / Rocky
  + 🐧 Arch Linux / Manjaro
  + 🐧 openSUSE
  + 🐧 Pop!_OS, Zorin OS, and most other modern distros

# ⚠️ Not supported on:
  + ❌ 32-bit Linux systems (i386)
  + ❌ ARM devices (like Raspberry Pi)
  + ❌ macOS or Windows
  + ℹ️ Support for other architectures (e.g. arm64, arm, windows) may be added in future releases.

# Ensure ICMP (ping) is allowed on both sides (no firewall blocks)
# Root is NOT required in most modern systems
# No ports need to be opened manually — it works via ICMP!

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
