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
