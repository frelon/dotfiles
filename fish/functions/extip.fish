# Defined in /tmp/fish.AEwUeK/extip.fish @ line 2
function extip
    curl -s dyndns.loopia.se/checkip | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])'
end
