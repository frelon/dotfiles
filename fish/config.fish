set -x EDITOR 'nvim'
set -x GOPATH '/home/frelon/go'
set -x PATH $PATH $GOPATH/bin
set -x GO111MODULE on
set -x GPG_TTY (tty)

set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
echo "UPDATESTARTUPTTY" | gpg-connect-agent > /dev/null 2>&1

