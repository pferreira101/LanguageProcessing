BEGIN {RS=";\n"; FS=";"}

    {tipo[$10]++; n_tipos++}

END {   print "TIPO - Numero de Processos" > "tipo_output.txt"
        for(i in tipo) {
            if (i == "") print "Sem tipo - " tipo[i] > "tipo_output.txt"
            else print i " - " tipo[i] > "tipo_output.txt"
        }

        print "Foram encontrados " n_tipos " tipos diferentes"
    }