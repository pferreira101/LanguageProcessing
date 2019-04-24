BEGIN {RS=";\n+"; FS=";"}

NR>=2 {
	str=$2;
	file = $2".gv";
	split($8,diplomas,"\n"); 
	print "graph {\n" + str + " -- REF;\n" + str + " -- Complementar;\n" > file; 
	for(i in diplomas) {print "REF -- " + diplomas[i] + ";\n" >> file;}
	split($9,compl," e ");
	for (i in compl) {print "Complementar -- " + compl[i] + ";\n" >> file;}
	print "}" >> file
	}

END {print "Ações de formação processadas: " + NR}