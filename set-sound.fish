#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/icons.fish

set level (question_with_input_with_hints "What sound level to choose?" "Level..." {0,25,50,75,100}%)

test $status -ne 0 && begin
    message "$cancel The sound change has been cancelled."
    exit
end

amixer --device pulse sset Master $level --quiet
