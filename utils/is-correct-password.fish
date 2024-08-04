#!/usr/bin/env fish

set password "$argv[1]"
echo -n "$password" | sudo -S true &> /dev/null
