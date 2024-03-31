{
	Realizar un programa para una tienda de celulares, que presente un menú con
	opciones para:

		a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
		ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
		correspondientes a los celulares deben contener: código de celular, nombre,
		descripción, marca, precio, stock mínimo y stock disponible.

		b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
		stock mínimo.
	
		c. Listar en pantalla los celulares del archivo cuya descripción contenga una
		cadena de caracteres proporcionada por el usuario.

		d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
		“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
		podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
		debería respetar el formato dado para este tipo de archivos en la NOTA 2.
	
	NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
	
	NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
	tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
	marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
	nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
	“celulares.txt”  
}

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
	archivoCelulares = file of celular;
procedure leerTxt(var arch: Text; var cel: celular);
begin
    readln(arch, cel.codigo, cel.precio, cel.marca);
    readln(arch, cel.stockDisponible, cel.stockMinimo, cel.descripcion);
    readln(arch, cel.nombre);
end;
procedure leerDat(var arch: Text; var cel: celular);
begin
    readln(arch, cel.codigo, cel.precio, cel.marca);
    readln(arch, cel.stockDisponible, cel.stockMinimo, cel.descripcion);
    readln(arch, cel.nombre);
end;
procedure exportarArchivo(var arch: archivoCelulares);
var
    txtCelulares: Text;
    cel: celular;
begin
    assign(txtCelulares, 'celulares.txt');
    rewrite(txtCelulares);
	reset(arch);
    while not eof(arch) do begin
        read(arch, cel);
        writeln(txtCelulares, cel.codigo, ' ', cel.precio:0:2, cel.marca);
        writeln(txtCelulares, cel.stockDisponible, ' ', cel.stockMinimo, cel.descripcion);
        writeln(txtCelulares, cel.nombre);
    end;
	close(arch);
    close(txtCelulares);
    writeln('El archivo "celulares.txt" se ha exportado correctamente.');
end;

procedure imprimirStockMenor(var arch: archivoCelulares);
var
    cel: celular;
begin
    reset(arch);
    writeln('Los celulares con stock menor al minimo son:');
    writeln();
    while not eof(arch) do begin
        read(arch, cel);
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

procedure imprimirCelulares(var arch: archivoCelulares);
var
    cel: celular;
begin
    reset(arch);
    writeln('Imprimiendo celulares leidos:');
    writeln();
    while not eof(arch) do begin
        read(arch, cel);
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
procedure crearNuevoArchivo (var txtCelulares: Text ; var regCelulares: archivoCelulares);
var
	cel: celular;
begin
	reset(txtCelulares);
    while not eof(txtCelulares) do begin
        leerTxt(txtCelulares, cel);
        write(regCelulares, cel);
    end;
    close(regCelulares);
    close(txtCelulares);
end;
var
    txtCelulares: Text;
    regCelulares: archivoCelulares;
begin
    assign(txtCelulares, 'celulares.txt'); 
    
    assign(regCelulares, 'celulares.dat');
    rewrite(regCelulares);
	
	crearNuevoArchivo(txtCelulares,regCelulares);
    
    imprimirCelulares(regCelulares);
    imprimirStockMenor(regCelulares);
    exportarArchivo(regCelulares);
end.
