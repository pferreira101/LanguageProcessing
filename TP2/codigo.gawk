BEGIN {RS=";\n"; FS=";"}

    {   if (length($2)!=0){ 
            n_reg++
    		print "======>>>> Código: " $2  > "codigo_output.txt" 
            print "\n\tTítulo: " $3 "\n\n\tDescrição: " $4 "\n" > "codigo_output.txt" 

        	if( length($5)!=0){
        		split($5, lines1, "#", seps)
        		print "\tNotas de aplicação:" > "codigo_output.txt" 
        		for(i in lines1) print "\t\t" lines1[i] > "codigo_output.txt"
        	}
        	if( length($7)!=0){
        		split($7, lines2, "#", seps)           
    			print "\tNotas de exclusão:" > "codigo_output.txt"
    			for(i in lines2) print "\t\t" lines2[i] > "codigo_output.txt"
    			print "\n" > "codigo_output.txt"
    		}
    	}
    }

END {print "Número de registos com código numérico : " n_reg }