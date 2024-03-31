{
   test.pas
   
   Copyright 2024 ivanl <ivanl@HP-PAVILION>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}
program ComparacionStrings;

var
  cadena1, cadena2: string;

begin
  cadena1 := 'xso';
  cadena2 := 'abcvccv';

  // Comparar si dos cadenas son iguales

  // Comparar si una cadena es menor que otra
  if (cadena1 < cadena2) then
    writeln('cadena1 es menor que cadena2')
  else
    writeln('cadena1 es mayor que cadena2');
end.
