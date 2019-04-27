.SILENT:test
.PHONY:test
test: formacao.csv codigo.gawk clean.gawk tipo.gawk graph.gawk
	gawk -f clean.gawk formacao.csv
	-gawk -f graph.gawk formacao_limpo.csv
	-gawk -f codigo.gawk formacao_limpo.csv
	-gawk -f tipo.gawk formacao_limpo.csv
	mkdir -p dotFiles
	mv *.dot dotFiles	

.PHONY:clean
.SILENT:clean
clean: 
	-rm *.txt
	-rm formacao_limpo.csv
	-rm -r dotFiles
	






