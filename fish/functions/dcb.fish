# Defined in - @ line 1
function dcb --description 'alias dcb docker-compose build --parallel'
	docker-compose build --parallel $argv;
end
