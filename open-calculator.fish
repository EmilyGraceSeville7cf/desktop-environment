#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish

set expression (question_with_input "Math expression in Fish language:" "e.g. 2 + 4")

test $status -ne 0 && begin
    message "The math expression calculation has been cancelled."
    exit
end

set temp (mktemp)
set result (math "$expression" 2> $temp)

test $status -ne 0 && begin
    message "The math expression is incorrect: $(sed --quiet 1p $temp |
            string replace --regex '^math: Error: ' '')"
    exit
end

echo -n $result | fish_clipboard_copy
message "$expression = $result (copied to the clipboard)"
