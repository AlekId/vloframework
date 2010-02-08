unit BoxProperties;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, Grids, Spin, uBox, ExtDlgs, Buttons, ComCtrls;

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
        Button1: TButton;
        Button2: TButton;
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
        procedure FormShow(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure sgVertexDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure Button4Click(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
        procedure sgComponentsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    private
        procedure FillImageIcon;
        procedure drawRectangle(backgroundColor, ExternalColor: TColor);
        { Private declarations }
    public
        Box: TNode;
        textfont: TFont;
    end;

var
    frmBoxProp: TfrmBoxProp;

implementation

uses
    uText, StrUtils;
{$R *.dfm}

procedure TfrmBoxProp.Button1Click(Sender: TObject);
begin
    if AnsiContainsStr(imagepath.Text, ExtractFilePath(ParamStr(0))) or (imagepath.Text = '') then
        Box.Image := AnsiRightStr(imagepath.Text, length(imagepath.Text) - length(ExtractFilePath(ParamStr(0))))
    else
    begin
        showMessage('This is not a valid path!, it must start with' + ExtractFilePath(ParamStr(0)));
        exit;
    end;
    Box.mass := spMass.value;
    Box.vertex1 := Point(StrToInt(sgVertex.Cells[1, 1]), StrToInt(sgVertex.Cells[2, 1]));
    Box.vertex2 := Point(StrToInt(sgVertex.Cells[1, 2]), StrToInt(sgVertex.Cells[2, 2]));
    Box.vertex3 := Point(StrToInt(sgVertex.Cells[1, 3]), StrToInt(sgVertex.Cells[2, 3]));
    Box.vertex4 := Point(StrToInt(sgVertex.Cells[1, 4]), StrToInt(sgVertex.Cells[2, 4]));
    Box.Center.X := StrToFloat(sgVertex.Cells[1, 5]);
    Box.Center.Y := StrToFloat(sgVertex.Cells[2, 5]);
    Box.properties.FillColor := cbBoxColor.Selected;
    Box.properties.lineColor := cbLineColor.Selected;
    Box.properties.selectedColor := cbSelectedColor.Selected;
    Box.properties.Description.Text := Memo1.lines.Text;
    Box.properties.fontText.Name := textfont.name;
    Box.properties.fontText.Size := textfont.Size;
    Box.properties.fontText.Style := textfont.Style;
    Box.properties.fontText.Color := textfont.Color;
    Box.properties.penWidth := penWidth.value;
    close;
end;

procedure TfrmBoxProp.Button2Click(Sender: TObject);
begin
    close;
end;

procedure TfrmBoxProp.Button3Click(Sender: TObject);
begin
    FontDialog1.Font.Name := Box.properties.fontText.Name;
    FontDialog1.Font.Size := Box.properties.fontText.Size;
    FontDialog1.Font.Style := Box.properties.fontText.Style;
    FontDialog1.Font.Color := Box.properties.fontText.Color;
    with FontDialog1 do
        if Execute then
        begin
            textfont.Name := Font.name;
            textfont.Size := Font.Size;
            textfont.Style := Font.Style;
            textfont.Color := Font.Color;
            edFont.Text := textfont.Name;
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
    father: TTreeNode;
    i: Integer;
begin
    ft := TFont.Create;
    ft.Name := 'Calibri';
    ft.Size := 12;
    ft.Style := ft.Style + [fsBold];
    sizeText := Image2.Canvas.textWidth('Node Properties ' + Box.Id);
    DrawTextOrientation(Image2.Canvas, Point(1, 235 + (sizeText div 2)), 90, ft, 'Node Properties ' + Box.Id);
    ft.free;

    spzOrder.value := Box.properties.zOrder;
    sgVertex.Cells[0, 1] := 'Vertex 1';
    sgVertex.Cells[0, 2] := 'Vertex 2';
    sgVertex.Cells[0, 3] := 'Vertex 3';
    sgVertex.Cells[0, 4] := 'Vertex 4';
    sgVertex.Cells[0, 5] := 'Center';
    sgVertex.Cells[1, 0] := 'x';
    sgVertex.Cells[2, 0] := 'y';

    sgVertex.Cells[1, 1] := IntToStr(Box.vertex1.X);
    sgVertex.Cells[2, 1] := IntToStr(Box.vertex1.Y);

    sgVertex.Cells[1, 2] := IntToStr(Box.vertex2.X);
    sgVertex.Cells[2, 2] := IntToStr(Box.vertex2.Y);

    sgVertex.Cells[1, 3] := IntToStr(Box.vertex3.X);
    sgVertex.Cells[2, 3] := IntToStr(Box.vertex3.Y);

    sgVertex.Cells[1, 4] := IntToStr(Box.vertex4.X);
    sgVertex.Cells[2, 4] := IntToStr(Box.vertex4.Y);

    sgVertex.Cells[1, 5] := FormatFloat('#.###', Box.Center.X);
    sgVertex.Cells[2, 5] := FormatFloat('#.###', Box.Center.Y);

    sgComponents.Cells[0, 1] := 'Hooke';
    sgComponents.Cells[0, 2] := 'Coulomb';
    sgComponents.Cells[0, 3] := 'Speed';
    sgComponents.Cells[1, 0] := 'r0';
    sgComponents.Cells[2, 0] := 'r1';

    sgComponents.Cells[1, 1] := FormatFloat('#0.###', Box.HookeForce.r0);
    sgComponents.Cells[2, 1] := FormatFloat('#0.###', Box.HookeForce.r1);

    sgComponents.Cells[1, 2] := FormatFloat('#0.###', Box.CoulombForce.r0);
    sgComponents.Cells[2, 2] := FormatFloat('#0.###', Box.CoulombForce.r1);

    sgComponents.Cells[1, 3] := FormatFloat('#0.###', Box.Speed.r0);
    sgComponents.Cells[2, 3] := FormatFloat('#0.###', Box.Speed.r1);

    edtConnections.Text := IntToStr(Box.connections);
    spMass.value := Round(Box.mass);

    tvNeighbour.Items.Clear;
    father := tvNeighbour.Items.Add(nil, 'Node ' + Box.Id);
    for i := 0 to Box.Neighbour.Count-1 do
        tvNeighbour.Items.AddChild(father, String(Box.Neighbour[i]));
    father.Expanded := true;

    cbBoxColor.Selected := Box.properties.FillColor;
    cbLineColor.Selected := Box.properties.lineColor;
    cbSelectedColor.Selected := Box.properties.selectedColor;
    Memo1.lines.Text := Box.properties.Description.Text;
    edFont.Text := Box.properties.fontText.Name;
    textfont := Box.properties.fontText;
    penWidth.value := Box.properties.penWidth;
    if Box.Image <> '' then
    begin
        imagepath.Text := ExtractFilePath(ParamStr(0)) + Box.Image;
        if FileExists(imagepath.Text) then
            Image3.Picture.Bitmap.LoadFromFile(imagepath.Text);
    end;
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

end.
