BEGIN {RS=";\n\n"; FS=";"; OFS=";"}

    #NR == 1 {print NR " -> " $0 > "clean.csv" }
    NR >= 2 {   
                not_empty = 1
                if(length($0) <= 33) not_empty = 0                 
                
                if(not_empty == 1){
                    if (length($1)==0) { $1="NIL" }
                    gsub(/#\n*/, ".") 
                    gsub(/\n+/, " ")
                    gsub(/"/, "")
                    print $0 > "clean.csv"  
                }
                          
            }

END {print NR}