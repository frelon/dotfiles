set -x EDITOR 'nvim'
set -x GOPATH '/home/frelon/go'
set -x PATH $PATH $GOPATH/bin '/home/frelon/.local/bin'
set -x GO111MODULE on
set -x GPG_TTY (tty)
set -x DOCKERFILES_REPO_PATH '/home/frelon/src/dockerfiles'
set -x DOTFILES_REPO_PATH '/home/frelon/src/dotfiles'
set -x NVIM_CONFIG '/home/frelon/.config/nvim/init.vim'

set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
echo "UPDATESTARTUPTTY" | gpg-connect-agent > /dev/null 2>&1

