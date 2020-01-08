# Defined in /tmp/fish.BhAgHI/kdp.fish @ line 2
function kdp --description 'alias kdp kubectl describe pod'
	kubectl describe pod $argv;
end
