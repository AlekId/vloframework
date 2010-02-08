unit uProperties;

interface

uses
    uCLoner, uXMLSerializer, XMLDoc, XMLIntf, Graphics, Classes;

type
    TAbstractProperty = class(TInterfacedObject, ISerializable, IAssignable)
    private
        FFillColor: TColor;
        FLineColor: TColor;
        FSelectedColor: TColor;
        FFontText: TFont;
        FFilled: boolean;
        FDescription: TStringList;
        FpenWidth: integer;
        procedure SetDescription(const Value: TStringList);
        procedure SetFillColor(const Value: TColor);
        procedure SetFilled(const Value: boolean);
        procedure SetFontText(const Value: TFont);
        procedure SetLineColor(const Value: TColor);
        procedure SetSelectedColor(const Value: TColor);
        procedure SetpenWidth(const Value: integer);
    public
        property penWidth: integer read FpenWidth write SetpenWidth;
        property Description: TStringList read FDescription write SetDescription;
        property FillColor: TColor read FFillColor write SetFillColor;
        property LineColor: TColor read FLineColor write SetLineColor;
        property Filled: boolean read FFilled write SetFilled;
        property SelectedColor: TColor read FSelectedColor write SetSelectedColor;
        property FontText: TFont read FFontText write SetFontText;
        function MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode; virtual;
        function UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode; virtual;
        procedure Assign(obj: TObject); virtual;
        function getText(): string;
        constructor Create();
        destructor Destroy(); override;
    end;

    TEdgeProperty = class(TAbstractProperty)
    private
        FLenArrow: integer;
        FInclinationAngle: integer;
        procedure SetInclinationAngle(const Value: integer);
        procedure SetLenArrow(const Value: integer);
    public
        property LenArrow: integer read FLenArrow write SetLenArrow;
        property InclinationAngle: integer read FInclinationAngle write SetInclinationAngle;
        function MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode; override;
        function UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode; override;
        procedure Assign(obj: TObject); override;
        constructor Create();
        destructor Destroy(); override;
    end;

    TNodeProperty = class(TAbstractProperty)
    private
        FzOrder: integer;
        procedure SetzOrder(const Value: integer);
    public
        property zOrder: integer read FzOrder write SetzOrder;
        function MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode; override;
        function UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode; override;
        procedure Assign(obj: TObject); override;
        constructor Create();
        destructor Destroy(); override;
    end;

implementation

uses
    SysUtils, StrUtils;

{ TAbstractProperty }

procedure TAbstractProperty.Assign(obj: TObject);
var
    absObj: TAbstractProperty;
begin
    absObj := (obj as TAbstractProperty);
    Self.FFillColor := absObj.FillColor;
    Self.FLineColor := absObj.FLineColor;
    Self.FSelectedColor := absObj.FSelectedColor;
    Self.FFontText.Name := absObj.FFontText.Name;
    Self.FFontText.Size := absObj.FFontText.Size;
    Self.FFontText.Color := absObj.FFontText.Color;
    Self.FFontText.Style := absObj.FFontText.Style;
    Self.FFilled := absObj.FFilled;
    if Self.FDescription.Text = '' then
        Self.FDescription.Text := absObj.Description.Text;
    Self.FpenWidth := absObj.penWidth;
end;

constructor TAbstractProperty.Create;
begin
    FFilled := false;
    FFillColor := clWhite;
    FLineColor := clBlack;
    FSelectedColor := clRed;
    FDescription := TStringList.Create;
    FFontText := TFont.Create;
    FFontText.Name := 'Calibri';
    FFontText.Size := 12;
    FpenWidth := 1;
end;

destructor TAbstractProperty.Destroy;
begin
    FreeAndNil(FFontText);
    FreeAndNil(FDescription);
    inherited;
end;

function TAbstractProperty.getText: string;
begin
    result := AnsiReplaceStr(FDescription.Text, chr(13) + chr(10), '');
end;

function TAbstractProperty.MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    iXMLRootNode.attributes['FFilled'] := BoolToStr(Self.FFilled);
    iXMLRootNode.attributes['FLineColor'] := IntToStr(Self.FLineColor);
    iXMLRootNode.attributes['FSelectedColor'] := IntToStr(Self.FSelectedColor);
    iXMLRootNode.attributes['FFillColor'] := IntToStr(Self.FFillColor);
    iXMLRootNode.attributes['FDescription'] := Self.FDescription.Text;
    iXMLRootNode.attributes['FPenWidth'] := IntToStr(Self.FpenWidth);
    FontSerializer(Self.FFontText, XMLDoc, iXMLRootNode, 'Font');
end;

procedure TAbstractProperty.SetDescription(const Value: TStringList);
begin
    FDescription := Value;
end;

procedure TAbstractProperty.SetFillColor(const Value: TColor);
begin
    FFillColor := Value;
end;

procedure TAbstractProperty.SetFilled(const Value: boolean);
begin
    FFilled := Value;
end;

procedure TAbstractProperty.SetFontText(const Value: TFont);
begin
    FFontText := Value;
end;

procedure TAbstractProperty.SetLineColor(const Value: TColor);
begin
    FLineColor := Value;
end;

procedure TAbstractProperty.SetpenWidth(const Value: integer);
begin
    FpenWidth := Value;
end;

procedure TAbstractProperty.SetSelectedColor(const Value: TColor);
begin
    FSelectedColor := Value;
end;

function TAbstractProperty.UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    Self.FFilled := StrToBool(iXMLRootNode.attributes['FFilled']);
    Self.FLineColor := StrToInt(iXMLRootNode.attributes['FLineColor']);
    Self.FSelectedColor := StrToInt(iXMLRootNode.attributes['FSelectedColor']);
    Self.FFillColor := StrToInt(iXMLRootNode.attributes['FFillColor']);
    Self.FDescription.Text := iXMLRootNode.attributes['FDescription'];
    Self.FpenWidth := StrToInt(iXMLRootNode.attributes['FPenWidth']);
    FontDeserializer(Self.FFontText, XMLDoc, iXMLRootNode, 'Font');
end;

{ TLineProperty }

procedure TEdgeProperty.Assign(obj: TObject);
var
    absObj: TEdgeProperty;
begin
    inherited Assign(obj);
    if obj is TEdgeProperty then
    begin
        absObj := (obj as TEdgeProperty);
        if absObj <> nil then
        begin
            Self.FLenArrow := absObj.LenArrow;
            Self.FInclinationAngle := absObj.InclinationAngle;
        end;
    end;
end;

constructor TEdgeProperty.Create;
begin
    inherited;
    FLenArrow := 20;
    FInclinationAngle := 20; // pi/9
end;

destructor TEdgeProperty.Destroy;
begin

    inherited;
end;

function TEdgeProperty.MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    iXMLRootNode.attributes['FLenArrow'] := IntToStr(Self.FLenArrow);
    iXMLRootNode.attributes['FInclinationAngle'] := IntToStr(Self.FInclinationAngle);
    inherited MarshalToXML(XMLDoc, iXMLRootNode, sNode);
end;

procedure TEdgeProperty.SetInclinationAngle(const Value: integer);
begin
    FInclinationAngle := Value;
end;

procedure TEdgeProperty.SetLenArrow(const Value: integer);
begin
    FLenArrow := Value;
end;

function TEdgeProperty.UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    Self.FLenArrow := StrToInt(iXMLRootNode.attributes['FLenArrow']);
    Self.FInclinationAngle := StrToInt(iXMLRootNode.attributes['FInclinationAngle']);
    inherited UnMarshalFromXML(XMLDoc, iXMLRootNode, sNode);
end;

{ TBoxProperty }

procedure TNodeProperty.Assign(obj: TObject);
var
    absObj: TNodeProperty;
begin
    inherited Assign(obj);
    if obj is TNodeProperty then
    begin
        absObj := (obj as TNodeProperty);
        if absObj <> nil then
            Self.FzOrder := absObj.zOrder;
    end;
end;

constructor TNodeProperty.Create;
begin
    FzOrder := 99999;
    inherited;
end;

destructor TNodeProperty.Destroy;
begin

    inherited;
end;

function TNodeProperty.MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    iXMLRootNode.attributes['FzOrder'] := IntToStr(Self.FzOrder);
    inherited MarshalToXML(XMLDoc, iXMLRootNode, sNode);
end;

procedure TNodeProperty.SetzOrder(const Value: integer);
begin
    FzOrder := Value;
end;

function TNodeProperty.UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    Self.FzOrder := StrToInt(iXMLRootNode.attributes['FzOrder']);
    inherited UnMarshalFromXML(XMLDoc, iXMLRootNode, sNode);
end;

end.
