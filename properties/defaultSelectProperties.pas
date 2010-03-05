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
 unit defaultSelectProperties;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, StdCtrls, Spin, uProperties, inifiles, uOptions, Buttons;

type
    TfrmSelectProperties = class(TForm)
        Image2: TImage;
        imgBox: TImage;
        Label6: TLabel;
        penWidth: TSpinEdit;
        Label2: TLabel;
        cbBoxColor: TColorBox;
        Label3: TLabel;
        cbLineColor: TColorBox;
        Label4: TLabel;
        cbSelectedColor: TColorBox;
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
        Label13: TLabel;
        Label11: TLabel;
        edFont1: TEdit;
        Button3: TButton;
        edFont2: TEdit;
        Button4: TButton;
        FontDialog1: TFontDialog;
        SpeedButton3: TSpeedButton;
        SpeedButton4: TSpeedButton;
        Label19: TLabel;
        cbColorIfImage: TColorBox;
        procedure FormCreate(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure spPenWidthChange(Sender: TObject);
        procedure cbBoxColorChange(Sender: TObject);
        procedure chkFilledClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure Button4Click(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    private
        textFont1: TFont;
        textFont2: TFont;
        procedure GetSettings;
        procedure SaveSettings;
        procedure drawRectangle;
        procedure Draw;
        procedure DrawFashionArrow(Source, Target: TPoint; inside: boolean; default: boolean);
    public
        DefaultEdgeProperty: TEdgeProperty;
        DefaultNodeProperty: TNodeProperty;
        DefaultOriginNodeProperty: TNodeProperty;
        DefaultDestinyNodeProperty: TNodeProperty;
        DefaultSelectedEdgeProperty: TEdgeProperty;
        DefaultSelectedNodeProperty: TNodeProperty;
        option: TOptionsApplication;
    end;

var
    frmSelectProperties: TfrmSelectProperties;

implementation

uses
    uMath, uText, Math, uIniProperties, uFonts;
{$R *.dfm}
{ TfrmSelectProperties }

procedure TfrmSelectProperties.Button1Click(Sender: TObject);
begin
    SaveSettings;
    Close;
end;

procedure TfrmSelectProperties.Button2Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmSelectProperties.Button3Click(Sender: TObject);
begin
    AssignDialogFont(FontDialog1, DefaultNodeProperty.fontText);
    with FontDialog1 do
        if Execute then
        begin
            AssignFont(textFont1, Font);
            AssignEditFont(edFont1, textFont1);
            Draw();
        end;
end;

procedure TfrmSelectProperties.Button4Click(Sender: TObject);
begin
    AssignDialogFont(FontDialog1, DefaultEdgeProperty.fontText);
    with FontDialog1 do
        if Execute then
        begin
            AssignFont(textFont2, Font);
            AssignEditFont(edFont2, textFont2);
            Draw();
        end;
end;

procedure TfrmSelectProperties.cbBoxColorChange(Sender: TObject);
begin
    Draw();
end;

procedure TfrmSelectProperties.chkFilledClick(Sender: TObject);
begin
    Draw();
end;

procedure TfrmSelectProperties.Draw;
begin
    drawRectangle();
    // Primer les fletxes
    DrawFashionArrow(Point(184, 35), Point(91, 69), false, false);
    DrawFashionArrow(Point(184, 35), Point(275, 69), false, true);

    DrawFashionArrow(Point(91, 81), Point(47, 115), false, false);
    DrawFashionArrow(Point(91, 81), Point(138, 115), false, true);
    DrawFashionArrow(Point(275, 81), Point(229, 115), false, true);
    DrawFashionArrow(Point(275, 81), Point(320, 115), true, true);

    if Assigned(DefaultOriginNodeProperty) then
    begin
        imgBox.Canvas.Brush.Style := bsSolid;
        imgBox.Canvas.Brush.Color := DefaultOriginNodeProperty.FillColor;
        imgBox.Canvas.Pen.width := 4;
        imgBox.Canvas.Pen.Color := DefaultOriginNodeProperty.LineColor;
    end;

    // Primer rectangle
    imgBox.Canvas.Rectangle(172, 23, 195, 46);

    // Segon nivell
    imgBox.Canvas.Brush.Style := bsSolid;
    imgBox.Canvas.Brush.Color := cbBoxColor.Selected;
    imgBox.Canvas.Pen.width := penWidth.Value;
    imgBox.Canvas.Brush.Color := cbBoxColor.Selected;
    imgBox.Canvas.Pen.Color := cbLineColor.Selected;
    imgBox.Canvas.Rectangle(79, 69, 102, 92);
    DrawTextOrientation(imgBox.Canvas, Point(79 + 2, 69 + 2), 0, textFont1, '1', false, clWhite);

    if Assigned(DefaultNodeProperty) then
    begin
        imgBox.Canvas.Brush.Style := bsSolid;
        imgBox.Canvas.Brush.Color := DefaultNodeProperty.FillColor;
        imgBox.Canvas.Pen.width := DefaultNodeProperty.penWidth;
        imgBox.Canvas.Pen.Color := DefaultNodeProperty.LineColor;
    end;
    imgBox.Canvas.Rectangle(263, 69, 286, 92);

    // Tercer nivell
    if Assigned(DefaultDestinyNodeProperty) then
    begin
        imgBox.Canvas.Brush.Style := bsSolid;
        imgBox.Canvas.Brush.Color := DefaultDestinyNodeProperty.FillColor;
        imgBox.Canvas.Pen.width := 4;
        imgBox.Canvas.Pen.Color := DefaultDestinyNodeProperty.LineColor;
    end;

    imgBox.Canvas.Rectangle(35, 115, 58, 138);
    imgBox.Canvas.Rectangle(126, 115, 149, 138);
    imgBox.Canvas.Rectangle(217, 115, 240, 138);
    imgBox.Canvas.Rectangle(308, 115, 331, 138);
end;

procedure TfrmSelectProperties.DrawFashionArrow(Source, Target: TPoint; inside: boolean; default: boolean);
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
    arrow, arrowlength, penWidth, Color, colorSel, FillColor: integer;
begin
    if default and Assigned(DefaultEdgeProperty) then
    begin
        arrow := DefaultEdgeProperty.InclinationAngle;
        arrowlength := DefaultEdgeProperty.LenArrow;
        penWidth := DefaultEdgeProperty.penWidth;
        Color := DefaultEdgeProperty.LineColor;
        colorSel := DefaultEdgeProperty.SelectedColor;
        FillColor := DefaultEdgeProperty.FillColor;
    end
    else
    begin
        arrow := arrowAngle.Value;
        arrowlength := spArrowLength.Value;
        penWidth := spPenWidth.Value;
        Color := ColorBox1.Selected;
        colorSel := ColorBox2.Selected;
        FillColor := cbFillColor.Selected;
    end;

    angle := ArcTan2((Target.Y - Source.Y), (Target.X - Source.X));
    PArrow[1] := Target;
    PArrow[2] := CalcPoint(Target, angle + degToRad(arrow), arrowlength);
    PArrow[3] := CalcPoint(Target, angle, 2 * arrowlength div 3);
    PArrow[4] := CalcPoint(Target, angle - degToRad(arrow), arrowlength); // pi/9

    imgBox.Canvas.Pen.width := penWidth;
    if inside then
        imgBox.Canvas.Pen.Color := colorSel
    else
        imgBox.Canvas.Pen.Color := Color;
    imgBox.Canvas.Brush.Style := bsSolid;
    restColor := imgBox.Canvas.Brush.Color;
    if chkFilled.Checked then
        imgBox.Canvas.Brush.Color := FillColor;
    imgBox.Canvas.MoveTo(Source.X, Source.Y);
    imgBox.Canvas.LineTo(Target.X, Target.Y);
    DrawTextOrientation(imgBox.Canvas, Point(Source.X - 20, Source.Y + 20), 0, textFont2, '1', false, clWhite);
    imgBox.Canvas.Polygon(PArrow);
    imgBox.Canvas.Brush.Color := restColor;
end;

procedure TfrmSelectProperties.drawRectangle;
begin
    if Assigned(option) then
    begin
        imgBox.Canvas.Brush.Style := bsSolid;
        imgBox.Canvas.Brush.Color := option.BackGroundProperties;
        imgBox.Canvas.Pen.width := 2;
        imgBox.Canvas.Pen.Color := clBlack;
        imgBox.Canvas.Rectangle(0, 0, imgBox.width, imgBox.height);
    end;
end;

procedure TfrmSelectProperties.FormCreate(Sender: TObject);
var
    ft: TFont;
    sizeText: integer;
begin
    GradienteVertical(Image2, clWhite, clgray);
    drawRectangle();
    ft := TFont.Create;
    ft.Name := 'Calibri';
    ft.Size := 12;
    ft.Style := ft.Style + [fsBold];
    sizeText := Image2.Canvas.textWidth('Default Selected Properties');
    DrawTextOrientation(Image2.Canvas, Point(1, 170 + (sizeText div 2)), 90, ft, 'Default Selected Properties', false, clWhite);
    ft.free;

    textFont1 := TFont.Create;
    textFont1.Name := 'Calibri';
    textFont1.Size := 12;
    textFont2 := TFont.Create;
    textFont2.Name := 'Calibri';
    textFont2.Size := 12;

    GetSettings;
end;

procedure TfrmSelectProperties.FormDestroy(Sender: TObject);
begin
    textFont1.free;
    textFont2.free;
end;

procedure TfrmSelectProperties.FormShow(Sender: TObject);
begin
    GetSettings();
    AssignEditFont(edFont1, DefaultNodeProperty.fontText);
    AssignEditFont(edFont2, DefaultEdgeProperty.fontText);
end;

procedure TfrmSelectProperties.GetSettings;
var
    ini: TIniFile;
begin
    ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
        penWidth.Value := StrToInt(ini.ReadString('SELECTEDNODE', 'PenWidth', '1'));
        cbBoxColor.Selected := StrToInt(ini.ReadString('SELECTEDNODE', 'BoxColor', '16777215'));
        cbLineColor.Selected := StrToInt(ini.ReadString('SELECTEDNODE', 'LineColor', '0'));
        cbSelectedColor.Selected := StrToInt(ini.ReadString('SELECTEDNODE', 'SelectedColor', '255'));
        cbColorIfImage.Selected := StrToInt(ini.ReadString('SELECTEDNODE', 'ColorifImage', '255'));
        if Assigned(DefaultSelectedNodeProperty) then
        begin
            FontDeserializer(ini, 'SELECTEDNODE', DefaultSelectedNodeProperty);
            AssignFont(textFont1, DefaultSelectedNodeProperty.fontText);
        end;

        spArrowLength.Value := StrToInt(ini.ReadString('SELECTEDEDGE', 'ArrowLength', '12'));
        spPenWidth.Value := StrToInt(ini.ReadString('SELECTEDEDGE', 'PenWidth', '1'));
        arrowAngle.Value := StrToInt(ini.ReadString('SELECTEDEDGE', 'ArrowAngle', '30'));
        ColorBox1.Selected := StrToInt(ini.ReadString('SELECTEDEDGE', 'LineColor', '0'));
        chkFilled.Checked := StrToBool(ini.ReadString('SELECTEDEDGE', 'Filled', '0'));
        cbFillColor.Selected := StrToInt(ini.ReadString('SELECTEDEDGE', 'FillColor', '0'));
        ColorBox2.Selected := StrToInt(ini.ReadString('SELECTEDEDGE', 'SelectedColor', '255'));
        if Assigned(DefaultSelectedEdgeProperty) then
        begin
            FontDeserializer(ini, 'SELECTEDEDGE', DefaultSelectedEdgeProperty);
            AssignFont(textFont2, DefaultSelectedEdgeProperty.fontText);
        end;
        Draw();
    finally
        ini.free;
    end;
end;

procedure TfrmSelectProperties.SaveSettings;
var
    ini: TIniFile;
begin
    ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
        ini.WriteString('SELECTEDNODE', 'PenWidth', InttoStr(penWidth.Value));
        ini.WriteString('SELECTEDNODE', 'BoxColor', InttoStr(cbBoxColor.Selected));
        ini.WriteString('SELECTEDNODE', 'LineColor', InttoStr(cbLineColor.Selected));
        ini.WriteString('SELECTEDNODE', 'SelectedColor', InttoStr(cbSelectedColor.Selected));
        ini.WriteString('SELECTEDNODE', 'ColorifImage', InttoStr(cbColorIfImage.Selected));

        if Assigned(DefaultSelectedNodeProperty) then
        begin
            DefaultSelectedNodeProperty.penWidth := penWidth.Value;
            DefaultSelectedNodeProperty.FillColor := cbBoxColor.Selected;
            DefaultSelectedNodeProperty.LineColor := cbLineColor.Selected;
            DefaultSelectedNodeProperty.SelectedColor := cbSelectedColor.Selected;
            DefaultSelectedNodeProperty.AssignText(textFont1);
            FontSerializer(ini, 'SELECTEDNODE', DefaultSelectedNodeProperty.fontText);
        end;

        ini.WriteString('SELECTEDEDGE', 'ArrowLength', InttoStr(spArrowLength.Value));
        ini.WriteString('SELECTEDEDGE', 'PenWidth', InttoStr(spPenWidth.Value));
        ini.WriteString('SELECTEDEDGE', 'ArrowAngle', InttoStr(arrowAngle.Value));
        ini.WriteString('SELECTEDEDGE', 'LineColor', InttoStr(ColorBox1.Selected));
        ini.WriteString('SELECTEDEDGE', 'Filled', BoolToStr(chkFilled.Checked));
        ini.WriteString('SELECTEDEDGE', 'FillColor', InttoStr(cbFillColor.Selected));
        ini.WriteString('SELECTEDEDGE', 'SelectedColor', InttoStr(ColorBox2.Selected));

        if Assigned(DefaultSelectedEdgeProperty) then
        begin
            DefaultSelectedEdgeProperty.LenArrow := spArrowLength.Value;
            DefaultSelectedEdgeProperty.penWidth := spPenWidth.Value;
            DefaultSelectedEdgeProperty.InclinationAngle := arrowAngle.Value;
            DefaultSelectedEdgeProperty.LineColor := ColorBox1.Selected;
            DefaultSelectedEdgeProperty.Filled := chkFilled.Checked;
            DefaultSelectedEdgeProperty.FillColor := cbFillColor.Selected;
            DefaultSelectedEdgeProperty.SelectedColor := ColorBox2.Selected;
            DefaultSelectedEdgeProperty.AssignText(textFont2);
            FontSerializer(ini, 'SELECTEDEDGE', DefaultSelectedEdgeProperty.fontText);
        end;

    finally
        ini.free;
    end;
end;

procedure TfrmSelectProperties.spPenWidthChange(Sender: TObject);
begin
    if (Sender as TSpinEdit).Text <> '' then
        Draw();
end;

end.
