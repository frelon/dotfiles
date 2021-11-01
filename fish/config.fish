set -x EDITOR 'nvim'
set -x GOPATH '/home/frelon/go'
set -x PATH $PATH $GOPATH/bin '/home/frelon/.local/bin'
set -x PATH $PATH '/home/frelon/.cargo/bin'
set -x PATH $PATH /usr/local/go/bin

set -x GO111MODULE on
set -x GPG_TTY (tty)
set -x COMPOSE_ENV_PATH '/home/frelon/src/dev-env'
set -x DOTFILES_REPO_PATH '/home/frelon/src/dotfiles'
set -x NVIM_CONFIG '/home/frelon/.config/nvim/init.vim'
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
echo "UPDATESTARTUPTTY" | gpg-connect-agent > /dev/null 2>&1

alias git-delete-merged "git branch --merged | egrep -v \"(^\*|master|develop|stage|main)\" | xargs git branch -d"
alias t "sudo /home/frelon/src/xdp-tutorial/testenv/testenv.sh"
