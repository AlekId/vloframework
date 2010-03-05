(*
 *  This file is part of Thundax P-Zaggy
 *
 *  Thundax P-Zaggy is a free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Thundax P-Zaggy is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with VLO Framework.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Copyright     2008,2010     Jordi Coll Corbilla
 *)
 unit ufrmMemento;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, uMemento;

type
    TtfrmMemento = class(TForm)
        TreeView1: TTreeView;
        procedure FormShow(Sender: TObject);
    private
        { Private declarations }
    public
        CareTaker: TCareTaker;
    end;

var
    tfrmMemento: TtfrmMemento;

implementation

{$R *.dfm}

procedure TtfrmMemento.FormShow(Sender: TObject);
    function CrearNode(Node: TTReeNode; Desc: string): TTreeNode;
    var
        res: TTreeNode;
    begin
        res := TreeView1.Items.AddChild(Node, Desc);
        result := res;
    end;
var
    Node: TTReeNode;
    i, j: integer;
    SubNode, SubSubNode: TTreeNode;
    memento: TMemento;
begin
    TreeView1.Visible := false;
    TreeView1.Items.clear;
    Node := TreeView1.Items.AddFirst(nil, 'SnapShots');
    Node.selected := true;
    Node := TreeView1.Items.getFirstNode;

    for i := 0 to Caretaker.FSavedStates.count - 1 do
    begin
        memento := (Caretaker.FSavedStates.items[i] as TMemento);
        SubNode := CrearNode(Node, 'Snapshot' + IntTostr(i + 1));
        SubSubNode := TreeView1.Items.AddChild(SubNode, 'boxList');
        for j := 0 to memento.getSavedBoxState.count - 1 do
        begin
            TreeView1.Items.AddChild(SubSubNode, 'Box Id = ' + memento.getSavedBoxState.items[j].Id);
        end;
        SubSubNode := TreeView1.Items.AddChild(SubNode, 'ConnectorList');
        for j := 0 to memento.getSavedConnectorState.count - 1 do
        begin
            TreeView1.Items.AddChild(SubSubNode, 'SourceBox Id ' + memento.getSavedConnectorState.items[j].HashSourceNode);
            TreeView1.Items.AddChild(SubSubNode, 'TargetBox Id ' + memento.getSavedConnectorState.items[j].HashTargetNode);
            TreeView1.Items.AddChild(SubSubNode, 'Line ' + memento.getSavedConnectorState.items[j].Edge.ClassName
                + ' Id ' + memento.getSavedConnectorState.items[j].Edge.Id);
        end;
    end;
    TreeView1.Visible := true;
end;

end.
