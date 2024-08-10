#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/icons.fish

set temp (mktemp)

gum spin \
    --spinner=minidot \
    --title.foreground=$default_color \
    --spinner.foreground=$selected_color \
    --title "Scanning for available Flatpak applications..." -- \
    fish --command "flatpak list --columns=application,name --app |
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

gum spin \
    --spinner=minidot \
    --title="$(color 'Launching ' $default_color)$(color $application $identifier_color)$(color ... $default_color)" -- \
    setsid flatpak run $id
