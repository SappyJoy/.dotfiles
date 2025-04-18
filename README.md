# All configs in one place

Все конфигурационные файлы находятся в репозитории [dotfiles](https://github.com/SappyJoy/.dotfiles).

Используется git bare repository. Почитать [раз](https://marcel.is/managing-dotfiles-with-git-bare-repo/), [два](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/)

Установить при помощи

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
```

Сразу получаю ошибку с fish prompt

snap установить командой

```sh
sudo snap install lsd --devmode
```

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

Сменим XDG user directories

```sh
mkdir {desktop,documents,downloads,images,public,templates,videos}
xdg-user-dirs-update
```

## TODO

- [ ] Это немного устаревшая инструкция, её нужно обновить и перевести на ангельский

---

My notes: [styopa.xyz](http://styopa.xyz)
