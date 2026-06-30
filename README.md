<p align="center">
  <img src="kiro.jpg" alt="Kiro" width="220" />
</p>

# kiro-leftwm

A ready-to-run [LeftWM](https://github.com/leftwm/leftwm) setup for Arch / Kiro — the tiling window manager written in Rust, pre-configured with a polybar bar, keybindings, a rofi launcher and a theme so it works the moment you log in. Part of the `~/EDU/` learning series.

LeftWM keeps its configuration as plain text under `~/.config/leftwm/`, so everything here is yours to read and change.

## What this repo ships

Everything lands in `etc/skel/`, so a fresh user account gets a complete LeftWM desktop:

- **`.config/leftwm/config.ron`** — the main config: Super as the mod key, 9 tags, sloppy focus, and the keybindings below. Single hand-maintained source (QWERTY). On a Belgian/AZERTY layout the 9 tag keys are remapped in place by `scripts/set-keyboard-layout.sh` (auto-detected on theme load); force it with `.bin/give-me-azerty-be-leftwm`.
- **candy theme** (`.config/leftwm/themes/candy`, the active theme) — a polybar bar (clock, CPU, memory, kernel, system tray), feh wallpaper, the `fastcompmgr` compositor.
- **`.config/leftwm/sxhkd/sxhkdrc`** — extra keybindings handled by sxhkd: function-key app launchers, volume / brightness / media keys, screenshots, and wallpaper control.
- **rofi launcher** (`.config/leftwm/launcher/`) — the application menu.
- **`.config/leftwm/themes.toml`** + **`scripts/`** — a registry of LeftWM community and ArcoLinux themes, with helper scripts to install and test them.
- **`.config/leftwm/cheatsheet.md`** — the keybinding reference.

## Key bindings

| Keys | Action |
|------|--------|
| Super + Return / Super + t | terminal (alacritty) |
| Super + d | application launcher (rofi) |
| Super + Shift + d | dmenu |
| Super + Shift + Return | file manager (thunar) |
| Super + q | close focused window |
| Super + Space | next layout |
| Super + 1..9 | go to tag |
| Super + Shift + 1..9 | move window to tag |
| Super + f | toggle fullscreen |
| Super + Shift + r | reload the config |
| Super + g | toggle the compositor |
| Super + Ctrl + s | searchable keybindings cheatsheet (kiro-keybindings) |
| Super + x | logout menu (archlinux-logout) |
| Ctrl + Alt + e | archlinux-tweak-tool |

Full list: [`cheatsheet.md`](etc/skel/.config/leftwm/cheatsheet.md) and the `sxhkdrc`.

## Installation

### From `nemesis_repo` (recommended)

Add the repo to `/etc/pacman.conf`:

```ini
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/$repo/$arch
```

Then install LeftWM and this config:

```bash
sudo pacman -Syu
sudo pacman -S kiro-leftwm leftwm
```

The package drops its files into `/etc/skel/`. New user accounts created afterwards inherit the config automatically; an existing user can pull it in with:

```bash
cp -rT /etc/skel ~/
```

Log out and pick **LeftWM** from your display manager's session list.

### Manual

```bash
sudo pacman -S leftwm
git clone https://github.com/kirodubes/kiro-leftwm.git
cd kiro-leftwm
# system-wide, for new accounts:
sudo cp -r etc/skel/. /etc/skel/
# or straight into your own home:
cp -r etc/skel/. ~/
```

### Runtime dependencies

The config calls common Arch / Kiro tools — install whatever you are missing: `polybar`, `sxhkd`, `rofi`, `feh`, `fastcompmgr`, `dmenu`, `alacritty`, `thunar`, `archlinux-logout`, `variety`. On Kiro these are already present.

## Websites

Information : https://kiroproject.be

## Social Media

Youtube : https://www.youtube.com/erikdubois

<!-- KIRO-FUNDING-FOOTER:START — managed by Kiro-HQ/cascade-readme-footer.sh -->
## Help fund Kiro

Everything I build here stays free and open — always. If Kiro or any of these
tools have ever saved you time or taught you something, a small monthly
contribution helps keep the work going. Donations target break-even, nothing
more — the core always stays free for everyone.

- GitHub Sponsors: https://github.com/sponsors/erikdubois
- Patreon: https://www.patreon.com/c/kiroproject
- YouTube memberships: https://www.youtube.com/@ErikDubois/join
- Ko-fi: https://ko-fi.com/erikdubois
- PayPal: https://www.paypal.me/erikdubois
<!-- KIRO-FUNDING-FOOTER:END -->

## License

See [LICENSE](./LICENSE).
