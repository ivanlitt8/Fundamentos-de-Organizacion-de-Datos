program ejercicio5;

type
    celular = record
        codigo: integer;
        precio: real;
        marca: string[50];
        stockMinimo: integer;
        stockDisponible: integer;
        nombre: string[50];
        descripcion: string[100];
    end;

    //archivoCelulares = text; // Cambiar el tipo de archivo a Text

procedure leerCelular(var arch: Text; var cel: celular);
begin
    readln(arch, cel.codigo, cel.precio, cel.marca);
    readln(arch, cel.stockDisponible, cel.stockMinimo, cel.descripcion);
    readln(arch, cel.nombre);
end;

procedure exportarArchivo(var archTexto: Text);
var
    txtCelulares: Text;
    cel: celular;
begin
    assign(txtCelulares, 'celulares.txt');
    rewrite(txtCelulares);

    reset(archTexto);
    while not eof(archTexto) do begin
        leerCelular(archTexto, cel);
        writeln(txtCelulares, cel.codigo, ' ', cel.precio:1:2, ' ', cel.marca);
        writeln(txtCelulares, cel.stockDisponible, ' ', cel.stockMinimo, ' ', cel.descripcion);
        writeln(txtCelulares, cel.nombre);
        writeln(txtCelulares);
    end;

    close(txtCelulares);
    writeln('El archivo "celulares.txt" se ha exportado correctamente.');
end;

procedure imprimirStockMenor(var arch: Text);
var
    cel: celular;
begin
    reset(arch);
    writeln('Los celulares con stock menor al minimo son:');
    writeln();
    while not eof(arch) do begin
        leerCelular(arch, cel);
        if(cel.stockDisponible < cel.stockMinimo) then begin
            writeln('Codigo de celular:', cel.codigo);
            writeln('Precio:', cel.precio:0:2);
            writeln('Marca:', cel.marca);
            writeln('Stock disponible:', cel.stockDisponible);
            writeln('Stock minimo:', cel.stockMinimo);
            writeln('Descripcion:', cel.descripcion);
            writeln('Nombre:', cel.nombre);
            writeln('-------------------------');
        end;
    end;
    close(arch);
end;

procedure imprimirCelulares(var arch: Text);
var
    cel: celular;
begin
    reset(arch);
    writeln('Imprimiendo celulares leidos:');
    writeln();
    while not eof(arch) do begin
        leerCelular(arch, cel);
        writeln('Codigo de celular: ', cel.codigo);
        writeln('Precio: ', cel.precio:0:2);
        writeln('Marca: ', cel.marca);
        writeln('Stock disponible: ', cel.stockDisponible);
        writeln('Stock minimo: ', cel.stockMinimo);
        writeln('Descripcion: ', cel.descripcion);
        writeln('Nombre: ', cel.nombre);
        writeln('-------------------------');
    end;
    close(arch);
end;

var
    txtCelulares: Text;
begin
    assign(txtCelulares, 'celulares.txt'); 
    imprimirCelulares(txtCelulares);
    imprimirStockMenor(txtCelulares);
    exportarArchivo(txtCelulares);
end.
