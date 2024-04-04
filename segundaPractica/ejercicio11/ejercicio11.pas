{
	La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
	de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
	realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
	idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
	por los siguientes criterios: año, mes, día e idUsuario.

	Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
	el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
	mostrado a continuación:

	Año : ---
		Mes:-- 1
			día:-- 1
				idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
				--------
				idusuario N Tiempo total de acceso en el dia 1 mes 1
			Tiempo total acceso dia 1 mes 1
			-------------
			día N
				idUsuario 1 Tiempo Total de acceso en el dia N mes 1
				--------
				idusuario N Tiempo total de acceso en el dia N mes 1
			Tiempo total acceso dia N mes 1
		Total tiempo de acceso mes 1
		------
		Mes 12
			día 1
				idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
				--------
				idUsuario N Tiempo total de acceso en el dia 1 mes 12
			Tiempo total acceso dia 1 mes 12
			-------------
			día N
				idUsuario 1 Tiempo Total de acceso en el dia N mes 12
				--------
				idUsuario N Tiempo total de acceso en el dia N mes 12
			Tiempo total acceso dia N mes 12
		Total tiempo de acceso mes 12
	
	Total tiempo de acceso año

	Se deberá tener en cuenta las siguientes aclaraciones:

	● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
	● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
	no encontrado”.
	● Debe definir las estructuras de datos necesarias.
	● El recorrido del archivo debe realizarse una única vez procesando sólo la información
	necesaria.
}

program ejercicio11;
const
	valorAlto = 9999;
	dimF = 15;
type
	maestro = record
		anio: integer;
		mes: integer;
		dia: integer;
		id: integer;
		minutos: integer;
	end;
	
	archivoMaestro = file of maestro;
			
procedure leerMaestrotxt(var txt: Text ; var M: Maestro );
begin
	readln(txt,M.anio,M.mes,M.dia,M.id,M.minutos);

	writeln('ANIO: ',M.anio);
	writeln('MES: ',M.mes);
	writeln('DIA: ',M.dia);
	writeln('ID USER: ',M.id);
	writeln('MINUTOS: ',M.minutos);
	writeln();

end;
procedure generarMaestro(var txt: Text ; var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(txt);
	while not eof(txt) do begin
		leerMaestrotxt(txt,M);
		write(arch,M);
	end;
	close(txt);
	close(arch)
end;

procedure leerMaestro ( var arch: archivoMaestro; var M: maestro);
begin
	if not eof(arch) then
		read(arch,M)
	else
		M.anio:= valorAlto;
end;
procedure reporte(var arch: archivoMaestro);
var
  M: maestro;
  encontrado: boolean;
  anio, diaAct, mesAct, tiempoAnio, tiempoMes, tiempoDia, tiempoUser, idAct: integer;
begin
  reset(arch);
  write('Ingrese anio para reporte: ');
  readln(anio);
  encontrado := false; 
  tiempoAnio := 0;
  leerMaestro(arch, M);
  while M.anio <> valorAlto do
  begin
    if M.anio = anio then begin
      encontrado := true;       
      tiempoMes := 0;
      writeln('Anio: ', M.anio);
      while (M.anio = anio) do begin
        mesAct := M.mes;
        writeln('    Mes: ', mesAct);
        tiempoDia := 0;
        while (M.anio = anio) and (M.mes = mesAct) do begin
          diaAct := M.dia;
          writeln('        Dia: ', diaAct);
          while (M.anio = anio) and (M.mes = mesAct) and (M.dia = diaAct) do begin
            idAct := M.id;
            tiempoUser := 0;
            while (M.anio = anio) and (M.mes = mesAct) and (M.dia = diaAct) and (M.id=idAct) do begin
				tiempoUser := tiempoUser + M.minutos;
				leerMaestro(arch, M);
			end;
			tiempoDia := tiempoDia + tiempoUser;
			writeln('            Id Usuario: ', idAct, ' - Tiempo Total: ', tiempoUser, ' minutos');
          end;
          //tiempoDia := tiempoDia + tiempoUser;
        end;
		writeln();
        writeln('        Tiempo total de acceso del mes ', mesAct, ': ', tiempoDia, ' minutos');
        writeln('	----------------------------------------------');
        writeln();
        tiempoMes := tiempoMes + tiempoDia;
      end;

      writeln('    Total tiempo de acceso anual: ', tiempoMes, ' minutos');
      tiempoAnio := tiempoAnio + tiempoMes;
    end
    else begin
      leerMaestro(arch, M);
    end;
  end;

  if not encontrado then
    writeln('Anio no encontrado');
  close(arch);
end;
var
	archTxt: Text;
	archDat: archivoMaestro;
begin
	assign(archTxt,'maestro.txt');
	assign(archDat,'maestro.dat');
	rewrite(archDat);
	generarMaestro(archTxt,archDat);
	reporte(archDat);
end.
