#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/message.fish

set application_names
set application_files

for desktop_file in /usr/share/applications/*.desktop
    desktop-file-validate $desktop_file >/dev/null || continue

    set --append application_names "$(cat $desktop_file |
        string match --regex '^Name=' --entire |
        string replace --regex '^Name=' '')"
    set --append application_files "$desktop_file"
end

set application (string join \n $application_names |
    gum filter \
        --header=(hint "desktop application") \
        --height=6 \
        --prompt="🖊️   " \
        --indicator="✅ " \
        --placeholder='Application...')

if test $status -eq 0
    set index (contains --index $application $application_names)
    set application_color brgreen
    set default_color brmagenta

    gum spin \
        --spinner=minidot \
        --title "$(set_color $default_color)Launching $(set_color $application_color)$application$(set_color $default_color)..." -- \
        sleep 1s

    open $application_files[$index] &>/dev/null &
    disown

    test $status -ne 0 && begin
        message "$(set_color $application_color)$application$(set_color $default_color) can't be launched."
        sleep 3s
    end
else
    message "The application launch has been cancelled."
    sleep 3s
end
