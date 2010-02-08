unit uConnector;

interface

uses
    uBox, uXMLSerializer, uLines, XMLDoc, XMLIntf, Graphics, Classes, contnrs, uCloner;

type
    TConnector = class(TInterfacedObject, ISerializable, ICloneable)
        SourceNode: TNode;
        TargetNode: TNode;
        HashSourceNode: string;
        HashTargetNode: string;
        Edge: TAbstractEdge;
        constructor CreateEmpty();
        constructor Create(Source, Target: TNode; Line: TAbstractEdge);
        destructor Destroy(); override;
        function MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
        function UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
        function UnMarshalFromXMLCustomized(canvas: TCanvas; boxList: TNodeList; XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
        function Clone(): TObject;
    end;

    TConnectorList = class(TObjectList)
    protected
        function GetItem(Index: Integer): TConnector; overload;
        procedure SetItem(Index: Integer; AObject: TConnector);
    public
        property Items[Index: Integer]: TConnector read GetItem write SetItem; default;
        procedure MarshalToXML(sFile: string);
        procedure UnMarshalFromXML(canvas: TCanvas; boxList: TNodeList; sFile: string);
        function Clone: TConnectorList;
        function exists(AObject: TConnector): Boolean;
        function getNumberConnections(Source: TNode): Integer; overload;
        function getNumberConnections(Source: TNode; Target: TNode): Integer; overload;
        function existConnection(Source : TNode; Target : TNode) : boolean;
    end;

implementation

uses
    SysUtils;

{ TConnector }

function TConnector.Clone: TObject;
var
    Conn: TConnector;
begin
    Conn := TConnector.CreateEmpty();
    Conn.HashSourceNode := Self.SourceNode.id;
    Conn.HashTargetNode := Self.TargetNode.id;
    Conn.Edge := Self.Edge.Clone;
    result := Conn;
end;

constructor TConnector.Create(Source, Target: TNode; Line: TAbstractEdge);
begin
    Self.SourceNode := Source;
    HashSourceNode := Source.id;
    Self.TargetNode := Target;
    HashTargetNode := Target.id;
    Self.Edge := Line;
end;

constructor TConnector.CreateEmpty;
begin
    inherited;
    HashSourceNode := '';
    HashTargetNode := '';
    SourceNode := nil;
    TargetNode := nil;
    Edge := nil;
end;

destructor TConnector.Destroy;
begin
    FreeAndNil(Edge);
    inherited;
end;

function TConnector.MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
var
    iNodoObjeto: IXMLNode;
begin
    iXMLRootNode.attributes['SourceBox'] := Self.SourceNode.id;
    iXMLRootNode.attributes['TargetBox'] := Self.TargetNode.id;
    iXMLRootNode.attributes['ClassLine'] := Self.Edge.ClassName;
    iNodoObjeto := iXMLRootNode.AddChild('TLine');
    Self.Edge.MarshalToXML(XMLDoc, iNodoObjeto, 'Line');
end;

function TConnector.UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    // Empty
end;

function TConnector.UnMarshalFromXMLCustomized(canvas: TCanvas; boxList: TNodeList; XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
var
    id: string;
    iNodoAtributo: IXMLNode;
    dottedFactory: TDottedEdgesFactory;
    simpleFactory: TSimpleEdgesFactory;
    ClassNameStr: string;
begin
    if iXMLRootNode.NodeName = sNode then
    begin
        dottedFactory := TDottedEdgesFactory.Create(canvas);
        simpleFactory := TSimpleEdgesFactory.Create(canvas);

        id := iXMLRootNode.attributes['SourceBox'];
        SourceNode := boxList.GetNode(id);
        Self.HashSourceNode := id;

        id := iXMLRootNode.attributes['TargetBox'];
        TargetNode := boxList.GetNode(id);
        Self.HashTargetNode := id;
        ClassNameStr := iXMLRootNode.attributes['ClassLine'];
        Edge := dottedFactory.GetEdgeByName(ClassNameStr);
        if Edge = nil then
            Edge := simpleFactory.GetEdgeByName(ClassNameStr);

        iNodoAtributo := iXMLRootNode.ChildNodes.first;
        if iNodoAtributo <> nil then
        begin
            Self.Edge.UnMarshalFromXML(XMLDoc, iNodoAtributo, 'Line');
        end;
        FreeAndNil(dottedFactory);
        FreeAndNil(simpleFactory);
    end;
end;

{ TConnectorList }

function TConnectorList.Clone: TConnectorList;
var
    res: TConnectorList;
    i: Integer;
    con: TConnector;
    newCon: TConnector;
begin
    res := TConnectorList.Create();
    for i := 0 to Self.count - 1 do
    begin
        con := Self.Items[i];
        newCon := (con.Clone as TConnector);
        res.Add(newCon);
    end;
    result := res;
end;

function TConnectorList.existConnection(Source, Target: TNode): boolean;
var
    i: Integer;
    Trobat: Boolean;
begin
    i := 0;
    Trobat := false;
    while (not Trobat) and (i < Self.count) do
    begin
        Trobat := (Self.Items[i].SourceNode.id = Source.id) and (Self.Items[i].TargetNode.id = Target.id);
        i := i + 1;
    end;
    result := Trobat;
end;

function TConnectorList.exists(AObject: TConnector): Boolean;
var
    i: Integer;
    Trobat: Boolean;
begin
    i := 0;
    Trobat := false;
    while (not Trobat) and (i < Self.count) do
    begin
        Trobat := (Self.Items[i].HashSourceNode = AObject.HashSourceNode) and (Self.Items[i].HashTargetNode = AObject.HashTargetNode);
        // if not trobat then
        // trobat := (self.Items[i].HashSourceBox = AObject.HashTargetBox) and
        // (self.Items[i].HashTargetBox = AObject.HashSourceBox);
        i := i + 1;
    end;
    result := Trobat;
end;

function TConnectorList.GetItem(Index: Integer): TConnector;
begin
    result := TConnector( inherited Items[Index]);
end;

function TConnectorList.getNumberConnections(Source, Target: TNode): Integer;
var
    i: Integer;
    count: Integer;
begin
    count := 0;
    for i := 0 to Self.count - 1 do
    begin
        if ((Self.Items[i].SourceNode.id = Source.id) and (Self.Items[i].TargetNode.id = Target.id)) or ((Self.Items[i].SourceNode.id = Target.id) and (Self.Items[i].TargetNode.id = Source.id)) then
            count := count + 1;
    end;
    result := count;
end;

function TConnectorList.getNumberConnections(Source: TNode): Integer;
var
    i: Integer;
    count: Integer;
begin
    count := 0;
    for i := 0 to Self.count - 1 do
    begin
        if (Self.Items[i].SourceNode.id = Source.id) or (Self.Items[i].TargetNode.id = Source.id) then
            count := count + 1;
    end;
    result := count;
end;

procedure TConnectorList.MarshalToXML(sFile: string);
var
    XMLDoc: TXMLDocument;
    iNode, NodeSeccio: IXMLNode;
    i: Integer;
begin
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := True;
    iNode := XMLDoc.AddChild('TConnectorList');
    for i := 0 to Self.count - 1 do
    begin
        NodeSeccio := iNode.AddChild('Connector');
        Self.Items[i].MarshalToXML(XMLDoc, NodeSeccio, 'Connector');
    end;
    XMLDoc.SaveToFile(sFile);
end;

procedure TConnectorList.SetItem(Index: Integer; AObject: TConnector);
begin
    inherited Items[Index] := AObject;
end;

procedure TConnectorList.UnMarshalFromXML(canvas: TCanvas; boxList: TNodeList; sFile: string);
var
    Document: IXMLDocument;
    iXMLRootNode, iXMLRootNode2: IXMLNode;
    objConnector: TConnector;
begin
    Document := TXMLDocument.Create(nil);
    try
        Document.LoadFromFile(sFile);
        iXMLRootNode := Document.ChildNodes.first;
        iXMLRootNode2 := iXMLRootNode.ChildNodes.first;
        while iXMLRootNode2 <> nil do
        begin
            if iXMLRootNode2.NodeName = 'Connector' then
            begin
                objConnector := TConnector.CreateEmpty();
                objConnector.UnMarshalFromXMLCustomized(canvas, boxList, Document, iXMLRootNode2, 'Connector');
                Self.Add(objConnector);
            end;
            iXMLRootNode2 := iXMLRootNode2.NextSibling;
        end;
    finally
        Document := nil;
    end;
end;

end.
