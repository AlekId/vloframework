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
