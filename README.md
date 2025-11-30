# PulseAudio Sink Switcher

This shell script toggles between available audio output devices (sinks) using `pactl`. The script moves existing audio streams to the newly selected device and displays a desktop notification via `notify-send`.

This script works with both pure PulseAudio and PipeWire environments that provide `pactl`.

## Prerequisites

Ensure the following command-line utilities are installed:

*   **`pulseaudio-utils`**: Provides `pactl`.
*   **`libnotify-bin`** (or equivalent): Provides `notify-send`.

Installation commands for common distributions:

```bash
# Debian/Ubuntu/Mint
sudo apt install pulseaudio-utils libnotify-bin

# Fedora
sudo dnf install pulseaudio-utils libnotify

# Arch/Manjaro
sudo pacman -S pulseaudio-utils libnotify
```

Add keybinds to your i3-wm
```
# Using media keys (adjust key names based on 'xev' output)
bindsym XF86AudioOutput exec /usr/local/bin/audio-device-toggle.sh
# Or custom key binding to switch audio output device
bindsym Mod4+A exec /usr/local/bin/audio-device-toggle.sh
```