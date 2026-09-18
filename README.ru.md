[English](README.md) · **Русский**

<img width="1920" height="1080" alt="demo" src="https://github.com/user-attachments/assets/3d880585-ce52-4f68-9763-ef86ebdb03d5" />

## Pywal🤝Zen
Цвета [Pywal](https://github.com/dylanaraps/pywal) для [Zen Browser](https://zen-browser.app). Сайдбар, вкладки, фон и строка поиска меняются вместе с обоями, сразу, без перезапуска

## Зачем?
[Pywalfox](https://github.com/Frewacom/pywalfox) нормально работает в firefox, а в zen ничего не меняется. Причины две:
1. zen по умолчанию игнорирует firefox темы (`zen.theme.disable-lightweight`)
2. zen красит интерфейс своими переменными, фон сайдбара это градиент воркспейса

Тут темы включаются обратно, а переменные zen берут цвета из pywalfox

| pywal     | куда                               |
|-----------|------------------------------------|
| `color0`  | фон (градиент с чуть-чуть акцента) |
| `color15` | текст                              |
| `color10` | акцент, активная вкладка, обводка ctrl+t |

### Автоматическая установка
Требуеться: Zen Browser, Pywal, python3
```sh
git clone https://github.com/selvarn/pywal-zen
cd pywal-zen
./install.sh
```

Скрипт ставит нативную часть pywalfox (через pipx или venv), кидает css в профиль zen и прописывает настройки в `user.js`. Можно запускать повторно.
- `--profile DIR` указать профиль руками (см. `about:profiles`)
- `--skip-pywalfox` не ставить нативную часть, если она уже настроена

После:
1. Установить [расширение pywalfox](https://addons.mozilla.org/firefox/addon/pywalfox/)
2. Перезапустить Zen
### Ручная установка:
1. Установить нативную часть pywalfox ([доки](https://github.com/Frewacom/pywalfox#-installation))
2. Скопировать `chrome/pywal-zen.css` в `<профиль>/chrome/`
3. Добавить `@import url("pywal-zen.css");` в самое начало `<профиль>/chrome/userChrome.css`
4. Перенести настройки из [`user.js`](user.js) или выстави их в `about:config`
5. Установить [расширение pywalfox](https://addons.mozilla.org/firefox/addon/pywalfox/)
6. Перезапустить Zen

Перекрасить после смены обоев:
```sh
wal -i ~/Pictures/wall.png && pywalfox update
```

## Удаление
Убери строку `@import` и `pywal-zen.css`, сбрось настройки, `pywalfox uninstall` и удали расширение. Или просто выключи тему pywalfox, css работает только когда она включена.

## Заметки
CSS завязан на внутренности zen (`.zen-browser-generic-background`, `--zen-main-browser-background` и тд), так что обнова zen может что-то сломать. Если что-то перестало краситься, кидай issue.

Проверено на zen 1.22b, arch + hyprland.
## лицензия
[MIT](LICENSE)
