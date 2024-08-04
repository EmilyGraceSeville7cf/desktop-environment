#!/usr/bin/env fish

set password "$argv[1]"
set packages "$argv[2..]"

set temp (mktemp)
echo -n "$password" | sudo -S apt upgrade $packages -y >$temp
if test $status -ne 0
    code $temp
end
