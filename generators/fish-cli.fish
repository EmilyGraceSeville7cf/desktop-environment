#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/options.fish

set cancellation_message "🚧 CLI creation has been cancelled."

set code_file (mktemp)
printf "%s\n\n" "#!/usr/bin/env fish" >$code_file

question "Add options?" && begin
    set additional_options (question_with_input "What options to add?" "e.g. --sound|-s --no-sound|-n ...")

    if test $status -ne 0
        cat $code_file
        exit
    end

    set additional_options (string trim -- $additional_options)
    set additional_options_pairs (string split " " -- $additional_options)
    set specification "argparse --name=(status current-filename)"

    for pair in $additional_options_pairs
        set long (string split --max=1 --fields=1 "|" -- $pair)
        set short (string split --max=2 --fields=2 "|" -- $pair)

        is_short_option $short || begin
            message "Short option for a long option '$long' is defined incorrectly."
            continue
        end

        is_long_option $long || begin
            message "Long option for a short option '$short' is defined incorrectly."
            continue
        end

        set long (string sub --start=3 -- $long)
        set short (string sub --start=2 -- $short)

        set specification "$specification $short/$long"
    end

    echo "$specification -- \$argv" >>$code_file
end

cat $code_file

