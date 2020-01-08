# Defined in - @ line 1
function kgpw --description 'alias kgpw kubectl get pods --watch'
	kubectl get pods --watch $argv;
end
