#!/usr/bin/env fish

source ~/Documents/open-source/fish/gui-menus/utils/inputs.fish
source ~/Documents/open-source/fish/gui-menus/utils/outputs.fish

set cancellation_message "🚧 Project creation has been cancelled."

set projects ~/Documents/open-source/fish/gui-menus/data/projects.json
set project_names (jq --raw-output .data[].name $projects)
set project_languages (jq --raw-output .data[].language $projects)
set project_directories (jq --raw-output .data[].directory $projects)
set project_generators (jq --raw-output .data[].generator $projects)
set project_entries (jq --raw-output .data[].entry $projects)

set --erase projects

for index in (seq (count $project_names))
    set projects $projects "$project_languages[$index] :: $project_names[$index]"
end

set project (question_with_input_with_hints "What type of project to create?" "Project..." $projects)

test $status -ne 0 && begin
    message $cancellation_message
    exit
end

set project_name (string replace --regex '^[^:]+::\s+' "" -- $project)
set project_language (string replace --regex '\s+::[^:]+$' "" -- $project)
set index 1

while test $index -le (count $project_names)
    test $project_name = $project_names[$index] &&
        test $project_language = $project_languages[$index] && break

    set index (math $index + 1)
end

set project_directory (envsubst < (echo $project_directories[$index] | psub))
set project_generator "$HOME/Documents/open-source/fish/gui-menus/generators/$project_generators[$index].fish"
set project_entry $project_entries[$index]

set project_identifier (question_with_input 'How to name the project?' 'e.g. My sample CLI ...')

test $status -ne 0 && begin
    message $cancellation_message
    exit
end

set code (fish $project_generator)

set code_directory $project_directory/$project_identifier
mkdir $code_directory || begin
    message "🚧 Project creation failed because '$code_directory' directory already exists."
    exit
end
string join \n -- $code > $project_directory/$project_identifier/$project_entry
