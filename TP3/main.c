#include "documento.h"

int main(){
    Conceito c = initConceito();
    Documento doc = initDocumento();

    setNome(c, "Pedro");
    addNarrow(c, "Narrow");
    addBroader(c, "Broader");

    addConceito(doc, c);

    docToHTML(doc);
}