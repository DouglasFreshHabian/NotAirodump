# Fake Wi-Fi Monitor Mode Scanner

A **visual-only Bash script** that simulates Wi-Fi scanning in monitor mode.
Designed for **demos, tutorials, screen recordings, and presentations** — without using real wireless hardware or transmitting packets.

This tool mimics the *look and feel* of utilities like `airodump-ng`, including:

* Channel hopping on **2.4 GHz and 5 GHz**
* Fake access points (BSSID, ESSID, encryption, signal strength)
* Optional fake **client (STATION) tracking**
* Optional **WPA handshake capture animation**
* Colorized, cinematic terminal output

> ⚠️ **Demo only** — no real scanning, packet capture, deauthentication, or cracking occurs.

---

## Features

* ✅ Fake monitor mode initialization
* ✅ Realistic channel hopping (2.4 GHz / 5 GHz)
* ✅ Randomized access points with believable metadata
* ✅ Optional fake client (STATION) list
* ✅ Optional WPA handshake capture animation (visual only)
* ✅ Clean CLI flags and colorized `--help`
* ✅ Safe for recording, teaching, and live demos

---

## Usage

Make the script executable:

```bash
chmod +x fake_wifi_scan.sh
```

Run with no options (AP scan only):

```bash
./fake_wifi_scan.sh
```

Enable fake client (STATION) tracking:

```bash
./fake_wifi_scan.sh --station
```

Enable full demo mode (STATIONS + handshake animation):

```bash
./fake_wifi_scan.sh --handshake
```

Display the help menu:

```bash
./fake_wifi_scan.sh --help
```

---

## Command-Line Options

| Option         | Description                               |
| -------------- | ----------------------------------------- |
| `--station`    | Show fake client (STATION) list           |
| `--handshake`  | Show STATIONS and WPA handshake animation |
| `--help`, `-h` | Display help menu and exit                |

---

## What This Tool Does *Not* Do

This script **does not**:

* ❌ Enable real monitor mode
* ❌ Use wireless hardware
* ❌ Capture packets
* ❌ Perform deauthentication
* ❌ Crack or attack Wi-Fi networks
* ❌ Interact with the RF spectrum in any way

All output is **randomly generated and purely visual**.

---

## Use Cases

* 🎥 YouTube videos and tutorials
* 🧠 Teaching Wi-Fi concepts safely
* 🎤 Live demos and presentations
* 🖥️ Terminal B-roll footage
* 📚 Documentation screenshots

---

## Requirements

* Bash (tested with GNU Bash)
* A terminal that supports ANSI colors

No additional dependencies required.

---

## Disclaimer

This project is intended **strictly for educational, demonstration, and visual purposes**.
It does **not** perform real wireless operations and should not be used to misrepresent actual network activity.

---

## License

MIT License — feel free to fork, modify, and adapt for demos or educational content.

---

<!-- 
 _____              _       _____                        _          
|  ___| __ ___  ___| |__   |  ___|__  _ __ ___ _ __  ___(_) ___ ___ ™️
| |_ | '__/ _ \/ __| '_ \  | |_ / _ \| '__/ _ \ '_ \/ __| |/ __/ __|
|  _|| | |  __/\__ \ | | | |  _| (_) | | |  __/ | | \__ \ | (__\__ \
|_|  |_|  \___||___/_| |_| |_|  \___/|_|  \___|_| |_|___/_|\___|___/
        freshforensicsllc@tuta.com Fresh Forensics, LLC 2026 -->
