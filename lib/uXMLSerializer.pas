unit uXMLSerializer;

interface

uses
    XMLDoc, XMLIntf, Graphics;

type
    ISerializable = interface
        ['{67BF6F2C-A41B-4C8E-9233-89A6F1B4D79D}']
        function MarshalToXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
        function UnMarshalFromXML(XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
    end;

function FontSerializer(objFont: TFont; XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
function FontDeserializer(objFont: TFont; XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;

implementation

uses
    SysUtils, Windows;

function FontSerializer(objFont: TFont; XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
    function iif(condition: boolean; resultTrue: integer; resultFalse: integer): integer;
    begin
        result := resultFalse;
        if Condition then
            result := resultTrue
    end;
begin

    iXMLRootNode.attributes['Name'] := objFont.Name;
    iXMLRootNode.attributes['Size'] := IntToStr(objFont.Size);
    iXMLRootNode.attributes['Color'] := IntToStr(objFont.Color);

    iXMLRootNode.attributes['fsBold'] := IntToStr(iif(fsBold in objFont.Style, FW_BOLD, FW_NORMAL));
    iXMLRootNode.attributes['fsItalic'] := IntToStr(iif(fsItalic in objFont.Style, 1, 0));
    iXMLRootNode.attributes['fsUnderline'] := IntToStr(iif(fsUnderline in objFont.Style, 1, 0));
    iXMLRootNode.attributes['fsStrikeOut'] := IntToStr(iif(fsStrikeOut in objFont.Style, 1, 0));

end;

function FontDeserializer(objFont: TFont; XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
begin
    objFont.Name := iXMLRootNode.attributes['Name'];
    objFont.Size := StrToInt(iXMLRootNode.attributes['Size']);
    objFont.Color := StrToInt(iXMLRootNode.attributes['Color']);
    if StrToInt(iXMLRootNode.attributes['fsBold']) = FW_BOLD then
        objFont.Style := objFont.Style + [fsBold];

    if StrToInt(iXMLRootNode.attributes['fsItalic']) = 1 then
        objFont.Style := objFont.Style + [fsItalic];

    if StrToInt(iXMLRootNode.attributes['fsUnderline']) = 1 then
        objFont.Style := objFont.Style + [fsUnderline];

    if StrToInt(iXMLRootNode.attributes['fsStrikeOut']) = 1 then
        objFont.Style := objFont.Style + [fsStrikeOut];
end;

end.
