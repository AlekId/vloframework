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
 unit BoxProperties;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, Grids, Spin, uNode, ExtDlgs, Buttons, ComCtrls,
    ImgList;

type
    TfrmBoxProp = class(TForm)
        sgVertex: TStringGrid;
        Image1: TImage;
        Label1: TLabel;
        spzOrder: TSpinEdit;
        Label2: TLabel;
        cbBoxColor: TColorBox;
        Image2: TImage;
        Label3: TLabel;
        cbLineColor: TColorBox;
        Label4: TLabel;
        cbSelectedColor: TColorBox;
        Memo1: TMemo;
        Label5: TLabel;
        FontDialog1: TFontDialog;
        edFont: TEdit;
        Button3: TButton;
        Label6: TLabel;
        penWidth: TSpinEdit;
        imagepath: TEdit;
        Button4: TButton;
        OpenPictureDialog1: TOpenPictureDialog;
        SpeedButton1: TSpeedButton;
        ScrollBox1: TScrollBox;
        Image3: TImage;
        sgComponents: TStringGrid;
        Label7: TLabel;
        Label8: TLabel;
        spMass: TSpinEdit;
        Label9: TLabel;
        tvNeighbour: TTreeView;
        Label10: TLabel;
        edtConnections: TEdit;
        Label11: TLabel;
        nodeType: TEdit;
        Label12: TLabel;
        cbColorIfImage: TColorBox;
        SpeedButton2: TSpeedButton;
        SpeedButton3: TSpeedButton;
        SpeedButton4: TSpeedButton;
        Label13: TLabel;
        ImageList1: TImageList;
        RadioButton1: TRadioButton;
        RadioButton2: TRadioButton;
        procedure FormShow(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure sgVertexDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure Button4Click(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure sgComponentsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
        procedure SpeedButton2Click(Sender: TObject);
        procedure RadioButton2Click(Sender: TObject);
    private
        procedure FillImageIcon;
        procedure drawRectangle(backgroundColor, ExternalColor: TColor);
        procedure LoadTreeNeighbour;
        { Private declarations }
    public
        Node: TNode;
        nodeList: TNodeList;
        textfont: TFont;
    end;

var
    frmBoxProp: TfrmBoxProp;

implementation

uses
    uText, StrUtils, uFonts;
{$R *.dfm}

procedure TfrmBoxProp.Button1Click(Sender: TObject);
begin
    if AnsiContainsStr(imagepath.Text, ExtractFilePath(ParamStr(0))) or (imagepath.Text = '') then
        Node.Image := AnsiRightStr(imagepath.Text, length(imagepath.Text) - length(ExtractFilePath(ParamStr(0))))
    else
    begin
        showMessage('This is not a valid path!, it must start with' + ExtractFilePath(ParamStr(0)));
        exit;
    end;
    Node.mass := spMass.value;
    Node.vertex1 := Point(StrToInt(sgVertex.Cells[1, 1]), StrToInt(sgVertex.Cells[2, 1]));
    Node.vertex2 := Point(StrToInt(sgVertex.Cells[1, 2]), StrToInt(sgVertex.Cells[2, 2]));
    Node.vertex3 := Point(StrToInt(sgVertex.Cells[1, 3]), StrToInt(sgVertex.Cells[2, 3]));
    Node.vertex4 := Point(StrToInt(sgVertex.Cells[1, 4]), StrToInt(sgVertex.Cells[2, 4]));
    Node.Center.X := StrToFloat(sgVertex.Cells[1, 5]);
    Node.Center.Y := StrToFloat(sgVertex.Cells[2, 5]);
    Node.properties.FillColor := cbBoxColor.Selected;
    Node.properties.lineColor := cbLineColor.Selected;
    Node.properties.selectedColor := cbSelectedColor.Selected;
    Node.properties.Description.Text := Memo1.lines.Text;
    Node.properties.AssignText(textfont);
    Node.properties.penWidth := penWidth.value;
    Node.properties.ColorifImage := cbColorIfImage.Selected;
    close;
end;

procedure TfrmBoxProp.Button2Click(Sender: TObject);
begin
    close;
end;

procedure TfrmBoxProp.Button3Click(Sender: TObject);
begin
    AssignDialogFont(FontDialog1, Node.properties.fontText);
    with FontDialog1 do
        if Execute then
        begin
            AssignFont(textfont, Font);
            AssignEditFont(edFont, textfont);
        end;
end;

procedure TfrmBoxProp.Button4Click(Sender: TObject);
var
    filename: string;
begin
    if OpenPictureDialog1.Execute then
    begin
        filename := OpenPictureDialog1.filename;
        if filename <> '' then
        begin
            imagepath.Text := filename;
            Image3.Picture.Bitmap.LoadFromFile(filename);
        end;
    end;
end;

procedure TfrmBoxProp.FormCreate(Sender: TObject);
begin
    GradienteVertical(Image2, clwhite, clgray);
    OpenPictureDialog1.InitialDir := ExtractFilePath(ParamStr(0)) + 'resources\images';
    FillImageIcon();
end;

procedure TfrmBoxProp.FillImageIcon();
begin
    drawRectangle(clwhite, clwhite);
end;

procedure TfrmBoxProp.drawRectangle(backgroundColor, ExternalColor: TColor);
begin
    Image3.Canvas.Brush.Style := bsSolid;
    Image3.Canvas.Brush.Color := backgroundColor;
    Image3.Canvas.Pen.Width := 3;
    Image3.Canvas.Pen.Color := ExternalColor;
    Image3.Canvas.Rectangle(0, 0, 175, 75);
end;

procedure TfrmBoxProp.FormShow(Sender: TObject);
var
    ft: TFont;
    sizeText: Integer;
begin
    ft := TFont.Create;
    ft.Name := 'Calibri';
    ft.Size := 12;
    ft.Style := ft.Style + [fsBold];
    sizeText := Image2.Canvas.textWidth('Node Properties ' + Node.Id);
    DrawTextOrientation(Image2.Canvas, Point(1, 235 + (sizeText div 2)), 90, ft, 'Node Properties ' + Node.Id, False, clwhite);
    ft.free;

    spzOrder.value := Node.properties.zOrder;
    sgVertex.Cells[0, 1] := 'Vertex 1';
    sgVertex.Cells[0, 2] := 'Vertex 2';
    sgVertex.Cells[0, 3] := 'Vertex 3';
    sgVertex.Cells[0, 4] := 'Vertex 4';
    sgVertex.Cells[0, 5] := 'Center';
    sgVertex.Cells[1, 0] := 'x';
    sgVertex.Cells[2, 0] := 'y';

    sgVertex.Cells[1, 1] := IntToStr(Node.vertex1.X);
    sgVertex.Cells[2, 1] := IntToStr(Node.vertex1.Y);

    sgVertex.Cells[1, 2] := IntToStr(Node.vertex2.X);
    sgVertex.Cells[2, 2] := IntToStr(Node.vertex2.Y);

    sgVertex.Cells[1, 3] := IntToStr(Node.vertex3.X);
    sgVertex.Cells[2, 3] := IntToStr(Node.vertex3.Y);

    sgVertex.Cells[1, 4] := IntToStr(Node.vertex4.X);
    sgVertex.Cells[2, 4] := IntToStr(Node.vertex4.Y);

    sgVertex.Cells[1, 5] := FormatFloat('#.###', Node.Center.X);
    sgVertex.Cells[2, 5] := FormatFloat('#.###', Node.Center.Y);

    sgComponents.Cells[0, 1] := 'Hooke';
    sgComponents.Cells[0, 2] := 'Coulomb';
    sgComponents.Cells[0, 3] := 'Speed';
    sgComponents.Cells[1, 0] := 'r0';
    sgComponents.Cells[2, 0] := 'r1';

    sgComponents.Cells[1, 1] := FormatFloat('#0.###', Node.HookeForce.r0);
    sgComponents.Cells[2, 1] := FormatFloat('#0.###', Node.HookeForce.r1);

    sgComponents.Cells[1, 2] := FormatFloat('#0.###', Node.CoulombForce.r0);
    sgComponents.Cells[2, 2] := FormatFloat('#0.###', Node.CoulombForce.r1);

    sgComponents.Cells[1, 3] := FormatFloat('#0.###', Node.Speed.r0);
    sgComponents.Cells[2, 3] := FormatFloat('#0.###', Node.Speed.r1);

    edtConnections.Text := IntToStr(Node.connections);
    spMass.value := Round(Node.mass);

    LoadTreeNeighbour();

    cbBoxColor.Selected := Node.properties.FillColor;
    cbLineColor.Selected := Node.properties.lineColor;
    cbColorIfImage.Selected := Node.properties.ColorifImage;
    cbSelectedColor.Selected := Node.properties.selectedColor;
    Memo1.lines.Text := Node.properties.Description.Text;

    AssignEditFont(edFont, Node.properties.fontText);

    textfont := Node.properties.fontText;
    penWidth.value := Node.properties.penWidth;
    nodeType.Text := Node.nodeTypeToStr(Node.nodeType);
    if Node.Image <> '' then
    begin
        imagepath.Text := ExtractFilePath(ParamStr(0)) + Node.Image;
        if FileExists(imagepath.Text) then
            Image3.Picture.Bitmap.LoadFromFile(imagepath.Text);
    end;
end;

procedure TfrmBoxProp.LoadTreeNeighbour();
var
    father, child: TTreeNode;
    i: Integer;
    NeighBourNode: TNode;
begin
    tvNeighbour.Items.Clear;
    father := tvNeighbour.Items.Add(nil, 'Node ' + Node.DefaultDescription(RadioButton2.Checked));
    father.ImageIndex := 0;
    father.SelectedIndex := 0;
    for i := 0 to Node.Neighbour.Count - 1 do
    begin
        NeighBourNode := nodeList.GetNode(Node.Neighbour[i]);
        if Assigned(NeighBourNode) then
        begin
            child := tvNeighbour.Items.AddChild(father, NeighBourNode.DefaultDescription(RadioButton2.Checked));
            child.ImageIndex := 1;
            child.SelectedIndex := 1;
        end;
    end;
    father.Expanded := true;
end;

procedure TfrmBoxProp.RadioButton2Click(Sender: TObject);
begin
    SpeedButton2.Enabled := not RadioButton2.Checked;
    LoadTreeNeighbour();
end;

procedure TfrmBoxProp.sgComponentsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
    S: string;
    SavedAlign: word;
begin
    S := sgComponents.Cells[ACol, ARow];
    SavedAlign := SetTextAlign(sgComponents.Canvas.Handle, TA_CENTER);
    sgComponents.Canvas.TextRect(Rect, Rect.Left + (Rect.Right - Rect.Left) div 2, Rect.Top + 2, S);
    SetTextAlign(sgComponents.Canvas.Handle, SavedAlign);
end;

procedure TfrmBoxProp.sgVertexDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
    S: string;
    SavedAlign: word;
begin
    S := sgVertex.Cells[ACol, ARow];
    SavedAlign := SetTextAlign(sgVertex.Canvas.Handle, TA_CENTER);
    sgVertex.Canvas.TextRect(Rect, Rect.Left + (Rect.Right - Rect.Left) div 2, Rect.Top + 2, S);
    SetTextAlign(sgVertex.Canvas.Handle, SavedAlign);
end;

procedure TfrmBoxProp.SpeedButton1Click(Sender: TObject);
begin
    imagepath.Text := '';
    FillImageIcon();
end;

procedure TfrmBoxProp.SpeedButton2Click(Sender: TObject);
var
    treenode: TTreeNode;
begin
    treenode := tvNeighbour.Selected;
    if not treenode.HasChildren then
    begin
        if MessageDlg('Are you sure that you want to delete this node?', mtInformation, mbOKCancel, 0) = 1 then
        begin
            Node.DeleteNeighBour(treenode.Text);
            LoadTreeNeighbour();
        end;
    end;
end;

end.
