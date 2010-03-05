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

function FontSerializer(objFont: TFont; XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode; overload;
function FontDeserializer(objFont: TFont; XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode; overload;

implementation

uses
    SysUtils, Windows;

function FontSerializer(objFont: TFont; XMLDoc: IXMLDocument; iXMLRootNode: IXMLNode; sNode: string): IXMLNode;
    function iif(condition: boolean; resultTrue: integer; resultFalse: integer): integer;
    begin
        result := resultFalse;
        if condition then
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
