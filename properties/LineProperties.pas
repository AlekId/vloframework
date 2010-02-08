unit LineProperties;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, Spin, uLines;

type
    TfrmLineProp = class(TForm)
        Label2: TLabel;
        cbLineColor: TColorBox;
        Label3: TLabel;
        cbFillColor: TColorBox;
        Label4: TLabel;
        cbSelectedColor: TColorBox;
        Label1: TLabel;
        spArrowLength: TSpinEdit;
        chkFilled: TCheckBox;
        Image2: TImage;
        GroupBox1: TGroupBox;
        Image1: TImage;
        rbNormal: TRadioButton;
        Image3: TImage;
        rbDotted: TRadioButton;
        GroupBox2: TGroupBox;
        Image4: TImage;
        rbStraight: TRadioButton;
        rbArrowRight: TRadioButton;
        rbDobleArrow: TRadioButton;
        GroupBox3: TGroupBox;
        Image5: TImage;
        Image6: TImage;
        rbNormalArrow: TRadioButton;
        rbFashionArrow: TRadioButton;
        Label5: TLabel;
        edFont: TEdit;
        Button3: TButton;
        Memo1: TMemo;
        FontDialog1: TFontDialog;
        Button1: TButton;
        Button2: TButton;
        rbNoArrow: TRadioButton;
        penwidth: TSpinEdit;
        Label6: TLabel;
        Label7: TLabel;
        arrowAngle: TSpinEdit;
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button1Click(Sender: TObject);
    private
        { Private declarations }
    public
        line: TAbstractEdge;
        textfont: TFont;
        validate: boolean;
    end;

var
    frmLineProp: TfrmLineProp;

implementation

uses
    uText, uLinesAdapter;
{$R *.dfm}

procedure TfrmLineProp.Button1Click(Sender: TObject);
begin
    line.Properties.LenArrow := spArrowLength.Value;
    line.Properties.lineColor := cbLineColor.Selected;
    line.Properties.Filled := chkFilled.Checked;
    line.Properties.FillColor := cbFillColor.Selected;
    line.Properties.SelectedColor := cbSelectedColor.Selected;
    if rbNormalArrow.Checked then
        line.ArrowKind := Normal;
    if rbFashionArrow.Checked then
        line.ArrowKind := Fashion;
    line.Properties.Description.Text := Memo1.lines.Text;
    line.Properties.fontText.Name := textfont.name;
    line.Properties.fontText.Size := textfont.Size;
    line.Properties.fontText.Style := textfont.Style;
    line.Properties.fontText.Color := textfont.Color;
    line.Properties.penwidth := penwidth.Value;
    line.Properties.InclinationAngle := arrowAngle.Value;

    if rbNormal.Checked then
    begin
        if rbStraight.Checked then
            line := getAdaptedLine(SimpleEdge, line);
        if rbArrowRight.Checked then
            line := getAdaptedLine(SimpleArrowEdge, line);
        if rbDobleArrow.Checked then
            line := getAdaptedLine(SimpleDoubleArrowEdge, line);
    end;
    if rbDotted.Checked then
    begin
        if rbStraight.Checked then
            line := getAdaptedLine(DottedEdge, line);
        if rbArrowRight.Checked then
            line := getAdaptedLine(DottedArrowEdge, line);
        if rbDobleArrow.Checked then
            line := getAdaptedLine(DottedDoubleArrowEdge, line);
    end;
    validate := true;
    close;
end;

procedure TfrmLineProp.Button2Click(Sender: TObject);
begin
    close;
end;

procedure TfrmLineProp.Button3Click(Sender: TObject);
begin
    FontDialog1.Font.Name := line.Properties.fontText.Name;
    FontDialog1.Font.Size := line.Properties.fontText.Size;
    FontDialog1.Font.Style := line.Properties.fontText.Style;
    FontDialog1.Font.Color := line.Properties.fontText.Color;
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

procedure TfrmLineProp.FormCreate(Sender: TObject);
begin
    GradienteVertical(Image2, clwhite, clgray);
    validate := false;
end;

procedure TfrmLineProp.FormShow(Sender: TObject);
var
    ft: TFont;
    sizeText: integer;
begin
    ft := TFont.Create;
    ft.Name := 'Calibri';
    ft.Size := 12;
    ft.Style := ft.Style + [fsBold];
    sizeText := Image2.Canvas.textWidth('Edge Properties ' + line.Id);
    DrawTextOrientation(Image2.Canvas, Point(1, 235 + (sizeText div 2)), 90, ft, 'Edge Properties ' + line.Id);
    ft.free;

    spArrowLength.Value := line.Properties.LenArrow;
    cbLineColor.Selected := line.Properties.lineColor;
    chkFilled.Checked := line.Properties.Filled;
    cbFillColor.Selected := line.Properties.FillColor;
    cbSelectedColor.Selected := line.Properties.SelectedColor;
    rbNormalArrow.Checked := (line.ArrowKind = Normal);
    rbFashionArrow.Checked := (line.ArrowKind = Fashion);

    if (line is TAbstractSimpleEdge) or (line is TAbstractSimpleArrowEdge) or (line is TAbstractSimpleDoubleArrowEdge) then
        rbNormal.Checked := true
    else
        rbDotted.Checked := true;

    if (line is TAbstractSimpleEdge) or (line is TAbstractDottedEdge) then
        rbStraight.Checked := true;

    if (line is TAbstractSimpleArrowEdge) or (line is TAbstractDottedArrowEdge) then
        rbArrowRight.Checked := true;

    if (line is TAbstractSimpleDoubleArrowEdge) or (line is TAbstractDottedDoubleArrowEdge) then
        rbDobleArrow.Checked := true;

    Memo1.lines.Text := line.Properties.Description.Text;
    edFont.Text := line.Properties.fontText.Name;
    textfont := line.Properties.fontText;
    penwidth.Value := line.Properties.penwidth;
    arrowAngle.Value := line.Properties.InclinationAngle;
end;

end.
