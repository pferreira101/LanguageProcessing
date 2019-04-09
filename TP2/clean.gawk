BEGIN {FS=";"; OFS=";"; RS="\n+";}

NR == 1 {print $0}
NR >= 2 {if (length($1)==0) $1="NIL"; print $0}

END {}