unit defaultProperties;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls, Spin, inifiles, uProperties;

type
    TfrmDefault = class(TForm)
        penWidth: TSpinEdit;
        Label6: TLabel;
        Label2: TLabel;
        cbBoxColor: TColorBox;
        Label3: TLabel;
        cbLineColor: TColorBox;
        Label4: TLabel;
        cbSelectedColor: TColorBox;
        imgBox: TImage;
        Button1: TButton;
        Label1: TLabel;
        spArrowLength: TSpinEdit;
        Label5: TLabel;
        spPenWidth: TSpinEdit;
        Label7: TLabel;
        arrowAngle: TSpinEdit;
        Label8: TLabel;
        ColorBox1: TColorBox;
        chkFilled: TCheckBox;
        Label9: TLabel;
        cbFillColor: TColorBox;
        Label10: TLabel;
        ColorBox2: TColorBox;
        imgLine: TImage;
        Button2: TButton;
        Image2: TImage;
        procedure FormCreate(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure penWidthChange(Sender: TObject);
        procedure cbBoxColorChange(Sender: TObject);
        procedure chkFilledClick(Sender: TObject);
    private
        procedure GetSettings;
        procedure SaveSettings;
        procedure drawRectangle;
        procedure Draw;
        procedure DrawFashionArrow(Source, Target: TPoint; inside: boolean);
        { Private declarations }
    public
        DefaultLineProperty: TEdgeProperty;
        DefaultBoxProperty: TNodeProperty;
    end;

var
    frmDefault: TfrmDefault;

implementation

uses
    uText, uMath, Math;
{$R *.dfm}

procedure TfrmDefault.Button1Click(Sender: TObject);
begin
    SaveSettings;
    Close;
end;

procedure TfrmDefault.FormCreate(Sender: TObject);
var
    ft: TFont;
    sizeText: integer;
begin
    GradienteVertical(Image2, clwhite, clgray);
    drawRectangle();
    ft := TFont.Create;
    ft.Name := 'Calibri';
    ft.Size := 12;
    ft.Style := ft.Style + [fsBold];
    sizeText := Image2.Canvas.textWidth('Default Properties');
    DrawTextOrientation(Image2.Canvas, Point(1, 170 + (sizeText div 2)), 90, ft, 'Default Properties');
    ft.free;
    GetSettings;
end;

procedure TfrmDefault.GetSettings;
var
    ini: TIniFile;
begin
    ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
        penWidth.Value := StrToInt(ini.ReadString('NODE', 'PenWidth', '1'));
        cbBoxColor.Selected := StrToInt(ini.ReadString('NODE', 'BoxColor', '16777215'));
        cbLineColor.Selected := StrToInt(ini.ReadString('NODE', 'LineColor', '0'));
        cbSelectedColor.Selected := StrToInt(ini.ReadString('NODE', 'SelectedColor', '255'));

        spArrowLength.Value := StrToInt(ini.ReadString('EDGE', 'ArrowLength', '12'));
        spPenWidth.Value := StrToInt(ini.ReadString('EDGE', 'PenWidth', '1'));
        arrowAngle.Value := StrToInt(ini.ReadString('EDGE', 'ArrowAngle', '30'));
        ColorBox1.Selected := StrToInt(ini.ReadString('EDGE', 'LineColor', '0'));
        chkFilled.Checked := StrToBool(ini.ReadString('EDGE', 'Filled', '0'));
        cbFillColor.Selected := StrToInt(ini.ReadString('EDGE', 'FillColor', '0'));
        ColorBox2.Selected := StrToInt(ini.ReadString('EDGE', 'SelectedColor', '255'));
        Draw();
    finally
        ini.free;
    end;
end;

procedure TfrmDefault.penWidthChange(Sender: TObject);
begin
    if (Sender as TSpinEdit).Text <> '' then
        Draw();
end;

procedure TfrmDefault.SaveSettings;
var
    ini: TIniFile;
begin
    ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
        ini.WriteString('NODE', 'PenWidth', InttoStr(penWidth.Value));
        ini.WriteString('NODE', 'BoxColor', InttoStr(cbBoxColor.Selected));
        ini.WriteString('NODE', 'LineColor', InttoStr(cbLineColor.Selected));
        ini.WriteString('NODE', 'SelectedColor', InttoStr(cbSelectedColor.Selected));

        if Assigned(DefaultBoxProperty) then
        begin
            DefaultBoxProperty.penWidth := penWidth.Value;
            DefaultBoxProperty.FillColor := cbBoxColor.Selected;
            DefaultBoxProperty.LineColor := cbLineColor.Selected;
            DefaultBoxProperty.SelectedColor := cbSelectedColor.Selected;
        end;

        ini.WriteString('EDGE', 'ArrowLength', InttoStr(spArrowLength.Value));
        ini.WriteString('EDGE', 'PenWidth', InttoStr(spPenWidth.Value));
        ini.WriteString('EDGE', 'ArrowAngle', InttoStr(arrowAngle.Value));
        ini.WriteString('EDGE', 'LineColor', InttoStr(ColorBox1.Selected));
        ini.WriteString('EDGE', 'Filled', BoolToStr(chkFilled.Checked));
        ini.WriteString('EDGE', 'FillColor', InttoStr(cbFillColor.Selected));
        ini.WriteString('EDGE', 'SelectedColor', InttoStr(ColorBox2.Selected));

        if Assigned(DefaultLineProperty) then
        begin
            DefaultLineProperty.LenArrow := spArrowLength.Value;
            DefaultLineProperty.penWidth := spPenWidth.Value;
            DefaultLineProperty.InclinationAngle := arrowAngle.Value;
            DefaultLineProperty.LineColor := ColorBox1.Selected;
            DefaultLineProperty.Filled := chkFilled.Checked;
            DefaultLineProperty.FillColor := cbFillColor.Selected;
            DefaultLineProperty.SelectedColor := ColorBox2.Selected;
        end;

    finally
        ini.free;
    end;
end;

procedure TfrmDefault.Button2Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmDefault.cbBoxColorChange(Sender: TObject);
begin
    Draw();
end;

procedure TfrmDefault.chkFilledClick(Sender: TObject);
begin
    Draw();
end;

procedure TfrmDefault.drawRectangle();
begin
    imgBox.Canvas.Brush.Style := bsSolid;
    imgBox.Canvas.Brush.color := clwhite;
    imgBox.Canvas.Pen.width := 2;
    imgBox.Canvas.Pen.color := clBlack;
    imgBox.Canvas.Rectangle(0, 0, imgBox.width, imgBox.height);

    imgLine.Canvas.Brush.Style := bsSolid;
    imgLine.Canvas.Brush.color := clwhite;
    imgLine.Canvas.Pen.width := 2;
    imgLine.Canvas.Pen.color := clBlack;
    imgLine.Canvas.Rectangle(0, 0, imgLine.width, imgLine.height);
end;

procedure TfrmDefault.Draw();
begin
    drawRectangle();
    imgBox.Canvas.Brush.Style := bsSolid;
    imgBox.Canvas.Brush.color := cbBoxColor.Selected;
    imgBox.Canvas.Pen.width := penWidth.Value;
    imgBox.Canvas.Brush.color := cbBoxColor.Selected;
    imgBox.Canvas.Pen.color := cbLineColor.Selected;
    imgBox.Canvas.Rectangle(40, 20, 90, 70);
    imgBox.Canvas.Pen.color := cbSelectedColor.Selected;
    imgBox.Canvas.Rectangle(75, 55, 125, 105);

    DrawFashionArrow(Point(10, 30), Point(160, 30), false);
    DrawFashionArrow(Point(10, 70), Point(160, 70), true);
end;

procedure TfrmDefault.DrawFashionArrow(Source, Target: TPoint; inside: boolean);
    function CalcPoint(p: TPoint; angle: double; Distance: integer): TPoint;
    var
        X, Y, M: double;
    begin
        if Comparar(Abs(angle), (PI / 2), '<>') then
        begin
            if Comparar(Abs(angle), (PI / 2), '<') then
                Distance := -Distance;
            M := Tan(angle);
            X := p.X + Distance / sqrt(1 + sqr(M));
            Y := p.Y + M * (X - p.X);
            Result := Point(round(X), round(Y));
        end
        else
        begin
            if angle > 0 then
                Distance := -Distance;
            Result := Point(p.X, p.Y + Distance);
        end;
    end;

var
    angle: double;
    PArrow: array [1 .. 4] of TPoint;
    restColor: TColor;
begin
    angle := ArcTan2((Target.Y - Source.Y), (Target.X - Source.X));
    PArrow[1] := Target;
    PArrow[2] := CalcPoint(Target, angle + degToRad(arrowAngle.Value), spArrowLength.Value);
    PArrow[3] := CalcPoint(Target, angle, 2 * spArrowLength.Value div 3);
    PArrow[4] := CalcPoint(Target, angle - degToRad(arrowAngle.Value), spArrowLength.Value); // pi/9

    imgLine.Canvas.Pen.width := spPenWidth.Value;
    if inside then
        imgLine.Canvas.Pen.color := ColorBox2.Selected
    else
        imgLine.Canvas.Pen.color := ColorBox1.Selected;
    imgLine.Canvas.Brush.Style := bsSolid;
    restColor := imgLine.Canvas.Brush.color;
    if chkFilled.Checked then
        imgLine.Canvas.Brush.color := cbFillColor.Selected;
    imgLine.Canvas.MoveTo(Source.X, Source.Y);
    imgLine.Canvas.LineTo(Target.X, Target.Y);
    imgLine.Canvas.Polygon(PArrow);
    imgLine.Canvas.Brush.color := restColor;
end;

end.
