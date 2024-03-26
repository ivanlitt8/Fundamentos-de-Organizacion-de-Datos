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
	str = string[30];
	celular = record
		id: integer;
		nombre: str;
		descripcion: str;
		marca: str;
		precio: real;
		stockMin: integer;
		stockDisp: integer;
	end;

	archivo_celulares = file of celular;   
	 
procedure cargarDesdeArchivoTexto(var archivoRegistros: archivo_celulares; nombreArchivoTexto: string);
var
    archivoTexto: Text;
    cel: celular;
    linea: string;
begin
    // Abre el archivo de texto
    assign(archivoTexto, nombreArchivoTexto);
    reset(archivoTexto);

    // Abre el archivo de registros para escritura
    rewrite(archivoRegistros);

    // Lee cada línea del archivo de texto y carga los registros
    while not eof(archivoTexto) do begin
        // Lee una línea del archivo de texto
        read(archivoTexto, cel);
        readln(archivoTexto, 'id: ', cel.id);
        readln(archivoTexto, 'nombre: ', cel.nombre);
        readln(archivoTexto, 'descripción: ', cel.descripcion);
        readln(archivoTexto, 'marca: ', cel.marca);
        readln(archivoTexto, 'precio: ', cel.precio);
        readln(archivoTexto, 'stockMin: ', cel.stockMin);
        readln(archivoTexto, 'stockDisp: ', cel.stockDisp);

        // Escribe el registro en el archivo de registros
        write(archivoRegistros, cel);
    end;

    // Cierra los archivos
    close(archivoTexto);
    close(archivoRegistros);

    // Informa que la carga ha sido exitosa
    writeln('Registros cargados correctamente desde el archivo de texto.');
end;

var
    registrosCelulares: archivo_celulares;
begin
    // Nombre del archivo de texto que contiene los datos de los celulares
    cargarDesdeArchivoTexto(registrosCelulares, 'celulares.txt');
end.
