#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/icons.fish

set temp (mktemp)

loading "$loading Scanning for available Flatpak applications..." \
    fish \
        --command "flatpak list --columns=application,name --app |
        sed --quiet '2,\$p' > $temp"

set applications (cat $temp)

set application (question_with_input_with_hints \
    "What application to execute?" \
    "Application..." \
    (string replace --regex '^\S+\s+' '' -- $applications))

test $status -ne 0 && begin
    message "$cancel The application launch has been cancelled."
    exit
end

set id (string join \n -- $applications |
        string match --entire --regex "$application\$" |
        string replace --regex '\s+.*$' '')

loading "$loading Launching $application..." setsid flatpak run $id
