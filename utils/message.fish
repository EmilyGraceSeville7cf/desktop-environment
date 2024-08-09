#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/colors.fish
source ~/Documents/open-source/fish/gui-menus/utils/wait.fish

function message --argument-names message
    #clear
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
    wait_keypress
    clear
end

function question --argument-names question
    #clear
    gum confirm \
        --prompt.foreground=$default_color \
        --selected.foreground=$selected_color \
        --selected.background=$default_color -- \
        $question
end

function question_with_input --argument-names question placeholder
    #clear
    gum input \
        --header=$question \
        --prompt="❓ " \
        --placeholder=$placeholder \
        --header.foreground=$default_color \
        --prompt.foreground=$selected_color
end

function hint --argument-names target
    echo "❓ $(color 'Choose the ' $default_color)$(color $target $identifier_color)$(color ' (with arrows) and press ' $default_color)$(key Enter)$(color : $default_color)"
end
