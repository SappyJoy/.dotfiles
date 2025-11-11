# All configs in one place

Все конфигурационные файлы находятся в репозитории [dotfiles](https://github.com/SappyJoy/.dotfiles).

Используется git bare repository. Почитать [раз](https://marcel.is/managing-dotfiles-with-git-bare-repo/), [два](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/)

Установить при помощи

```sh
curl -fsSL https://gist.github.com/SappyJoy/eec1274b275af7336aafdaf217dfff16/raw/setup_dotfiles.sh | bash
```

Если не работает, то скачать и попробовать запустить вручную

```sh
wget https://gist.githubusercontent.com/SappyJoy/eec1274b275af7336aafdaf217dfff16/raw/setup_dotfiles.sh
chmod +x setup_dotfiles.sh
bash setup_dotfiles.sh
```

```sh
cd ~
set -Ux DOTFILES $HOME/.dotfiles
set -Ux SECRETS $HOME/.secrets
git clone --bare git@github.com:SappyJoy/.dotfiles.git $DOTFILES
git clone --bare git@github.com:SappyJoy/.secrets.git $SECRETS
alias gitdf='git --git-dir=$DOTFILES --work-tree=$HOME'
gitdf checkout
gitdf config --local status.showUntrackedFiles no

fish # update fish config
sg checkout
sg config --local status.showUntrackedFiles no

tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Light --prompt_spacing=Compact --icons='Few icons' --transient=No
```

Все ключи у меня хранятся в `pass`. Ссылки на них хранятся в `secrets` .config/fish/private.fish

## Какие программы я использую

- X11
- i3 - менеджер окон
- i3status - статус бар
- picom - композитор
- rofi - меню
- kitty - терминал
- [fish](https://fishshell.com/) - shell
- nvim - текстовый редактор
- tmux - терминал
- [lsd](http://styopa.xyz/lsd) - ls с иконками
- ranger - файловый менеджер
- thunar - GUI файловый менеджер
- zoxide - быстрый cd
- fzf - fuzzy finder
- ripgrep - поиск по файлам
- fd - поиск файлов
- bat - cat с подсветкой
- lazygit - git интерфейс
- lazydocker - docker интерфейс
- uv - python manager
- pipxu - установщик python пакетов
- pidcat - логгер для android
- greenclip - буфер обмена
- btop - мониторинг системы
- btrfs - файловая система
- firefox - браузер
- flameshot - скриншотер
- dunst - уведомления
- obsidian - заметки (пишу в nvim)
- plocate - поиск по файлам
- wg-quick - VPN
- ly - login manager
- aider - AI помощник
- direnv - управление переменными окружения
- sdkman - менеджер версий для java/gradle


Установим плагины для tmux

```sh
tmux # запустим tmux
# <C-b>I - чтобы установить плагины
```

Установим плагины для fish
[fisher](https://github.com/jorgebucaran/fisher) - менеджер плагинов

```sh
fisher update
```

---

My notes: [styopa.xyz](http://styopa.xyz)
