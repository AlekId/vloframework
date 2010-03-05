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
unit uNodeLibrary;

interface

uses
    uNode, types;

type
    TAlignment = (Onleft, OnRight, OnTop, OnBottom);
    TOrder = (zFront, zBack);

function AlignNodes(nodeList: TNodeList; alignment: TAlignment): boolean;
function PositionNodes(nodeList: TNodeList; zOrder: TOrder): boolean;

implementation

function AlignNodes(nodeList: TNodeList; alignment: TAlignment): boolean;
var
    i: Integer;
    Count: Integer;
    vertex, dist: Integer;
begin
    Count := 0;
    for i := 0 to nodeList.Count - 1 do
        if nodeList.items[i].Inside then
            Count := Count + 1;

    vertex := -1;
    if Count > 1 then
    begin
        for i := 0 to nodeList.Count - 1 do
        begin
            if nodeList.items[i].Inside then
            begin
                if (vertex = -1) then
                begin
                    case alignment of
                        Onleft:
                            vertex := nodeList.items[i].Vertex1.x;
                        OnRight:
                            vertex := nodeList.items[i].Vertex2.x;
                        OnTop:
                            vertex := nodeList.items[i].Vertex1.Y;
                        OnBottom:
                            vertex := nodeList.items[i].Vertex2.Y;
                    end;
                end
                else
                begin
                    case alignment of
                        Onleft:
                            begin
                                dist := nodeList.items[i].Vertex2.x - nodeList.items[i].Vertex1.x;
                                nodeList.items[i].Vertex1 := Point(vertex, nodeList.items[i].Vertex1.Y);
                                nodeList.items[i].Vertex2 := Point(vertex + dist, nodeList.items[i].Vertex2.Y);
                            end;
                        OnRight:
                            begin
                                dist := nodeList.items[i].Vertex2.x - nodeList.items[i].Vertex1.x;
                                nodeList.items[i].Vertex2 := Point(vertex, nodeList.items[i].Vertex2.Y);
                                nodeList.items[i].Vertex1 := Point(vertex - dist, nodeList.items[i].Vertex1.Y);
                            end;
                        OnTop:
                            begin
                                dist := nodeList.items[i].Vertex2.Y - nodeList.items[i].Vertex1.Y;
                                nodeList.items[i].Vertex1 := Point(nodeList.items[i].Vertex1.x, vertex);
                                nodeList.items[i].Vertex2 := Point(nodeList.items[i].Vertex2.x, dist + vertex);
                            end;
                        OnBottom:
                            begin
                                dist := nodeList.items[i].Vertex2.Y - nodeList.items[i].Vertex1.Y;
                                nodeList.items[i].Vertex2 := Point(nodeList.items[i].Vertex2.x, vertex);
                                nodeList.items[i].Vertex1 := Point(nodeList.items[i].Vertex1.x, vertex - dist);
                            end;
                    end;
                    nodeList.items[i].CalcPoints();
                    nodeList.items[i].CalcCenter();
                end;
            end;
        end;
    end;
    result := (Count > 1);
end;

function PositionNodes(nodeList: TNodeList; zOrder: TOrder): boolean;
var
    i: Integer;
    pos: Integer;
    ordered: boolean;
begin
    ordered := false;
    pos := 0;
    case zOrder of
        zFront:
            pos := 1;
        zBack:
            pos := -1;
    end;
    for i := 0 to nodeList.Count - 1 do
    begin
        if nodeList.items[i].Inside then
        begin
            nodeList.items[i].properties.zOrder := nodeList.items[i].properties.zOrder + pos;
            ordered := true;
        end;
    end;
    nodeList.SortList;
    result := ordered;
end;

end.
