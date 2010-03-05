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
unit uIntersection;

interface

uses
    uNode, Types;

type
    Tline = array[1..2] of TPoint; {starting and ending points of a line segment}

    TInstersection = class(Tobject)
        class function Linesintersect(line1, line2: TLine; var position: TPoint): boolean;
        class function GetPointInter(Source, Dest: TNode): TPoint; overload;
        class function GetPointInter(Source : TPoint; Dest: TNode): TPoint; overload;
    end;

implementation

uses
    Math, uMath;

{ TInstersection }

class function TInstersection.Linesintersect(line1, line2: TLine; var position: TPoint): boolean;
{local procedure: getequation}

    procedure getequation(line: TLine; var slope, intercept: extended);
    begin
        if line[1].x <> line[2].x then
            slope := (line[2].y - line[1].y) / (line[2].x - line[1].x)
        else
            slope := 1E100;
        intercept := line[1].y - slope * line[1].x;
    end;

    function overlap(const x, y: extended; const line: TLine): boolean;
        {return true if passed x and y are within the range of the endpoints of the
        passed line}
    begin
        if (x >= min(line[1].x, line[2].x))
            and (x <= max(line[1].x, line[2].x))
            and (y >= min(line[1].y, line[2].y))
            and (y <= max(line[1].y, line[2].y)) then
            result := true
        else
            result := false;
    end;

var
    m1, m2, b1, b2: extended;
    x, y: extended;

begin
    {Method -
    a. find the equations of the lines,
    b. find where they intersect
    c. if the point is between the line segment end points for both lines,
    then they do intersect, otherwise not.
    }
    result := false;
    x := 0;
    y := 0;
    {general equation of line: y=mx+b}
    try
        getequation(line1, m1, b1);
        getequation(line2, m2, b2);
    except
        //
    end;

    {intersection condition
    any point (x,y) on line1 satisfies y=m1*x+b1, the intersection
    point also satisfies the line2 equation y=m2*x+b2,
    so y=m1*x+b1=m2*x+b2

    solve for X -
    m1*x+b1=m2*x+b2
    x=(b2-b1)/(m1-m2)
    }
    if m1 <> m2 then
    begin

        try
            x := round((b2 - b1) / (m1 - m2));
            if abs(m1) < abs(m2) then
                y := round(m1 * x + b1) {try to get y intercept from smallest slope}
            else
                y := round(m2 * x + b2); {but try the other equation}
        except

        end;
        {for intersection, x and y must lie between the endpoints of both lines}

        if ((line1[1].x - x) * (x - line1[2].x) >= 0)
            and ((line1[1].y - y) * (y - line1[2].y) >= 0)
            and ((line2[1].x - x) * (x - line2[2].x) >= 0)
            and ((line2[1].y - y) * (y - line2[2].y) >= 0) then
            result := true;
        //* x,y is between x1,y1 and x2,y2 */
    end
    else if Comparar(b1, b2, '=') then {slopes and intercepts are equal}
    begin {lines are colinear }
        {if either end of line 1 is within the x and y range of line2, or
        either end of line2 is with the x,y range of line1, then
        then the lines overlap. For simplicity, we'll just call it an intersection}

        with line1[1] do
            result := overlap(x, y, line2);
        if not result then
            with line1[2] do
                result := overlap(x, y, Line2);
        if not result then
            with line2[1] do
                result := overlap(x, y, line1);
        if not result then
            with line2[2] do
                result := overlap(x, y, line1);
    end;
    if result then
        //if (x < 100000) and (y < 100000) then
        position := Point(Round(x), Round(y));

    {otherwise, slopes are equal and intercepts unequal
    ==> parallel lines ==> no intersection}
end;

class function TInstersection.GetPointInter(Source, Dest: TNode): TPoint;
var
    l: TLine;
    l2: TLine;
    points: TPoint;
begin
    Points := Point(-1, -1);
    l[1] := Source.Center.Position;
    l[2] := Dest.Center.Position;

    l2[1] := Dest.Vertex1;
    l2[2] := Dest.Vertex4;
    try
        if Linesintersect(l, l2, points) then
            result := Points
        else
        begin
            l2[1] := Dest.Vertex1;
            l2[2] := Dest.Vertex3;
            if Linesintersect(l, l2, points) then
                result := Points
            else
            begin
                l2[1] := Dest.Vertex3;
                l2[2] := Dest.Vertex2;
                if Linesintersect(l, l2, points) then
                    result := Points
                else
                begin
                    l2[1] := Dest.Vertex2;
                    l2[2] := Dest.Vertex4;
                    if Linesintersect(l, l2, points) then
                        result := Points
                end;
            end;
        end;
    except
        //
    end;
end;

class function TInstersection.GetPointInter(Source : TPoint;  Dest: TNode): TPoint;
var
    l: TLine;
    l2: TLine;
    points: TPoint;
    resPoint : TPoint;
begin
    Points := Point(-1, -1);
    resPoint := Points;
    l[1] := Source;
    l[2] := Dest.Center.Position;

    l2[1] := Dest.Vertex1;
    l2[2] := Dest.Vertex4;
    try
        if Linesintersect(l, l2, points) then
            resPoint := Points
        else
        begin
            l2[1] := Dest.Vertex1;
            l2[2] := Dest.Vertex3;
            if Linesintersect(l, l2, points) then
                resPoint := Points
            else
            begin
                l2[1] := Dest.Vertex3;
                l2[2] := Dest.Vertex2;
                if Linesintersect(l, l2, points) then
                    resPoint := Points
                else
                begin
                    l2[1] := Dest.Vertex2;
                    l2[2] := Dest.Vertex4;
                    if Linesintersect(l, l2, points) then
                        resPoint := Points
                end;
            end;
        end;
    except
        //
    end;
    result := resPoint;
end;



end.
