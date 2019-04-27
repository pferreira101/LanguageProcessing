BEGIN {RS=";\n"; FS=";"}

NR>=2 {	 
		str =  "\042" $2 "\042" # entre aspas
		file = $2".dot"

		# INICIA FICHEIRO
		print "graph {\n"  str  " -- \042REF\042;\n"  str  " -- \042Complementar\042;\n" > file

		# DIPLOMAS REF
		split($8, diplomas, ".");
		for(i in diplomas)
			if(diplomas[i] != "") # tentar tirar esta linha
				print "\042REF\042 -- "  "\042"diplomas[i]"\042;" > file

		# DIPLOMAS COMPLEMENTARES
		split($9, complementar, "\040e\040")
		for (i in complementar) 
			print "\042Complementar\042 -- "  "\042"complementar[i]"\042;" > file
		
		# TERMINA FICHEIRO
		print "}" > file
	}

END {print "Número de grafos criados: " NR}