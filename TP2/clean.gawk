BEGIN {RS=";\n+"; FS=";"}

    #{print NR " -> " $0}
    NR >= 2 {   if (length($1)==0) { $1="NIL" } 
                print NR " -> " $0 > "clean.txt"            
            }

END {print NR}