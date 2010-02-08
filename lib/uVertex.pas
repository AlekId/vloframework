unit uVertex;

interface

uses
    uXMLSerializer, XMLDoc, XMLIntf, types, SysUtils;

type
    TVertex = class(TInterfacedObject, ISerializable)
    private
        Fx: double;
        Fy: double;
        procedure SetX(x: double);
        procedure SetY(y: double);
        function GetPosition(): TPoint;
    public
        property x: double read Fx write SetX;
        property y: double read Fy write SetY;
        property Position: TPoint read GetPosition;
        function Inside(x, y: double): boolean;
        procedure Move(x, y: double);
        constructor Create(x, y: double);
        function MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
        function UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
    end;

function DistancePoints(node1: TVertex; node2: TVertex): double;

implementation

uses
    uZoom;

{ TVertex }

constructor TVertex.Create(x, y: double);
begin
    Fx := x;
    Fy := y;
end;

function TVertex.GetPosition: TPoint;
begin
    result := Point(Round(Fx), Round(Fy));
end;

function TVertex.Inside(x, y: double): boolean;
var
    xinside: boolean;
    yinside: boolean;
    pt: TPoint;
begin
    pt := ClientToGraph(Fx, Fy);
    xinside := (pt.x + 2 >= x) and (pt.x - 2 <= x);
    yinside := (pt.y + 2 >= y) and (pt.y - 2 <= y);
    result := xinside and yinside;
end;

function TVertex.MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    iXMLRootNode.attributes['Fx'] := FloatToStr(Self.Fx);
    iXMLRootNode.attributes['Fy'] := FloatToStr(Self.Fy);
end;

procedure TVertex.Move(x, y: double);
begin
    x := x * globalZoom / 100;
    y := y * globalZoom / 100;
    Fx := Fx + x;
    Fy := Fy + y;
end;

procedure TVertex.SetX(x: double);
begin
    Fx := x;
end;

procedure TVertex.SetY(y: double);
begin
    Fy := y;
end;

function TVertex.UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    if iXMLRootNode.NodeName = sNode then
    begin
        Self.Fx := StrToFloat(iXMLRootNode.attributes['Fx']);
        Self.Fy := StrToFloat(iXMLRootNode.attributes['Fy']);
    end;
end;

function DistancePoints(node1: TVertex; node2: TVertex): double;
begin
    result := Sqrt(sqr(node1.x - node2.x) + sqr(node1.y - node2.y));
end;

end.
