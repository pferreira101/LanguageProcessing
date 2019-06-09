#include "documento.h"

int main(){
    Conceito c = initConceito();
    Documento doc = initDocumento();

    setNome(c, "Animal");
    setLinguagem(c, "PT");
    addNarrow(c, "Cao");
    addBroader(c, "Ser vivo");
    setScope(c, "Bla Bla Bla");

    addConceito(doc, c);

    Conceito c2 = initConceito();
    setNome(c2, "Cao");
    setLinguagem(c2, "PT");
    addNarrow(c2, "Dalmata");
    addBroader(c2, "Animal");
    addTraducao(c2, "EN", "Dog");

    addConceito(doc, c2);


    docToHTML(doc);
    docToDOT(doc);

    freeDocumento(doc);
}