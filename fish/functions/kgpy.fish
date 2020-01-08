# Defined in - @ line 1
function kgpy --description 'alias kgpy kubectl get -o yaml (kubectl get pods -o name | fzf)'
	kubectl get -o yaml (kubectl get pods -o name | fzf) $argv;
end
