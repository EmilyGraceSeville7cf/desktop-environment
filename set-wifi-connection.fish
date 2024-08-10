#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/icons.fish

set cancellation_message "$cancel The connection setup has been cancelled."
set temp (mktemp)

loading \
    "$loading Scanning for available WiFi connections..." \
    fish --command "nmcli --fields=SSID,BARS,SECURITY --color=no device wifi list |
        sed --quiet '2,\$p' > $temp"

set connections (cat $temp)
set connection (question_with_input_with_hints "What WiFi to connect to?" "WiFi..." $connections)

test $status -ne 0 && begin
    message $cancellation_message
    exit
end

set raw_connection $connection
set connection (string replace --regex '(\s+(--|WPA.))*\s*$' '' -- $connection |
        string replace --regex '\s+\S+$' '')

set password

if not string match --quiet --regex -- '--\s*$' $raw_connection
    while test "$password" = ""
        set password (question_with_password_input "What password to use to connect to $connection?" "Password...")

        test $status -ne 0 && begin
            message $cancellation_message
            exit
        end
    end
end

set connection_hint "Connecting to $connection..."

if test "$password" = ""
    loading "$loading $connection_hint" nmcli device wifi connect $connection
else
    loading "$loading $connection_hint" nmcli device wifi connect $connection password $password
end

test $status -ne 0 && message "$error Failed to connect to $connection."
