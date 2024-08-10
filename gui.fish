#!/usr/bin/env fish

set menu_path $argv[1]
set menu_size 70x7
gnome-terminal --hide-menubar --zoom 1.5 --geometry $menu_size -- $menu_path
