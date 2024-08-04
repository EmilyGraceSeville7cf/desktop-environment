#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/message.fish
source ~/Documents/open-source/fish/gui-menus/utils/wait.fish

set expression (gum input \
    --header="$(color '❓ Math expression in ' $default_color)$(color 'Fish language' $identifier_color)$(color ': ' $default_color)" \
    --prompt="🔑 " \
    --placeholder="Expression...")

if test $status -eq 0
    set temp (mktemp)
    set result (math "$expression" 2> $temp)

    test $status -ne 0 && begin
        message "The math expression is incorrect: $(sed --quiet 1p $temp |
            string replace --regex '^math: Error: ' '')"
        wait_keypress
        exit
    end
    message "$expression = $result (copied to the clipboard)"
    echo $result | fish_clipboard_copy
    wait_keypress
else
    message "The math expression calculation has been cancelled."
    wait_keypress
end
