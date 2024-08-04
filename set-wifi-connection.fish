#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/message.fish
source ~/Documents/open-source/fish/gui-menus/utils/wait.fish

set cancellation_message "The connection setup has been cancelled."

set temp (mktemp)
gum spin \
    --spinner=minidot \
    --title.foreground=$default_color \
    --spinner.foreground=$selected_color \
    --title "Scanning for available WiFi connections..." -- \
    fish --command "nmcli --fields=SSID,BARS,SECURITY --color=no device wifi list |
        sed --quiet '2,\$p' > $temp"

set connections (cat $temp)

set connection (string join \n -- $connections |
    gum filter \
        --header=(hint "WiFi connection") \
        --height=6 \
        --prompt="🖊️   " \
        --indicator="✅ " \
        --placeholder='WiFi...')

if test $status -eq 0
    set raw_connection $connection
    set connection (string replace --regex '(\s+(--|WPA.))*\s*$' '' -- $connection |
        string replace --regex '\s+\S+$' '')
    set password

    if not string match --quiet --regex -- '--\s*$' $raw_connection
        while test "$password" = ""
            set password (gum input \
            --header="$(color '❓ Type password for ' $default_color)$(color $connection $identifier_color)$(color ': ' $default_color)" \
            --prompt="🔑 " \
            --placeholder="Password..." \
             --password)

            test $status -ne 0 && begin
                message $cancellation_message
                wait_keypress
                exit
            end
        end
    end

    set title "$(color 'Connecting to ' $default_color)$(color $connection $identifier_color)$(color ... $default_color)"

    if test "$password" = ""
        gum spin \
            --spinner=minidot \
            --title=$title -- \
            nmcli device wifi connect $connection
    else
        gum spin \
            --spinner=minidot \
            --title=$title -- \
            nmcli device wifi connect $connection password $password
    end

    test $status -ne 0 && begin
        question " 💻 $(color 'Delete ' $default_color)$(color $connection $identifier_color)$(color ' as unreachable?' $default_color)"
        test $status -eq 0 && gum spin --spinner=minidot --title "Deleting $connection..." -- \
            nmcli connection delete uuid $connection_uuid
    end
else
    message $cancellation_message
    wait_keypress
end
