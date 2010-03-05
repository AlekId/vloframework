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
unit uIniProperties;

interface

uses
    uProperties, inifiles, Graphics;

procedure FontSerializer(ini: TIniFile; section: String; objFont: TFont); overload;
procedure FontDeserializer(ini: TIniFile; section: String; var objFont: TNodeProperty); overload;
procedure FontDeserializer(ini: TIniFile; section: String; var objFont: TEdgeProperty); overload;

const
    Fdesc = 'Font';


implementation

uses
    SysUtils, Windows;

procedure FontSerializer(ini: TIniFile; section: String; objFont: TFont);
    function iif(condition: boolean; resultTrue: integer; resultFalse: integer): integer;
    begin
        result := resultFalse;
        if condition then
            result := resultTrue
    end;

begin
    if Assigned(ini) and Assigned(objFont) then
    begin
        ini.WriteString(section, Fdesc + 'Name', objFont.Name);
        ini.WriteString(section, Fdesc + 'Size', IntToStr(objFont.Size));
        ini.WriteString(section, Fdesc + 'Color', IntToStr(objFont.Color));

        ini.WriteString(section, Fdesc + 'fsBold', IntToStr(iif(fsBold in objFont.Style, FW_BOLD, FW_NORMAL)));
        ini.WriteString(section, Fdesc + 'fsItalic', IntToStr(iif(fsItalic in objFont.Style, 1, 0)));
        ini.WriteString(section, Fdesc + 'fsUnderline', IntToStr(iif(fsUnderline in objFont.Style, 1, 0)));
        ini.WriteString(section, Fdesc + 'fsStrikeOut', IntToStr(iif(fsStrikeOut in objFont.Style, 1, 0)));
    end;
end;

procedure FontDeserializer(ini: TIniFile; section: String; var objFont: TNodeProperty);
begin
    if Assigned(ini) and Assigned(objFont) then
    begin
        objFont.FontText.Name := ini.ReadString(section, Fdesc + 'Name', 'Calibri');
        objFont.FontText.Size := StrToInt(ini.ReadString(section, Fdesc + 'Size','12'));
        objFont.FontText.Color := StrToInt(ini.ReadString(section, Fdesc + 'Color','0'));
        if StrToInt(ini.ReadString(section, Fdesc + 'fsBold','0')) = FW_BOLD then
            objFont.FontText.Style := objFont.FontText.Style + [fsBold];

        if StrToInt(ini.ReadString(section, Fdesc + 'fsItalic','0')) = 1 then
            objFont.FontText.Style := objFont.FontText.Style + [fsItalic];

        if StrToInt(ini.ReadString(section, Fdesc + 'fsUnderline','0')) = 1 then
            objFont.FontText.Style := objFont.FontText.Style + [fsUnderline];

        if StrToInt(ini.ReadString(section, Fdesc + 'fsStrikeOut','0')) = 1 then
            objFont.FontText.Style := objFont.FontText.Style + [fsStrikeOut];
    end;
end;

procedure FontDeserializer(ini: TIniFile; section: String; var objFont: TEdgeProperty);
begin
    if Assigned(ini) and Assigned(objFont) then
    begin
        objFont.FontText.Name := ini.ReadString(section, Fdesc + 'Name', 'Calibri');
        objFont.FontText.Size := StrToInt(ini.ReadString(section, Fdesc + 'Size','12'));
        objFont.FontText.Color := StrToInt(ini.ReadString(section, Fdesc + 'Color','0'));
        if StrToInt(ini.ReadString(section, Fdesc + 'fsBold','0')) = FW_BOLD then
            objFont.FontText.Style := objFont.FontText.Style + [fsBold];

        if StrToInt(ini.ReadString(section, Fdesc + 'fsItalic','0')) = 1 then
            objFont.FontText.Style := objFont.FontText.Style + [fsItalic];

        if StrToInt(ini.ReadString(section, Fdesc + 'fsUnderline','0')) = 1 then
            objFont.FontText.Style := objFont.FontText.Style + [fsUnderline];

        if StrToInt(ini.ReadString(section, Fdesc + 'fsStrikeOut','0')) = 1 then
            objFont.FontText.Style := objFont.FontText.Style + [fsStrikeOut];
    end;
end;

end.
