# 2048 Plus

A feature-packed, cross-platform implementation of the classic puzzle game 2048, built using the LÖVE framework. 

This project originally started as a dedicated console port for the **muOS** handheld system. It has since been adapted, enhanced, and refactored into a standalone release for desktop computers, compiling natively for **Linux** (AppImage) and **Windows** (64-bit portable package).

This project is inspired by and references the popular open-source [2048 Android](https://github.com/tpcstld/2048) game by tpcstld, which itself is based on the original web game by Gabriele Cirulli. While taking visual and design references from the Android version, this codebase was written from the ground up in Lua. In addition to the classic gameplay, it features multiple game modes, an achievement system, and a wide variety of themes to enhance the experience.

---

## Features

- **Game Selection Mode**: A beautifully animated carousel menu screen for seamlessly selecting between Classic, Plus, and Arcade modes.
- **Classic & Plus Modes**: Enjoy the original 2048 puzzle experience, or switch to the new Plus Mode which introduces strategic powerups!
- **Plus Mode Powerups**: In Plus Mode, earn Bomb, Swap, and Undo powerups by reaching new tile milestones (128, 256, 512, etc.). Use them to destroy unwanted tiles, swap adjacent tiles, or revert mistakes.
- **Arcade Modes**: Choose from 4 unique game modes — each with its own rules, challenges, and exclusive unlockable themes:
  - **Time Attack**: Race against a 60-second countdown clock. Merge larger tiles (32+) to earn time extensions.
  - **Huge Mode (5x5)**: A spacious 5×5 grid for a more relaxed play style.
  - **No Mercy**: Hardcore mode — no undos, no powerups, two tiles spawn every move.
  - **Goose Mode**: A chaotic mode where a silly Goose tile waddles around the board, blocking random cells.
- **Procedural Sound Effects**: Rich chiptune audio effects generated dynamically with zero file size overhead.
- **Unified Settings Menu**: Customize preferences inside a clean Settings sub-menu:
  - **Sound**: Toggle audio effects on/off.
  - **Text Size**: Toggle menu layout size (Normal / Large).
  - **Gameplay Animation Speed**: Choose between Slow (0.24s), Normal (0.12s), Fast (0.06s), or Instant (0s).
  - **Transitions**: Toggle slide animations on/off.
  - **Undo Limit**: Adjust undo limitations (1-Move, Unlimited, or Disabled) to customize your strategic difficulty.
  - **Time Attack Max Limit**: Adjust the Time Attack starting and maximum threshold ceiling (30s, 60s, 90s).
  - **Vibration**: Toggle controller rumble feedback on supported gamepads.
  - **CRT Shader**: Toggle retro curved screen curvature, scanline, and phosphor mask post-processing filters.
  - **Control Hints**: Configure help badges (Auto, Gamepad, or Keyboard).
- **Advanced Undo History Stack**: Revert mistakes with backward history logs going up to 100 consecutive turns.
- **Achievements & Unlockable Themes**: Track your progress by unlocking 23 unique achievements. Completing achievements rewards you with beautifully crafted custom themes — 25 themes total!
- **Statistics Dashboard**: Tracks real-time statistics including highest score, highest tile reached, games started per mode, total play time, moves, merges, undos, and power-up usage.
- **Dynamic Animated Backgrounds**: Premium themes (Aurora, Nebula, Inferno, Honk, Matrix, Glitch) feature layered, animated background effects like aurora curtains, twinkling starfields, rising embers, water ripples, falling green digital rain, and cyberpunk glitch effects.
- **Auto-Save & Resume**: Progress, board state, and score are saved automatically after every move. You can safely close the game and pick up right where you left off.
- **Standard System Directories**: Saves game progression, settings, and high scores securely in standard system directories:
  - **Linux**: `~/.local/share/love/2048plus/`
  - **Windows**: `%APPDATA%\LOVE\2048plus\`

---

## Controls

The game supports both desktop keyboard play and gamepad input with dynamic on-screen help prompt shifting.

| Action | Keyboard Key | Gamepad Button |
|:---|:---|:---|
| **Move Tiles** | Arrow Keys / WASD | D-Pad / Left Stick |
| **Select / Confirm** | `Enter` | `A` |
| **Back / Cancel** | `Backspace` | `B` |
| **Undo Move** | `Backspace` | `B` |
| **Switch Theme** | `Y` | `Y` |
| **Activate Swap Powerup (Plus Mode)** | `Q` (or `Z`) | `L1` |
| **Activate Bomb Powerup (Plus Mode)** | `E` (or `C` / `X`) | `R1` / `X` |
| **Switch Tab (Achievements Menu)** | `Q` / `E` | `L1` / `R1` |
| **Pause / Resume Menu** | `Space` | `Start` / `Select` |
| **Toggle Fullscreen** | `F11` | — |
| **Force Quit App** | `Escape` | `Menu + Start` |

---

## Building from Source

To compile the executable packages yourself, run `build.sh` in a Linux environment with `bash`, `zip`, `unzip`, and `curl`/`wget` installed.

*Note: If you have `wine` and python `Pillow` library installed on your host, the script will automatically patch the Windows `.exe` executable with the custom 2048 logo icon; otherwise, it will fall back to the default LÖVE icon.*

1. Clone this repository:
   ```bash
   git clone https://github.com/saitamasahil/2048-love2d.git
   cd 2048-love2d
   ```

2. Run the build script:
   ```bash
   bash build.sh
   ```

The script packages the source directory, pulls the respective LÖVE packages, and outputs the platform distributions inside the `build/` directory:
- **Linux AppImage**: `build/2048_Plus-x86_64.AppImage`
- **Windows Package**: `build/2048_Plus-win64.zip`

---

## Credits & Acknowledgements

- Original Concept By: [Gabriele Cirulli](https://github.com/gabrielecirulli/2048)
- Android Port Reference: [tpcstld - 2048](https://github.com/tpcstld/2048)
- Built using the [LÖVE Framework](https://love2d.org/)

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

### Third-Party Licenses

- **LÖVE Framework**: Licensed under the zlib License (see `love_license.txt` in the Windows release or `license.txt` inside the Linux AppImage).
- **Clear Sans Font**: Licensed under the Apache License, Version 2.0 (see `ClearSans_LICENSE.txt`).
