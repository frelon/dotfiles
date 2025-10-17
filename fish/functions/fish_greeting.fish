function fish_greeting
    echo Hello (set_color green)(whoami)(set_color normal)@(set_color yellow)$hostname (set_color blue)(uname -r)
end
