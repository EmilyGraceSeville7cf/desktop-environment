#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/message.fish

set password ""

while true
    set password (gum input \
    --header="$(color '❓ Type password for ' $default_color)$(color sudo $identifier_color)$(color ': ' $default_color)" \
    --prompt="🔑 " \
    --placeholder="Password..." \
     --password)

    gum spin \
        --spinner=minidot \
        --title.foreground=$default_color \
        --spinner.foreground=$selected_color \
        --title "Checking password..." -- \
        ~/Documents/open-source/fish/gui-menus/utils/is-correct-password.fish "$password"

    test $status -eq 0 && break
    message "Password is incorrect."
end

gum spin \
    --spinner=minidot \
    --title.foreground=$default_color \
    --spinner.foreground=$selected_color \
    --title "Fetching the latest information about updates..." -- \
    sudo apt update -y

set temp (mktemp)

gum spin \
    --spinner=minidot \
    --title.foreground=$default_color \
    --spinner.foreground=$selected_color \
    --title "Scanning for available package updates..." -- \
    fish --command "NO_COLOR=1 sudo apt list --upgradable 2>/dev/null |
            sed --quiet '2,\$p' |
            string replace --regex '/.*\$' '' > $temp"

set packages (cat $temp)

if test "$packages" = ""
    message "All packages are updated."
    exit
end

set selected_packages (string join \n -- $packages |
    gum filter \
        --header=(hint "package") \
        --no-limit \
        --height=6 \
        --prompt="🖊️   " \
        --indicator="✅ " \
        --placeholder='Package...')

if test $status -eq 0
    gum spin \
        --spinner=minidot \
        --title.foreground=$default_color \
        --spinner.foreground=$selected_color \
        --title "Installing updates..." -- \
        ~/Documents/open-source/fish/gui-menus/utils/upgrade-apt-packages.fish "$password" $selected_packages
else
    message "The package update has been cancelled."
end
