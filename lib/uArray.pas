unit uArray;

interface

type
    TArrayInteger = array of integer;

procedure SetArrayValue(var a: TArrayInteger; valor: integer);

implementation

procedure SetArrayValue(var a: TArrayInteger; valor: integer);
var
    iPosArray: integer;
begin
    iPosArray := length(a);
    SetLength(a, iPosArray + 1);
    a[iPosArray] := valor;
end;

end.
