unit uGUIDGenerator;

interface

uses
    ComObj, ActiveX;

function CreateGuid(): string;

implementation

function CreateGuid(): string;
var
    ID: TGUID;
begin
    Result := '';
    if CoCreateGuid(ID) = S_OK then
        Result := GUIDToString(ID);
end;


end.
