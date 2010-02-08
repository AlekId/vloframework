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
        procedure SetMovementPrecision(const Value: integer);
        procedure SetShowGrid(const Value: boolean);
        procedure SetSnapToGrid(const Value: boolean);
        procedure SetgridSize(const Value: integer);
        procedure SetBackGroundColor(const Value: TColor);
        procedure SetGridColor(const Value: TColor);
    public
        property ShowGrid: boolean read FShowGrid write SetShowGrid;
        property SnapToGrid: boolean read FSnapToGrid write SetSnapToGrid;
        property MovementPrecision: integer read FMovementPrecision write SetMovementPrecision;
        property gridSize: integer read FgridSize write SetgridSize;
        property BackGroundColor: TColor read FBackGroundColor write SetBackGroundColor;
        property GridColor: TColor read FGridColor write SetGridColor;
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
    finally
        ini.free;
    end;
end;

procedure TOptionsApplication.SetBackGroundColor(const Value: TColor);
begin
    FBackGroundColor := Value;
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

procedure TOptionsApplication.SetShowGrid(const Value: boolean);
begin
    FShowGrid := Value;
end;

procedure TOptionsApplication.SetSnapToGrid(const Value: boolean);
begin
    FSnapToGrid := Value;
end;

end.
