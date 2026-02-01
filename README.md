<p align="center">
  <img src="images/cam_phish_by_uzair.png" width="400" alt="X Cam">
</p>

<h1 align="center">X Cam</h1>
<p align="center">
  <strong>Webcam + GPS capture — just send a link</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Version-3.0-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20Termux%20%7C%20macOS-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-GPL-blue?style=for-the-badge" />
</p>

<p align="center">
  <strong>Created by Infinity x White Devels Team</strong>
</p>

---

## 🎯 What is X Cam?

**X Cam** is a penetration testing tool that captures **webcam photos** and **GPS location** from a target's device by sending them a single link. The target opens the link, grants camera/location permission, and the data is captured in real-time.

Unlike complex setups, X Cam uses:
- **Built-in PHP server** — no Apache/Nginx needed
- **Free tunnels** (Serveo & localhost.run) — no ngrok account
- **Interactive CLI** — X Cam interface, easy to use

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📷 **Webcam Capture** | Takes periodic snapshots from front camera (phone) or webcam (PC) |
| 📍 **GPS Location** | Captures coordinates + Google Maps link |
| 🌐 **IP & User-Agent** | Logs visitor IP and browser info |
| 🎭 **3 Phishing Templates** | Festival Wishes (Indian/Islamic), Live YouTube TV, Online Meeting |
| 🔗 **Inline Links** | Link displayed as "Join meeting: https://..." or "Celebrate [festival]: https://..." based on template |
| 📋 **Share File** | Saves inline link to share.txt for easy copy-paste |
| 🧹 **Cleanup Script** | Remove logs and captures with one command |

---

## 📸 Screenshots

```
  +----------------------------------------------------------------------+
  |   \ \  / \ \  /     ____    _    __  __                              |
  |    \ \/   \ \/     / ___|  / \  |  \/  |                             |
  |     \     /       | |     / _ \ | |\/| |                             |
  |    / \   / \      | |___ / ___ \| |  | |                             |
  |   /_/\_\ /_/\_\    \____/_/   \_\_|  |_|                             |
  |    [Infinity x White Devels Team]                                    |
  |    Webcam + GPS Capture via Link • v3.0                              |
  |    https://github.com/Adil-fayyaz/camphish-x                         |
  +----------------------------------------------------------------------+
```

---

## 🚀 Installation

### Method 1: One-Command Install (Recommended)

```bash
git clone https://github.com/Adil-fayyaz/camphish-x.git
cd camphish-x
bash install.sh
bash camphish.sh
```

### Method 2: Manual Install

```bash
# Clone
git clone https://github.com/Adil-fayyaz/camphish-x.git
cd camphish-x

# Install dependencies (Debian/Ubuntu/Kali)
sudo apt update && sudo apt install -y php ssh

# Termux
pkg install php openssh

# Run
chmod +x camphish.sh cleanup.sh install.sh
bash camphish.sh
```

---

## 📖 Usage

1. **Run X Cam**
   ```bash
   bash camphish.sh
   ```

2. **Choose tunnel** — Serveo (fast) or localhost.run (backup)

3. **Choose template**
   - **Festival Wishing** — Indian or Islamic style, enter festival name (e.g. Eid, Diwali)
   - **Live YouTube TV** — Enter a YouTube video ID
   - **Online Meeting** — Fake video call interface

4. **Send the link** — Copy the generated URL and send it to your target

5. **Wait for data** — IP, location, and camera images appear in real-time

---

## 📁 Output Files

| File/Folder | Content |
|-------------|---------|
| `cam*.png` | Captured webcam images |
| `saved_locations/` | GPS coordinates + Google Maps links |
| `saved.ip.txt` | All captured IPs and User-Agents |

---

## 🧹 Cleanup

Remove all logs and captured data:

```bash
bash cleanup.sh
```

---

## ⚠️ Supported Platforms

- ✅ Kali Linux
- ✅ Ubuntu / Debian
- ✅ Parrot Sec OS
- ✅ Termux (Android)
- ✅ macOS
- ✅ Windows (WSL only — native Windows shows a friendly message)

---

## ⚠️ Legal Disclaimer

**This tool is for educational and authorized security testing only.**

- Use only on systems/users you have **explicit permission** to test
- Unauthorized access to devices/cameras is **illegal** in most jurisdictions
- The authors are not responsible for misuse

---

## 🙏 Credits

**X Cam** — Created by **Infinity x White Devels Team**

Repository: [github.com/Adil-fayyaz/camphish-x](https://github.com/Adil-fayyaz/camphish-x)

---

## 📄 License

GNU General Public License v3.0 — see [LICENSE](LICENSE)

---

<p align="center">
  <strong>Made with ❤️ by Infinity x White Devels Team</strong>
</p>
