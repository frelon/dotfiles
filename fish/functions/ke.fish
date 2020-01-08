# Defined in - @ line 1
function ke --description 'alias ke kubectl get all -o name | fzf | xargs -I % kubectl edit %'
	kubectl get all -o name | fzf | xargs -I % kubectl edit % $argv;
end
