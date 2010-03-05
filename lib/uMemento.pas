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
unit uMemento;

interface

uses
    uNode, contnrs, uConnector;

type
    TMemento = class(TObject)
        FboxListState: TNodeList;
        FConnectorListState: TConnectorList;
    public
        constructor Create(boxListState: TNodeList; ConnectorListState: TConnectorList);
        destructor Destroy(); override;
        procedure ClearObjects();
        function getSavedBoxState(): TNodeList;
        function getSavedConnectorState(): TConnectorList;
    end;

    TOriginator = class(TObject)
        FboxListState: TNodeList;
        FConnectorListState: TConnectorList;
    public
        procedure SetState(boxListState: TNodeList; ConnectorListState: TConnectorList);
        function SaveToMemento(): TMemento;
        function restoreBoxFromMemento(memento: TMemento): TNodeList;
        function restoreConnectorFromMemento(memento: TMemento): TConnectorList;
    end;

    TCareTaker = class(TObject)
        FSavedStates: TObjectList;
    public
        constructor Create();
        destructor Destroy(); override;
        procedure addMemento(memento: TMemento);
        function thereAreMementos(): boolean;
        function getLastMemento(): TMemento;
        procedure RemoveLastMemento();
    end;

implementation

uses
    SysUtils;

{ TMemento }

procedure TMemento.ClearObjects;
begin
    if Assigned(Self.FBoxListState) then
        FreeAndNil(Self.FBoxListState);
    if Assigned(Self.FConnectorListState) then
        FreeAndNil(Self.FConnectorListState);
end;

constructor TMemento.Create(boxListState: TNodeList; ConnectorListState: TConnectorList);
begin
    Self.FBoxListState := boxListState.Clone;
    Self.FConnectorListState := ConnectorListState.Clone;
end;

destructor TMemento.Destroy;
begin
    inherited;
end;

function TMemento.getSavedBoxState: TNodeList;
begin
    result := Self.FBoxListState;
end;

function TMemento.getSavedConnectorState: TConnectorList;
begin
    result := Self.FConnectorListState;
end;

{ TOriginator }

function TOriginator.restoreBoxFromMemento(memento: TMemento): TNodeList;
begin
    Self.FboxListState := memento.getSavedBoxState;
    result := Self.FboxListState;
end;

function TOriginator.restoreConnectorFromMemento(memento: TMemento): TConnectorList;
var
    i: integer;
    con: TConnector;
begin
    Self.FConnectorListState := memento.getSavedConnectorState;
    for i := 0 to Self.FConnectorListState.Count - 1 do
    begin
        Con := Self.FConnectorListState.Items[i];
        Con.SourceNode := Self.FboxListState.GetNode(Con.HashSourceNode);
        Con.TargetNode := Self.FboxListState.GetNode(Con.HashTargetNode);
    end;
    result := Self.FConnectorListState;
end;

function TOriginator.SaveToMemento: TMemento;
begin
    result := TMemento.Create(Self.FBoxListState, Self.FConnectorListState);
end;

procedure TOriginator.SetState(boxListState: TNodeList; ConnectorListState: TConnectorList);
begin
    Self.FBoxListState := BoxListState;
    Self.FConnectorListState := ConnectorListState;
end;

{ TCareTaker }

procedure TCareTaker.addMemento(memento: TMemento);
begin
    FSavedStates.Add(memento);
end;

constructor TCareTaker.Create;
begin
    FSavedStates := TObjectList.Create();
end;

destructor TCareTaker.Destroy;
begin
    FreeAndNil(FSavedStates);
    inherited;
end;

function TCareTaker.getLastMemento(): TMemento;
begin
    result := nil;
    if (FsavedStates.Count > 0) then
        result := (FSavedStates.Items[FsavedStates.Count - 1] as TMemento);
end;

procedure TCareTaker.RemoveLastMemento;
begin
    if (FsavedStates.Count > 0) then
        FSavedStates.Remove(FSavedStates.Items[FsavedStates.Count - 1]);
end;

function TCareTaker.thereAreMementos: boolean;
begin
    result := (FsavedStates.Count > 0);
end;

end.
