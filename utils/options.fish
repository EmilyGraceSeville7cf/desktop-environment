#!/usr/bin/env fish

function is_short_option --argument-names option
    string match --quiet --regex '^-[A-z0-9]$' -- $option
end

function is_long_option --argument-names option
    string match --quiet --regex '^--[A-z0-9]+$' -- $option
end
