(*
 *  This file is part of VLO Framework
 *
 *  VLO Framework is free development platform software:
 *  you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  VLO Framework is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with VLO Framework.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Copyright     2008,2010     Jordi Coll Corbilla
 *)
unit uArray;

interface

type
    TArrayInteger = array of integer;

procedure SetArrayValue(var a: TArrayInteger; valor: integer);

implementation

procedure SetArrayValue(var a: TArrayInteger; valor: integer);
var
    iPosArray: integer;
begin
    iPosArray := length(a);
    SetLength(a, iPosArray + 1);
    a[iPosArray] := valor;
end;

end.
