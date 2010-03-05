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
unit uOptions;

interface

uses
    graphics;

type
    TOptionsApplication = class(TObject)
    private
        FShowGrid: boolean;
        FMovementPrecision: integer;
        FSnapToGrid: boolean;
        FgridSize: integer;
        FBackGroundColor: TColor;
        FGridColor: TColor;
        FRewriteOnFilling: boolean;
        FBackGroundProperties: TColor;
        FSelectionColorMark: TColor;
        procedure SetMovementPrecision(const Value: integer);
        procedure SetShowGrid(const Value: boolean);
        procedure SetSnapToGrid(const Value: boolean);
        procedure SetgridSize(const Value: integer);
        procedure SetBackGroundColor(const Value: TColor);
        procedure SetGridColor(const Value: TColor);
        procedure SetRewriteOnFilling(const Value: boolean);
        procedure SetBackGroundProperties(const Value: TColor);
        procedure SetSelectionColorMark(const Value: TColor);
    public
        property ShowGrid: boolean read FShowGrid write SetShowGrid;
        property SnapToGrid: boolean read FSnapToGrid write SetSnapToGrid;
        property MovementPrecision: integer read FMovementPrecision write SetMovementPrecision;
        property gridSize: integer read FgridSize write SetgridSize;
        property BackGroundColor: TColor read FBackGroundColor write SetBackGroundColor;
        property GridColor: TColor read FGridColor write SetGridColor;
        property RewriteOnFilling: boolean read FRewriteOnFilling write SetRewriteOnFilling;
        property BackGroundProperties: TColor read FBackGroundProperties write SetBackGroundProperties;
        property SelectionColorMark: TColor read FSelectionColorMark write SetSelectionColorMark;
        constructor Create();
        destructor Destroy(); override;
        procedure LoadFromFile();
        procedure SaveToFile();
    end;

implementation

uses
    inifiles, SysUtils;

{ TOptionsApplication }

constructor TOptionsApplication.Create;
begin
    FShowGrid := true;
    FSnapToGrid := true;
    FMovementPrecision := 10;
    FBackGroundColor := clWhite;
    FGridColor := clgray;
    FRewriteOnFilling := false;
    FBackGroundProperties := clWhite;
    LoadFromFile;
end;

destructor TOptionsApplication.Destroy;
begin
    inherited;
end;

procedure TOptionsApplication.LoadFromFile;
var
    ini: TIniFile;
begin
    ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'options.ini');
    try
        FShowGrid := StrToBool(ini.ReadString('APP', 'ShowGrid', '1'));
        FSnapToGrid := StrToBool(ini.ReadString('APP', 'SnapToGrid', '1'));
        FMovementPrecision := StrToInt(ini.ReadString('APP', 'MovementPrecision', '10'));
        FgridSize := StrToInt(ini.ReadString('APP', 'GridSize', '10'));
        FBackGroundColor := StrToInt(ini.ReadString('APP', 'BackGroundColor', '16777215')); // clWhite
        FGridColor := StrToInt(ini.ReadString('APP', 'GridColor', '8421504')); // clgray
        FRewriteOnFilling := StrToBool(ini.ReadString('APP', 'RewriteFilling', '0'));
        FBackGroundProperties := StrToInt(ini.ReadString('APP', 'BackGroundProperties', '16777215')); // clWhite
        FSelectionColorMark := StrToInt(ini.ReadString('APP', 'SelectionColorMark', '0')); // clBlack
    finally
        ini.free;
    end;
end;

procedure TOptionsApplication.SaveToFile;
var
    ini: TIniFile;
begin
    ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'options.ini');
    try
        ini.WriteString('APP', 'ShowGrid', BooltoStr(FShowGrid));
        ini.WriteString('APP', 'SnapToGrid', BooltoStr(FSnapToGrid));
        ini.WriteString('APP', 'MovementPrecision', InttoStr(FMovementPrecision));
        ini.WriteString('APP', 'GridSize', InttoStr(FgridSize));
        ini.WriteString('APP', 'BackGroundColor', InttoStr(FBackGroundColor));
        ini.WriteString('APP', 'GridColor', InttoStr(FGridColor));
        ini.WriteString('APP', 'RewriteFilling', BooltoStr(FRewriteOnFilling));
        ini.WriteString('APP', 'BackGroundProperties', InttoStr(FBackGroundProperties));
        ini.WriteString('APP', 'SelectionColorMark', InttoStr(FSelectionColorMark));
    finally
        ini.free;
    end;
end;

procedure TOptionsApplication.SetBackGroundColor(const Value: TColor);
begin
    FBackGroundColor := Value;
end;

procedure TOptionsApplication.SetBackGroundProperties(const Value: TColor);
begin
    FBackGroundProperties := Value;
end;

procedure TOptionsApplication.SetGridColor(const Value: TColor);
begin
    FGridColor := Value;
end;

procedure TOptionsApplication.SetgridSize(const Value: integer);
begin
    FgridSize := Value;
end;

procedure TOptionsApplication.SetMovementPrecision(const Value: integer);
begin
    FMovementPrecision := Value;
end;

procedure TOptionsApplication.SetRewriteOnFilling(const Value: boolean);
begin
    FRewriteOnFilling := Value;
end;

procedure TOptionsApplication.SetSelectionColorMark(const Value: TColor);
begin
    FSelectionColorMark := Value;
end;

procedure TOptionsApplication.SetShowGrid(const Value: boolean);
begin
    FShowGrid := Value;
end;

procedure TOptionsApplication.SetSnapToGrid(const Value: boolean);
begin
    FSnapToGrid := Value;
end;

end.
