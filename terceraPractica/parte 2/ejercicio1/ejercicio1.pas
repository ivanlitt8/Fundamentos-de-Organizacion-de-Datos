//  El encargado de ventas de un negocio de productos de limpieza desea administrar el
//  stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
//  todos los productos que comercializa. De cada producto se maneja la siguiente
//  información: código de producto, nombre comercial, precio de venta, stock actual y
//  stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
//  ventas de productos realizadas. De cada venta se registran: código de producto y
//  cantidad de unidades vendidas. Resuelve los siguientes puntos:

//    a. Se pide realizar un procedimiento que actualice el archivo maestro con el
//      archivo detalle, teniendo en cuenta que:

//      i. Los archivos no están ordenados por ningún criterio.

//      ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
//      del archivo detalle.

//    b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
//      cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
//      archivo detalle?


Program ejercicio1;

Const 
  fin = 'ZZZZ';

Type 
  producto = Record
    codigo: integer;
    nombre: string;
    precioVenta: real;
    stockActual: integer;
    stockMinimo: integer;
  End;

  venta = Record
    codigo: integer;
    cantidad: integer;
  End;

  arch_productos = File Of producto;
  arch_venta = File Of venta;

Procedure leerProducto(Var arch:Text ; Var P: producto);
Begin
  readln(arch, P.codigo);
  readln(arch, P.nombre);
  readln(arch, P.precioVenta, P.stockActual, P.stockMinimo);
  // writeln('Codigo: ', P.codigo);
  // writeln('Nombre producto: ', P.nombre);
  // writeln('Precio venta: ', P.precioVenta:0:2);
  // writeln('Stock Actual: ', P.stockActual);
  // writeln('Stock Minimo: ', P.stockMinimo);
  // writeln();
End;
Procedure leerVenta(Var arch:Text ; Var V: venta);
Begin
  readln(arch, V.codigo, V.cantidad);
  writeln('Codigo: ', V.codigo);
  writeln('Cantidad vendida: ', V.cantidad);
  writeln();
End;
Procedure imprimirArchivo(Var arch: arch_productos);

Var 
  P: producto;
Begin
  Reset(arch);
  While Not Eof(arch) Do
    Begin
      Read(arch,P);
      writeln('Codigo: ', P.codigo);
      writeln('Nombre producto: ', P.nombre);
      writeln('Precio venta: ', P.precioVenta:0:2);
      writeln('Stock Actual: ', P.stockActual);
      writeln('Stock Minimo: ', P.stockMinimo);
      writeln('--------------');
    End;
  Close(arch);
End;

Procedure convertirMaestro(Var txt: Text; Var arch: arch_productos);

Var 
  P: producto;
Begin
  Reset(txt);
  Assign(arch,'maestro.dat');
  Rewrite(arch);
  While Not Eof(txt) Do
    Begin
      leerProducto(txt,P);
      Write(arch,P);
    End;
  Close(txt);
End;

Procedure convertirDetalle(Var txt: Text; Var arch: arch_venta);

Var 
  V: venta;
Begin
  Reset(txt);
  Assign(arch,'detalle.dat');
  Rewrite(arch);
  While Not Eof(txt) Do
    Begin
      leerVenta(txt,V);
      Write(arch,V);
    End;
  Close(txt);
End;

Procedure actualizarMaestro(Var archDet: arch_venta ; Var archMae: arch_productos);

Var 
  P: producto;
  V: venta;
  totalVentas: Integer;
Begin
  Reset(archMae);
  // Abro Maestro
  Reset(archDet);
  // Abro Detalle
  While Not Eof(archMae) Do
    // Recorro el archivo Maestro (productos)
    Begin
      Read(archMae,P);
      // Leo un Producto
      totalVentas := 0;
      // Contador en cero
      While Not Eof(archDet) Do
        // Recorro el archivo Detalle (ventas)
        Begin
          Read(archDet,V);
          // Leo una venta
          If (P.codigo = V.codigo) Then                            // si hay coincidencia
            totalVentas := totalVentas + V.cantidad;
          // Acumulo las ventas
        End;
      If (totalVentas > 0) Then
        Begin
          P.stockActual := P.stockActual - totalVentas;
          // actualizo el stock del producto
          Seek(archMae,FilePos(archMae)-1);
          // retrocedo una posicion 
          Write(archMae,P);
          // reescribo el producto
        End;
      seek(archDet, 0);
      // Posiciono nuevamente en el inicio el archivo de ventas para el prox producto
    End;
  Close(archMae);
  Close(archDet);
End;

Var 
  txtMaestro,txtDetalle: Text;
  datMaestro: arch_productos;
  datDetalle: arch_venta;
Begin
  Assign(txtMaestro,'maestro.txt');
  Assign(txtDetalle,'detalle.txt');
  convertirMaestro(txtMaestro,datMaestro);
  convertirDetalle(txtDetalle,datDetalle);
  WriteLn('---- ARCHIVO ORIGINAL ----');
  imprimirArchivo(datMaestro);
  actualizarMaestro(datDetalle,datMaestro);
  WriteLn('---- ARCHIVO ACTUALIZADO ----');
  imprimirArchivo(datMaestro);
End.
