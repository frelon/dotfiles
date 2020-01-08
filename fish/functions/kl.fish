# Defined in /tmp/fish.dyWLmy/kl.fish @ line 2
function kl --description 'alias kl kubectl logs (kubectl get pods -o name | fzf)'
	kubectl logs $argv;
end
