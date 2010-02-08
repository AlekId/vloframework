unit uMath;

interface

uses types, Math;

function Comparar(Value1, Value2: double; MethodComp: string): boolean;

const
    RealMargin = 0.000001; //1e-6

implementation

function Comparar(Value1, Value2: double; MethodComp: string): boolean;
var
    ret: boolean;
begin
    ret := false;
    if MethodComp = '=' then
    begin
        case CompareValue(Value1, Value2, RealMargin) of
            EqualsValue: ret := true;
        end;
    end
    else if MethodComp = '<>' then
    begin
        case CompareValue(Value1, Value2, RealMargin) of
            LessThanValue: ret := true;
            GreaterThanValue: ret := true;
        end;
    end
    else if MethodComp = '>=' then
    begin
        case CompareValue(Value1, Value2, RealMargin) of
            EqualsValue: ret := true;
            GreaterThanValue: ret := true;
        end;
    end
    else if MethodComp = '>' then
    begin
        case CompareValue(Value1, Value2, RealMargin) of
            GreaterThanValue: ret := true;
        end;
    end
    else if MethodComp = '<=' then
    begin
        case CompareValue(Value1, Value2, RealMargin) of
            LessThanValue: ret := true;
            EqualsValue: ret := true;
        end;
    end
    else if MethodComp = '<' then
    begin
        case CompareValue(Value1, Value2, RealMargin) of
            LessThanValue: ret := true;
        end;
    end;
    result := ret;
end;

end.
