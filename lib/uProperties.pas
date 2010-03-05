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
        procedure AssignText(FontText : TFont);
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
        FColorifImage: TColor;
        procedure SetzOrder(const Value: integer);
        procedure SetColorifImage(const Value: TColor);
    public
        property zOrder: integer read FzOrder write SetzOrder;
        property ColorifImage: TColor read FColorifImage write SetColorifImage;
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

procedure TAbstractProperty.AssignText(FontText: TFont);
begin
    Self.FFontText.Name := FontText.name;
    Self.FFontText.Size := FontText.Size;
    Self.FFontText.Style := FontText.Style;
    Self.FFontText.Color := FontText.Color;
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
        begin
            Self.FzOrder := absObj.zOrder;
            Self.FColorifImage := absObj.FColorifImage;
        end;
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
    iXMLRootNode.attributes['FColorifImage'] := IntToStr(Self.FColorifImage);
    inherited MarshalToXML(XMLDoc, iXMLRootNode, sNode);
end;

procedure TNodeProperty.SetColorifImage(const Value: TColor);
begin
    FColorifImage := Value;
end;

procedure TNodeProperty.SetzOrder(const Value: integer);
begin
    FzOrder := Value;
end;

function TNodeProperty.UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    Self.FzOrder := StrToInt(iXMLRootNode.attributes['FzOrder']);
    try
        Self.FColorifImage := StrToInt(iXMLRootNode.attributes['FColorifImage']);
    except
        Self.FColorifImage := clWhite;
    end;
    inherited UnMarshalFromXML(XMLDoc, iXMLRootNode, sNode);
end;

end.
