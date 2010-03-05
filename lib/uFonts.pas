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
unit uFonts;

interface

uses
    Graphics, StdCtrls, Dialogs;

procedure AssignFont(var FontTarget : TFont; FontSource : TFont);
procedure AssignEditFont(var FontTarget : TEdit; FontSource : TFont);
procedure AssignDialogFont(var FontTarget : TFontDialog; FontSource : TFont);

implementation

procedure AssignFont(var FontTarget : TFont; FontSource : TFont);
begin
    FontTarget.Name := FontSource.name;
    FontTarget.Size := FontSource.Size;
    FontTarget.Style := FontSource.Style;
    FontTarget.Color := FontSource.Color;
end;

procedure AssignEditFont(var FontTarget : TEdit; FontSource : TFont);
begin
    FontTarget.Text := FontSource.Name;
    FontTarget.Font.Name := FontSource.Name;
    FontTarget.Font.Style := FontSource.Style;
    FontTarget.Font.Color := FontSource.Color;
end;

procedure AssignDialogFont(var FontTarget : TFontDialog; FontSource : TFont);
begin
    FontTarget.Font.Name := FontSource.Name;
    FontTarget.Font.Size := FontSource.Size;
    FontTarget.Font.Style := FontSource.Style;
    FontTarget.Font.Color := FontSource.Color;
end;

end.
