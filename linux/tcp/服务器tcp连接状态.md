ss -ant | awk 'NR>=2 {++State[$1]} END {for (key in State) print key,State[key]}'
