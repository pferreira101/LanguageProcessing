BEGIN {RS=";;;;;;;\n"; FS=";"; OFS=";"; print "Campos :"}
    
    NR == 1 {for(i=1; i<NF;i++) {print "\t" i " -> " $i }}
    NR >= 2 {   
                not_empty = 1
                if(length($0) <= 33) not_empty = 0                 
                
                if(not_empty == 1){
                    
                    gsub(/\n+/, "")
                    gsub(/"/, "")
                    if ($1=="") { $1="NIL";}
                    print $0 > "formacao_limpo.csv"
                    to_keep++  
                }                 
            }

END {print "Registos processados : "NR "\n" "Registos mantidos : " to_keep  }