BEGIN {RS=";\n+"; FS=";"}

    {   if (length($2)!=0) { 
            print "Código: " $2 "\n\tTítulo: " $3 "\n\tDescrição: " $4 "\n\tNotas: " $5 "\n" > "codigo_output.txt"  
        } 
                   
    }

END {print NR}