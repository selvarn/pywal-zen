**English** · [Русский](README.ru.md)

<img width="1920" height="1080" alt="demo" src="https://github.com/user-attachments/assets/3d880585-ce52-4f68-9763-ef86ebdb03d5" />

## Pywal🤝Zen
[Pywal](https://github.com/dylanaraps/pywal) colors for [Zen Browser](https://zen-browser.app). Sidebar, tabs, background and the ctrl+t popup follow your wallpaper, live, no restart

## Why?
[Pywalfox](https://github.com/Frewacom/pywalfox) works fine on firefox, but on zen nothing happens. Two reasons:
1. zen ignores firefox themes by default (`zen.theme.disable-lightweight`)
2. zen paints its ui with its own variables, the sidebar bg is the workspace gradient

This turns themes back on and points zen's variables at the pywalfox colors

| pywal     | where                              |
|-----------|------------------------------------|
| `color0`  | background (gradient with a bit of accent) |
| `color15` | text                               |
| `color10` | accent, selected tab, ctrl+t outline |

## Auto install
Needed: Zen Browser, Pywal, python3
```sh
git clone https://github.com/selvarn/pywal-zen
cd pywal-zen
./install.sh
```

The script installs the pywalfox native host (pipx or a venv), copies the css into your zen profile and sets the prefs in `user.js`. Running it again is fine.
- `--profile DIR` use a specific profile (see `about:profiles`)
- `--skip-pywalfox` skip the native host if you set it up yourself

Then:
1. install the [pywalfox addon](https://addons.mozilla.org/firefox/addon/pywalfox/)
2. restart zen

### Manual install

1. Set up the pywalfox native host ([docs](https://github.com/Frewacom/pywalfox#-installation))
2. Copy `chrome/pywal-zen.css` to `<profile>/chrome/`
3. Add `@import url("pywal-zen.css");` at the top of `<profile>/chrome/userChrome.css`
4. Copy the prefs from [`user.js`](user.js) or set them in `about:config`
5. install the [pywalfox addon](https://addons.mozilla.org/firefox/addon/pywalfox/)
6. Restart zen

## Uninstall
Remove the `@import` line and `pywal-zen.css`, reset the prefs, run `pywalfox uninstall` and remove the addon. Or just disable the pywalfox theme, the css only applies while it's on.

To recolor after changing wallpaper:
```sh
wal -i ~/Pictures/wall.png && pywalfox update
```

## Notes
The css uses zen internals (`.zen-browser-generic-background`, `--zen-main-browser-background` etc), so a zen update can break it. Open an issue if something stops getting colored.

Tested on zen 1.22b, arch + hyprland.

## license
[MIT](LICENSE)
