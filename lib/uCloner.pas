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
unit uCloner;

interface

type
    ICloneable = interface
        ['{F6676376-D14B-4860-AD5B-D920DF25E52D}']
        function Clone: TObject;
    end;

    IAssignable = interface
        ['{11949BA5-E160-417C-A53C-4EE485BDDE34}']
        procedure Assign(obj: TObject);
    end;

implementation

end.
