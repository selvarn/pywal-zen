# pywal-zen

[Pywal](https://github.com/dylanaraps/pywal) colors for [Zen Browser](https://zen-browser.app). Sidebar, tabs, background and the ctrl+t popup follow your wallpaper, live, no restart.

[на русском](README.ru.md)

![preview](images/screenshot.png)

## why

[Pywalfox](https://github.com/Frewacom/pywalfox) works fine on firefox, but on zen nothing happens. Two reasons:

1. zen ignores firefox themes by default (`zen.theme.disable-lightweight`)
2. zen paints its ui with its own variables, the sidebar bg is the workspace gradient

This turns themes back on and points zen's variables at the pywalfox colors.

| pywal     | where                              |
|-----------|------------------------------------|
| `color0`  | background (gradient with a bit of accent) |
| `color15` | text                               |
| `color10` | accent, selected tab, ctrl+t outline |

## install

You need zen, pywal and python 3.

```sh
git clone https://github.com/selvarn/pywal-zen
cd pywal-zen
./install.sh
```

The script installs the pywalfox native host (pipx or a venv), copies the css into your zen profile and sets the prefs in `user.js`. Running it again is fine.

- `--profile DIR` use a specific profile (see `about:profiles`)
- `--skip-pywalfox` skip the native host if you set it up yourself

Then:

1. restart zen
2. install the [pywalfox addon](https://addons.mozilla.org/firefox/addon/pywalfox/)
3. click the pywalfox icon, hit **Fetch Pywal colors**

To recolor after changing wallpaper:

```sh
wal -i ~/Pictures/wall.png && pywalfox update
```

### manual

1. set up the pywalfox native host ([docs](https://github.com/Frewacom/pywalfox#-installation))
2. copy `chrome/pywal-zen.css` to `<profile>/chrome/`
3. add `@import url("pywal-zen.css");` at the top of `<profile>/chrome/userChrome.css`
4. copy the prefs from [`user.js`](user.js) or set them in `about:config`
5. restart zen

## uninstall

Remove the `@import` line and `pywal-zen.css`, reset the prefs, run `pywalfox uninstall` and remove the addon. Or just disable the pywalfox theme, the css only applies while it's on.

## notes

The css uses zen internals (`.zen-browser-generic-background`, `--zen-main-browser-background` etc), so a zen update can break it. Open an issue if something stops getting colored.

Tested on zen 1.22b, arch + hyprland.

## license

[MIT](LICENSE)
