#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/colors.fish
source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish

function message --argument-names message
    gum style \
        --foreground=$selected_color \
        --border-foreground=$default_color \
        --border double \
        --align=center \
        --padding="0 1" \
        --margin="1 1" \
        --width=(math "$(tput cols) - 4") \
        --height=(math "$(tput lines) - 6") -- \
        $message
    pause
end

function key --argument-names name
    gum style --bold --foreground=$key_color --background=$key_background_color "`$name`"
end

function hint --argument-names target
    echo "❓ $(color 'Choose the ' $default_color)$(color $target $identifier_color)$(color ' (with arrows) and press ' $default_color)$(key Enter)$(color : $default_color)"
end
