unit ufunutils;

interface

function IsNumber(s: string): Boolean;

implementation

function IsNumber(s: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to Length(s) do
    case s[i] of
      '0'..'9':;
      else
        Exit;
    end;
  Result := True;
end;

end.
