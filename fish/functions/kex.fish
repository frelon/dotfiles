# Defined in - @ line 1
function kex --description 'alias kex kubectl exec -it (kubectl get pods -o name | fzf)'
	kubectl exec -it (kubectl get pods -o name | fzf) $argv;
end
