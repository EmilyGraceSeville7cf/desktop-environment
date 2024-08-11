#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/icons.fish

set favorites ~/Documents/open-source/fish/gui-menus/data/favorites.json
set favorite_names (jq --raw-output .data[].name $favorites)
set favorite_commands (jq --raw-output .data[].command $favorites)
set favorites_is_terminal (jq --raw-output '.data[] | .["is-terminal"] // false' $favorites)

set favorite_name (question_with_input_with_hints \
    "What favorite to execute?" \
    "Favorite..." \
    $favorite_names)

test $status -ne 0 && begin
    message "$cancel The favorite launch has been cancelled."
    exit
end

set index (contains --index $favorite_name $favorite_names)
loading "$loading Launching $favorite_name..." sleep 2s

if test $favorites_is_terminal[$index] = false
    eval "setsid --fork -- $favorite_commands[$index] 0<&- &>/dev/null"
else
    eval $favorite_commands[$index]
end
