#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/icons.fish
source ~/Documents/open-source/fish/gui-menus/utils/common_options.fish
source ~/Documents/open-source/fish/gui-menus/utils/emoji.fish

set favorites ~/Documents/open-source/fish/gui-menus/settings/data/favorites.yaml
set favorite_names (yq $yq_options .[].name $favorites)
set favorite_icons (yq $yq_options .[].icon $favorites)
set favorite_commands (yq $yq_options .[].command $favorites)
set favorites_is_terminal (yq $yq_options '.[] | .["is-terminal"] // false' $favorites)

set displayed_favorites

for index in (seq (count $favorite_names))
    set displayed_favorites $displayed_favorites "$favorite_icons[$index] $favorite_names[$index]"
end

set favorite_name (question_with_input_with_hints \
    "What favorite to execute?" \
    "Favorite..." \
    $displayed_favorites)

test $status -ne 0 && begin
    message "$cancel The favorite launch has been cancelled."
    exit
end

set favorite_name (remove_emoji $favorite_name | string replace --regex '^\s*' '')
set index (contains --index $favorite_name $favorite_names)
loading "$loading Launching $favorite_name..." sleep 2s

if test $favorites_is_terminal[$index] = false
    eval "setsid --fork -- $favorite_commands[$index] 0<&- &>/dev/null"
else
    eval $favorite_commands[$index]
end
