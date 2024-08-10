#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/icons.fish

set favorites ~/Documents/open-source/fish/gui-menus/data/favorites.json
set favorite_names (jq --raw-output .data[].name $favorites)
set favorite_commands (jq --raw-output .data[].command $favorites)

set favorite_name (question_with_input_with_hints \
    "What favorite to execute?" \
    "Favorite..." \
    $favorite_names)

test $status -ne 0 && begin
    message "$cancel The favorite launch has been cancelled."
    exit
end

set index (contains --index $favorite_name $favorite_names)
gum spin \
    --spinner=minidot \
    --title="$(color 'Launching ' $default_color)$(color $favorite_name $identifier_color)$(color ... $default_color)" -- \
    setsid fish --command "$favorite_commands[$index]"
