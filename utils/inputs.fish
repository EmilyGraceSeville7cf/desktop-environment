#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/colors.fish

function pause
    read --prompt-str="🕥 Press any key to continue..." --nchars=1
end

function question --argument-names question
    gum confirm \
        --prompt.foreground=$default_color \
        --selected.foreground=$selected_color \
        --selected.background=$default_color -- \
        $question
end

function loading --argument-names hint
    set arguments $argv[2..]

    gum spin \
        --title=$hint \
        --spinner=minidot \
        --title.foreground=$default_color \
        --spinner.foreground=$selected_color -- \
        $arguments
end

function question_with_input --argument-names question placeholder
    set result
    set placeholder_changed

    while test -z $result
        set result (gum input \
            --header=$question \
            --prompt="❓ " \
            --placeholder=$placeholder \
            --header.foreground=$default_color \
            --prompt.foreground=$selected_color)

        test $status -ne 0 && return 1

        if test -z $placeholder_changed
            set placeholder "$placeholder [non empty input expected]"
            set placeholder_changed true
        end
    end

    echo $result
end

function question_with_password_input --argument-names question placeholder
    set result
    set placeholder_changed

    while test -z $result
        set result (gum input \
            --header=$question \
            --prompt="❓ " \
            --placeholder=$placeholder \
            --password \
            --header.foreground=$default_color \
            --prompt.foreground=$selected_color)

        test $status -ne 0 && return 1

        if test -z $placeholder_changed
            set placeholder "$placeholder [non empty input expected]"
            set placeholder_changed true
        end
    end

    echo $result
end

function question_with_multiline_input --argument-names question placeholder
    set result
    set placeholder_changed

    while test -z "$result"
        set result (gum write \
            --header=$question \
            --placeholder=$placeholder \
            --show-cursor-line \
            --show-line-numbers \
            --cursor-line.foreground=$selected_color \
            --cursor-line-number.foreground=$selected_color \
            --line-number.foreground=$default_color)

        test $status -ne 0 && return 1

        if test -z $placeholder_changed
            set placeholder "$placeholder [non empty input expected]"
            set placeholder_changed true
        end
    end

    echo $result
end

function question_with_input_with_hints --argument-names question placeholder
    set result
    set placeholder_changed
    set hints $argv[3..]

    while test -z $result
        set result (string join \n -- $hints |
            gum filter \
                --header=$question \
                --prompt="❓ " \
                --placeholder=$placeholder \
                --indicator="✅" \
                --height=6 \
                --header.foreground=$default_color \
                --prompt.foreground=$selected_color)

        test $status -ne 0 && return 1

        if test -z $placeholder_changed
            set placeholder "$placeholder [non empty and valid input expected]"
            set placeholder_changed true
        end
    end

    echo $result
end
