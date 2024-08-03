#!/usr/bin/env fish

set default_color "#ff33cc"
set selected_color "#ff69d9"
set identifier_color "#ff4d4d"

function color --argument-names message color
    gum style --foreground=$color $message
end

function key --argument-names name
    set key_color "#aa78ff"
    set key_background_color "#6105ff"
    gum style --bold --foreground=$key_color --background=$key_background_color "`$name`"
end
