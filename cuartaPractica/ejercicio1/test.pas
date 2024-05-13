
Program test;

Type 
  Nodo = Record
    Elemento: tipo_dato_elemento;
    Hijo_Izquierdo: integer;
    Hijo_Derecho: integer;
  End;

  Archivo = file Of Nodo;

Procedure Insertar (Var A: Archivo ; elem: tipo_dato_elemento)

Var 
  Raiz, nodo_nuevo: Nodo;
  Pos_nuevo_nodo: integer;
  Encontre_Padre: boolean;
Begin
  Reset(A);
  With nodo_nuevo Do
    Begin
      Elemento := elem;
      Hijo_izquierdo := —1;
      Hijo_Derecho := —1;
    End;

  If Eof(A) Then // significa que es un árbol vacío y el elemento es insertado como raíz
    Write(A,nodo_nuevo)
  Else
    Begin
      Read(A, Raiz);
      Pos_nuevo_nodo := filesize(A);
      Seek(A, pos_nuevo_nodo); {posicionarse al final del 
    archivo}
      Write(A, nodo_nuevo); {escribir el nuevo nodo al final}
      Encontre_Padre := false;
    {buscar al padre para agregar la referencia al nuevo 
    nodo}
      While Not (Encontre_Padre) Do
        Begin
          If (Raiz.elemento > nodo_nuevo.elemento) Then
            Begin
              If (Raiz.hijo_izquierdo <> —1) Then
                Begin
                  Seek(A, Raiz.hijo_izquierdo);
                  Read(A, Raiz);
                End
              Else
                Begin
                  Raiz.hijo_izquierdo := Pos_nuevo_nodo;
                  Encontre_Padre := true;
                End;

            End
          Else
            Begin
              If (Raiz.hijo_derecho <> —1) Then
                Begin
                  Seek(A, Raiz.hijo_derecho);
                  Read(A, Raiz);
                End
              Else
                Begin
                  Raiz.hijo_derecho := Pos_nuevo_nodo;
                  Encontre_Padre := true;
                End;
            End;
        End;
      // raíz es el padre y ya lo leí, debo volver a posicionarme
      Seek(A, Filepos(A) — 1);
      //guardo al padre con la nueva referencia}
      Write (A, raiz);
    End.
