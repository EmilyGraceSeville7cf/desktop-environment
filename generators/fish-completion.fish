#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/options.fish

set cancellation_message "🚧 Completion creation has been cancelled."

set code_file (mktemp)
printf "%s\n\n" "#!/usr/bin/env fish" >$code_file

set executable (question_with_input 'What executable completions are created for?' 'e.g. krita')

test $status -ne 0 && begin
    message $cancellation_message
    exit
end

question "Add --help|-h and --version|-v options?" && begin
    begin
        echo complete -c $executable -s h -l help -d '"Show help"'
        echo complete -c $executable -s v -l version -d '"Show version"'
    end >>$code_file
end

question "Add more options?" && begin
    set additional_options (question_with_input 'What options to add?' 'e.g. --sound|-s --no-sound|-n ...')

    if test $status -ne 0
        cat $code_file
        exit
    end

    echo >>$code_file
    set additional_options (string trim -- $additional_options)
    set additional_options_pairs (string split " " -- $additional_options)

    for pair in $additional_options_pairs
        set long (string split --max=1 --fields=1 "|" -- $pair)
        set short (string split --max=1 --fields=2 "|" -- $pair)

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

        printf "complete -c %s -s %s -l %s -d \"not_provided\"\n" $executable $short $long >>$code_file
    end
end

cat $code_file
