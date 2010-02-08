unit uParser;

interface

uses
    classes;

function TokenList(): TStringList;
function IsKeyWord(s: string): Boolean;
function IsSeparator(Car: Char): Boolean;
function NextWord(var s: string; var PrevWord: string; var isFinal : boolean): string;
function IsNumber(s: string): Boolean;

implementation

uses
    SysUtils;

function IsSeparator(Car: Char): Boolean;
begin
    case Car of
        '.', ';', ',', ':', '¡', '!', '·', '"', '''', '^', '+', '-', '*', '/', '\', '¨', ' ', '`', '[', ']', '(', ')', 'º', 'ª', '{', '}', '?', '¿', '%', '=':
            Result := True;
    else
        Result := False;
    end;
end;

function NextWord(var s: string; var PrevWord: string; var isFinal : boolean): string;
begin
    Result := '';
    PrevWord := '';
    if s = '' then
        Exit;
    isFinal := false;
    while (s <> '') and IsSeparator(s[1]) do
    begin
        isFinal := s[1] = ';';
        PrevWord := PrevWord + s[1];
        Delete(s, 1, 1);
    end;
    while (s <> '') and not IsSeparator(s[1]) do
    begin
        Result := Result + s[1];
        Delete(s, 1, 1);
    end;
end;

function IsKeyWord(s: string): Boolean;
var
    i: Integer;
    tokens : TStringList;
begin
    Result := False;
    if s = '' then
        Exit;
    tokens := TokenList;
    for i := 0 to tokens.Count - 1 do
    begin
        if tokens[i] = AnsiUpperCase(s) then
        begin
            Result := True;
            break;
        end;
    end;
    FreeAndNil(tokens);
end;

function IsNumber(s: string): Boolean;
var
    i: Integer;
begin
    Result := False;
    for i := 1 to Length(s) do
        case s[i] of
            '0' .. '9':
                ;
        else
            Exit;
        end;
    Result := True;
end;

function TokenList(): TStringList;
var
    res: TStringList;
begin
    res := TStringList.Create;
    res.Add('NODE');
    res.Add('TONODE');
    res.Add('PARAMETERS');
    res.Add(AnsiUpperCase('SimpleEdge'));
    res.Add(AnsiUpperCase('SimpleArrowEdge'));
    res.Add(AnsiUpperCase('SimpleDoubleArrowEdge'));
    res.Add(AnsiUpperCase('SimpleDoubleLinkedArrowEdge'));
    res.Add(AnsiUpperCase('DottedEdge'));
    res.Add(AnsiUpperCase('DottedArrowEdge'));
    res.Add(AnsiUpperCase('DottedDoubleArrowEdge'));
    res.Add(AnsiUpperCase('DottedDoubleLinkedArrowEdge'));
    res.Add(AnsiUpperCase('EdgeType'));
    res.Add(AnsiUpperCase('SizeBox'));
    res.Add(AnsiUpperCase('LineColor'));
    res.Add(AnsiUpperCase('PenWidth'));

    res.Add(AnsiUpperCase('clBlack'));
    res.Add(AnsiUpperCase('clMaroon'));
    res.Add(AnsiUpperCase('clGreen'));
    res.Add(AnsiUpperCase('clOlive'));
    res.Add(AnsiUpperCase('clNavy'));
    res.Add(AnsiUpperCase('clPurple'));
    res.Add(AnsiUpperCase('clTeal'));
    res.Add(AnsiUpperCase('clGray'));
    res.Add(AnsiUpperCase('clSilver'));
    res.Add(AnsiUpperCase('clRed'));
    res.Add(AnsiUpperCase('clLime'));
    res.Add(AnsiUpperCase('clYellow'));
    res.Add(AnsiUpperCase('clBlue'));
    res.Add(AnsiUpperCase('clFuchsia'));
    res.Add(AnsiUpperCase('clAqua'));
    res.Add(AnsiUpperCase('clLtGray'));
    res.Add(AnsiUpperCase('clDkGray'));
    res.Add(AnsiUpperCase('clWhite'));
    Result := res;
end;

end.
