function fish_greeting
    echo Hello (set_color green)(whoami)(set_color normal), running on (set_color blue)$hostname (set_color yellow)(uname -r)
end
