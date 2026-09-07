# Amberity

A lightweight, no-bullshit Android gaming client for Linux.

I got tired of BlueStacks turning into an ad-infested crypto launcher on Windows, and Waydroid is still a pain to run on desktop Nvidia GPUs. Amberity is an attempt to build a proper, native Linux player specifically for competitive mobile shooters (like *Standoff 2*) with high refresh rates and responsive mouse aiming.

Under the hood, it wraps **QEMU-KVM** with VirtIO graphics (Venus Vulkan + VirGL) and injects mouse input directly through `/dev/uinput` to keep latency under 1ms.

---

## What's the point?

* **Zero garbage:** No ads, no fake Play Store notifications, no crypto crap running in the background.
* **165 Hz & low latency:** Runs with Wayland tearing enabled (`wp_tearing_control_v1`) so your mouse doesn't feel floaty.
* **Nvidia friendly:** Works on standard proprietary Nvidia drivers without needing a second GPU for VFIO pass-through.
* **Shooter-focused controls:** Raw mouse input, separate X/Y sensitivity, crosshair overlay for snipers, and smart cursor release (hold Tab/B to buy, release to aim).
* **Stretched res:** 4:3 stretched mode (1440x1080 / 1280x960) without messing with system display configs.
* **Clean audio:** Routes game sound and mic through PipeWire directly.

---

## Architecture

```text
Amberity (Qt6 / C++20 Frontend)
   │
   ├── InputMapper ──────> Linux /dev/uinput (Raw mouse & keyboard)
   │
   └── VmManager ────────> QEMU + KVM
                             ├── CPU: Host pass-through (AVX2/SSE)
                             ├── GPU: virtio-vga-gl (Venus / VirGL)
                             ├── Audio: PipeWire
                             └── Guest: Debloated BlissOS / Android-x86
```

---

## Building

You'll need a C++20 compiler, CMake, Ninja, and Qt 6:

```bash
# Arch Linux / CachyOS
sudo pacman -S cmake ninja qt6-base qt6-declarative qemu-desktop

# Fedora
sudo dnf install cmake ninja-build qt6-qtbase-devel qt6-qtdeclarative-devel qemu-kvm

# Ubuntu / Debian
sudo apt install cmake ninja-build qt6-base-dev qt6-declarative-dev qemu-system-x86

# Build & Run
git clone https://github.com/dyagyatis/Amberity.git
cd Amberity
cmake -B build -G Ninja
cmake --build build

./build/amberity
```

---

## Status & Roadmap

The project is in active early development.

- [x] Qt 6 desktop shell with dark/amber theme (`#D69F47`)
- [x] QEMU-KVM process runner with VirtIO arguments
- [x] InputMapper core math (Aim-pan & sensitivity calculation)
- [ ] In-guest input daemon (`/dev/input/event*` bridge)
- [ ] Visual on-screen keybind dragging tool
- [ ] Auto-profile detection by game package name

---

## License

GPLv3. See [LICENSE](LICENSE) for details.
