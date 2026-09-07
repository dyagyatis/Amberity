# Amberity ⚡

A high-performance, native Android gaming player for Linux.  
Built with **C++20** and **Qt 6 (QML)**, powered by **QEMU-KVM** with zero bloat, zero telemetry, and sub-millisecond input response.

---

## 🎨 Design & Philosophy
* **Accent Color:** Amber Gold (`#D69F47`)
* **Background:** Deep Matte Graphite (`#16171D`)
* **Target Audience:** Competitive mobile shooter players (*Standoff 2*, etc.) on 144/165+ Hz monitors.

---

## 🚀 Key Features

### 🎯 Esport & Shooter Performance
- **165 Hz Native Refresh & Frame Pacing:** Direct Wayland tearing support (`wp_tearing_control_v1`) for zero V-Sync input lag.
- **Raw Input & Separate X/Y Sensitivity:** Zero mouse acceleration, true 1:1 hardware translation, independent horizontal and vertical sensitivity.
- **Customizable Crosshair Overlay:** Built-in static dot/crosshair in `#D69F47` for no-scope snipers and quick aiming.
- **Smart Aim / Auto-Unlock Cursor:** Automatic cursor release when holding `Tab`, `B` (buy menu), or `M` (map), with immediate snap-back to shooting mode upon release.
- **Stretched Resolution (4:3 & 16:10):** Stretch FOV for wider character models without black bars.
- **Ultrawide 21:9 FOV:** Expand battlefield vision for competitive tactical advantage.

### ⚡ Graphics & Virtualization
- **Dual API Backend:** Automatic selection or manual toggle between **Vulkan (Venus)** and **OpenGL (VirGL)** via VirtIO-GPU.
- **Persistent Shader Cache:** Preloaded pipeline binary cache to eliminate first-time stutter.
- **Digital Vibrance & AMD CAS:** Built-in post-processing for color saturation and contrast-adaptive sharpening.
- **Hardware Info HUD:** Real-time overlay showing GPU/CPU temperatures, VRAM usage, and true FPS.
- **Fast-Resume Hibernation:** Save and resume state in 0.5s via RAM snapshots.
- **VRAM Leak Prevention:** Automatic background purge of stale texture atlases between rounds.

### 🛠 Quality of Life & System
- **Drag & Drop APK Installation:** Seamless `.apk` file drop into the window with real-time installation feedback.
- **Direct PipeWire Low-Latency Audio:** Pristine mic pass-through and ultra-low audio latency.
- **Shared Clipboard & Files:** Bidirectional copy-paste (`Ctrl+C` / `Ctrl+V`) and shared file directory (`~/Amberity/Shared`).
- **Clean Root Toggle:** 1-click KernelSU / Magisk switch with full evasion when disabled.
- **Streamer Privacy Mode (OBS):** Clean game canvas capture without showing the emulator UI, key hints, or settings.
- **BBR Low-Jitter Network:** Linux BBR congestion control integration for stable hit-registration and lowest ping.
- **Host CPU Pass-Through:** Full access to host CPU instructions (AVX2/SSE4) while maintaining legitimate smartphone properties.

---

## 🛠 Tech Stack

* **Language:** C++20
* **GUI Toolkit:** Qt 6 (Quick & QML)
* **Build System:** CMake (3.20+) + Ninja
* **Hypervisor:** QEMU-KVM (`virtio-vga-gl`, `virtio-net`, `virtio-blk`)
* **Input Injection:** Direct Linux `/dev/uinput` kernel bridge
* **Audio:** PipeWire native pulse/alsa backend

---

## 📦 Building & Running on Linux

### Prerequisites
Install dependencies (example for Arch Linux / CachyOS):
```bash
sudo pacman -S cmake ninja qt6-base qt6-declarative qemu-desktop
```

For Ubuntu / Debian:
```bash
sudo apt install cmake ninja-build qt6-base-dev qt6-declarative-dev qemu-system-x86
```

### Build
```bash
git clone https://github.com/dyagyatis/Amberity.git
cd Amberity

cmake -B build -G Ninja
cmake --build build

./build/amberity
```

---

## 📜 License
Licensed under the **GNU General Public License v3.0 (GPL-3.0)**.  
See [LICENSE](LICENSE) for details.
