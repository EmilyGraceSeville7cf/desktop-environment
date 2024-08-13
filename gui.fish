#!/usr/bin/env fish

set path $argv[1]
set arguments $argv[2..]

set name (basename -s .fish -- $path)
set title (string sub --start=1 --length=1 -- $name | string upper)(string sub --start=2 -- $name | string replace - " ")

kitty \
    --title="💟 $title..." \
    --config /home/emilygraceseville7cf/Documents/open-source/fish/gui-menus/kitty.conf -- \
    $path
