#!/usr/bin/env fish

set menu_path $argv[1]
set menu_size $argv[2]

set --query "argv[2]" || set menu_size 54x7

gnome-terminal --hide-menubar --zoom 1.5 --geometry $menu_size -- $menu_path
