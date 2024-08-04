#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/message.fish
source ~/Documents/open-source/fish/gui-menus/utils/wait.fish

set level (gum choose --header=(hint volume) \
    --cursor="✅ " -- {0,25,50,75,100}%)

if test $status -eq 0
    amixer --device pulse sset Master $level --quiet
else
    message "The volume change has been cancelled."
    wait_keypress
end
 