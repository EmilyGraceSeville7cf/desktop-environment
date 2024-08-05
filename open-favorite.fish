#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/message.fish

set favorites ~/Documents/open-source/fish/gui-menus/data/favorites.json
set favorite_names (jq --raw-output .data[].name $favorites)
set favorite_commands (jq --raw-output .data[].command $favorites)

set favorite_name (string join \n -- $favorite_names |
    gum filter \
        --header=(hint "favorite command") \
        --height=6 \
        --prompt="🖊️   " \
        --indicator="✅ " \
        --placeholder='Command...')

if test $status -eq 0
    set index (contains --index $favorite_name $favorite_names)
    gum spin \
        --spinner=minidot \
        --title="$(color 'Launching ' $default_color)$(color $favorite_name $identifier_color)$(color ... $default_color)" -- \
        fish --command "$favorite_commands[$index]"
else
    message "The application launch has been cancelled."
end
