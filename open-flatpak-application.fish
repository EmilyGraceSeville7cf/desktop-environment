#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/message.fish
source ~/Documents/open-source/fish/gui-menus/utils/wait.fish

set temp (mktemp)
gum spin \
    --spinner=minidot \
    --title.foreground=$default_color \
    --spinner.foreground=$selected_color \
    --title "Scanning for available Flatpak applications..." -- \
    fish --command "flatpak list --columns=application,name --app |
        sed --quiet '2,\$p' > $temp"

set applications (cat $temp)

set application (string join \n -- $applications |
    string replace --regex '^\S+\s+' '' |
    gum filter \
        --header=(hint "Flatpac application") \
        --height=6 \
        --prompt="🖊️   " \
        --indicator="✅ " \
        --placeholder='Application...')

if test $status -eq 0
    set id (string join \n -- $applications |
        string match --entire --regex "$application\$" |
        string replace --regex '\s+.*$' '')

    gum spin \
        --spinner=minidot \
        --title="$(color 'Launching ' $default_color)$(color $application $identifier_color)$(color ... $default_color)" -- \
        flatpak run $id
else
    message "The application launch has been cancelled."
    wait_keypress
end
