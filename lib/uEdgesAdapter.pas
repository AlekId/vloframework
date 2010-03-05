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
unit uEdgesAdapter;

interface

uses
    uEdges, Graphics, Classes, SysUtils;

type
    TAdaptedEdge = class(TObject)
        FObject: TAbstractEdge;
        procedure getProperties(const Abstract1: TAbstractEdge; var Abstract2: TAbstractEdge);
        constructor Create(kind: TTypeEdge; obj: TAbstractEdge);
    end;

function getAdaptedLine(kind: TTypeEdge; obj: TAbstractEdge): TAbstractEdge;

implementation

{ TAdaptedLine }

constructor TAdaptedEdge.Create(kind: TTypeEdge; obj: TAbstractEdge);
var
    simple: TSimpleEdgesFactory;
    dotted: TDottedEdgesFactory;
begin
    simple := TSimpleEdgesFactory.Create(obj.FCanvas);
    dotted := TDottedEdgesFactory.Create(obj.FCanvas);
    case kind of
        SimpleEdge: FObject := simple.GetEdge;
        SimpleArrowEdge: FObject := simple.GetEdgeArrow;
        SimpleDoubleArrowEdge: FObject := simple.GetEdgeDoubleArrow;
        SimpleDoubleLinkedArrowEdge: FObject := simple.GetEdgeLinkedArrow;
        DottedEdge: FObject := dotted.GetEdge;
        DottedArrowEdge: FObject := dotted.GetEdgeArrow;
        DottedDoubleArrowEdge: FObject := dotted.GetEdgeDoubleArrow;
        DottedDoubleLinkedArrowEdge: FObject := dotted.GetEdgeLinkedArrow;
        noEdge: FObject := nil;
    end;
    getProperties(obj, FObject);
    FreeAndNil(simple);
    FreeAndNil(dotted);
end;

function getAdaptedLine(kind: TTypeEdge; obj: TAbstractEdge): TAbstractEdge;
var
    adapted: TAdaptedEdge;
    resObj: TAbstractEdge;
begin
    adapted := TAdaptedEdge.Create(kind, obj);
    resObj := adapted.FObject;
    FreeAndNil(adapted);
    result := resObj;
end;

procedure TAdaptedEdge.getProperties(const Abstract1: TAbstractEdge; var Abstract2: TAbstractEdge);
begin
    Abstract2.FSource := Abstract1.FSource;
    Abstract2.FTarget := Abstract1.FTarget;
    Abstract2.FArrayPoint[0] := Abstract1.FArrayPoint[0];
    Abstract2.FArrayPoint[1] := Abstract1.FArrayPoint[1];
    Abstract2.FArrayPoint[2] := Abstract1.FArrayPoint[2];
    Abstract2.modified[0] := Abstract1.modified[0];
    Abstract2.modified[1] := Abstract1.modified[1];
    Abstract2.modified[2] := Abstract1.modified[2];
    Abstract2.Properties.Assign(Abstract1.Properties);
    Abstract2.ArrowKind := Abstract1.ArrowKind;
    Abstract2.Inside := Abstract1.Inside;
end;

end.

