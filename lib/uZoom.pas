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
unit uZoom;

interface

uses
    Classes, Windows, uVertex;

type
    TPointR = record
        x: double;
        y: double;
    end;

function ClientToGraph(x, y: Integer): TPoint; overload;
function ClientToGraph(x, y: double): TPoint; overload;
function ClientToGraph(v: TPoint): TPoint; overload;
function ClientToGraph(v: TVertex): TPoint; overload;
function GraphToClient(x, y: Integer): TPoint; overload;
function GraphToClient(x, y: double): TPointR; overload;
function GraphToClient(p: TPoint): TPoint; overload;

var
    globalZoom: Integer;

implementation

function ClientToGraph(x, y: Integer): TPoint;
begin
    result.x := Muldiv(x, 100, globalZoom);
    result.y := Muldiv(y, 100, globalZoom);
end;

function ClientToGraph(x, y: double): TPoint;
begin
    result.x := Muldiv(round(x), 100, globalZoom);
    result.y := Muldiv(round(y), 100, globalZoom);
end;

function ClientToGraph(v: TPoint): TPoint;
begin
    result.x := Muldiv(v.x, 100, globalZoom);
    result.y := Muldiv(v.y, 100, globalZoom);
end;

function ClientToGraph(v: TVertex): TPoint;
begin
    result.x := Muldiv(round(v.x), 100, globalZoom);
    result.y := Muldiv(round(v.y), 100, globalZoom);
end;

function GraphToClient(x, y: Integer): TPoint;
begin
    result.x := Muldiv(x, globalZoom, 100);
    result.y := Muldiv(y, globalZoom, 100);
end;

function GraphToClient(x, y: double): TPointR;
begin
    result.x := x * globalZoom / 100;
    result.y := y * globalZoom / 100;
end;

function GraphToClient(p: TPoint): TPoint;
begin
    result.x := Muldiv(p.x, globalZoom, 100);
    result.y := Muldiv(p.y, globalZoom, 100);
end;

initialization

globalZoom := 100;

end.
