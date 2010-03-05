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
 unit defaultOriginProperties;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, Spin, uProperties, inifiles, uOptions, Buttons;

type
    TfrmOriginProperties = class(TForm)
        Image2: TImage;
        imgBox1: TImage;
        Label6: TLabel;
        penWidth1: TSpinEdit;
        Label2: TLabel;
        cbBoxColor1: TColorBox;
        Label3: TLabel;
        cbLineColor1: TColorBox;
        Label4: TLabel;
        cbSelectedColor1: TColorBox;
        imgBox2: TImage;
        Label1: TLabel;
        penWidth2: TSpinEdit;
        Label5: TLabel;
        cbBoxColor2: TColorBox;
        Label7: TLabel;
        cbLineColor2: TColorBox;
        Label8: TLabel;
        cbSelectedColor2: TColorBox;
        imgBox3: TImage;
        Label9: TLabel;
        Label10: TLabel;
        Label11: TLabel;
        Label12: TLabel;
        penWidth3: TSpinEdit;
        cbBoxColor3: TColorBox;
        cbLineColor3: TColorBox;
        cbSelectedColor3: TColorBox;
        edFont1: TEdit;
        Button3: TButton;
        Label13: TLabel;
        FontDialog1: TFontDialog;
        Label14: TLabel;
        Label15: TLabel;
        Label16: TLabel;
        edFont2: TEdit;
        Label17: TLabel;
        edFont3: TEdit;
        Label18: TLabel;
        Button4: TButton;
        Button5: TButton;
        SpeedButton3: TSpeedButton;
        SpeedButton4: TSpeedButton;
        Label19: TLabel;
        cbColorIfImage1: TColorBox;
        Label20: TLabel;
        cbColorIfImage2: TColorBox;
        cbColorIfImage3: TColorBox;
        Label21: TLabel;
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure cbBoxColor1Change(Sender: TObject);
        procedure penWidth1Change(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure Button4Click(Sender: TObject);
        procedure Button5Click(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    private
        textFont1: TFont;
        textFont2: TFont;
        textFont3: TFont;
        procedure GetSettings;
        procedure SaveSettings;
        procedure drawRectangle;
        procedure Draw;
    public
        DefaultOriginNodeProperty: TNodeProperty;
        DefaultDestinyNodeProperty: TNodeProperty;
        DefaultLinkNodeProperty: TNodeProperty;
        option: TOptionsApplication;
    end;

var
    frmOriginProperties: TfrmOriginProperties;

implementation

uses
    uText, uMath, Math, uIniProperties, uFonts;
{$R *.dfm}
{ TfrmOriginProperties }

procedure TfrmOriginProperties.Button1Click(Sender: TObject);
begin
    SaveSettings;
    Close;
end;

procedure TfrmOriginProperties.Button2Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmOriginProperties.Button3Click(Sender: TObject);
begin
    AssignDialogFont(FontDialog1, DefaultOriginNodeProperty.fontText);
    with FontDialog1 do
        if Execute then
        begin
            AssignFont(textFont1, Font);
            AssignEditFont(edFont1, textFont1);
            Draw();
        end;
end;

procedure TfrmOriginProperties.Button4Click(Sender: TObject);
begin
    AssignDialogFont(FontDialog1, DefaultDestinyNodeProperty.fontText);
    with FontDialog1 do
        if Execute then
        begin
            AssignFont(textFont2, Font);
            AssignEditFont(edFont2, textFont2);
            Draw();
        end;
end;

procedure TfrmOriginProperties.Button5Click(Sender: TObject);
begin
    AssignDialogFont(FontDialog1, DefaultLinkNodeProperty.fontText);
    with FontDialog1 do
        if Execute then
        begin
            AssignFont(textFont3, Font);
            AssignEditFont(edFont3, textFont3);
            Draw();
        end;
end;

procedure TfrmOriginProperties.cbBoxColor1Change(Sender: TObject);
begin
    Draw();
end;

procedure TfrmOriginProperties.Draw;
begin
    drawRectangle();
    imgBox1.Canvas.Brush.Style := bsSolid;
    imgBox1.Canvas.Brush.Color := cbBoxColor1.Selected;
    imgBox1.Canvas.Pen.width := penWidth1.Value;
    imgBox1.Canvas.Brush.Color := cbBoxColor1.Selected;
    imgBox1.Canvas.Pen.Color := cbLineColor1.Selected;
    imgBox1.Canvas.Rectangle(40, 20, 90, 70);
    imgBox1.Canvas.Pen.Color := cbSelectedColor1.Selected;
    imgBox1.Canvas.Rectangle(75, 55, 125, 105);
    DrawTextOrientation(imgBox1.Canvas, Point(40 + 2, 20 + 1), 0, textFont1, '1', false, clwhite);

    imgBox2.Canvas.Brush.Style := bsSolid;
    imgBox2.Canvas.Brush.Color := cbBoxColor2.Selected;
    imgBox2.Canvas.Pen.width := penWidth2.Value;
    imgBox2.Canvas.Brush.Color := cbBoxColor2.Selected;
    imgBox2.Canvas.Pen.Color := cbLineColor2.Selected;
    imgBox2.Canvas.Rectangle(40, 20, 90, 70);
    imgBox2.Canvas.Pen.Color := cbSelectedColor2.Selected;
    imgBox2.Canvas.Rectangle(75, 55, 125, 105);
    DrawTextOrientation(imgBox2.Canvas, Point(40 + 2, 20 + 1), 0, textFont2, '1', false, clwhite);

    imgBox3.Canvas.Brush.Style := bsSolid;
    imgBox3.Canvas.Brush.Color := cbBoxColor3.Selected;
    imgBox3.Canvas.Pen.width := penWidth3.Value;
    imgBox3.Canvas.Brush.Color := cbBoxColor3.Selected;
    imgBox3.Canvas.Pen.Color := cbLineColor3.Selected;
    imgBox3.Canvas.Rectangle(40, 20, 90, 70);
    imgBox3.Canvas.Pen.Color := cbSelectedColor3.Selected;
    imgBox3.Canvas.Rectangle(75, 55, 125, 105);
    DrawTextOrientation(imgBox3.Canvas, Point(40 + 2, 20 + 1), 0, textFont3, '1', false, clwhite);
end;

procedure TfrmOriginProperties.drawRectangle;
begin
    if Assigned(option) then
    begin
        imgBox1.Canvas.Brush.Style := bsSolid;
        imgBox1.Canvas.Brush.Color := option.BackGroundProperties;
        imgBox1.Canvas.Pen.width := 2;
        imgBox1.Canvas.Pen.Color := clBlack;
        imgBox1.Canvas.Rectangle(0, 0, imgBox1.width, imgBox1.height);

        imgBox2.Canvas.Brush.Style := bsSolid;
        imgBox2.Canvas.Brush.Color := option.BackGroundProperties;
        imgBox2.Canvas.Pen.width := 2;
        imgBox2.Canvas.Pen.Color := clBlack;
        imgBox2.Canvas.Rectangle(0, 0, imgBox2.width, imgBox2.height);

        imgBox3.Canvas.Brush.Style := bsSolid;
        imgBox3.Canvas.Brush.Color := option.BackGroundProperties;
        imgBox3.Canvas.Pen.width := 2;
        imgBox3.Canvas.Pen.Color := clBlack;
        imgBox3.Canvas.Rectangle(0, 0, imgBox3.width, imgBox3.height);
    end;
end;

procedure TfrmOriginProperties.FormCreate(Sender: TObject);
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

    textFont1 := TFont.Create;
    textFont1.Name := 'Calibri';
    textFont1.Size := 12;
    textFont2 := TFont.Create;
    textFont2.Name := 'Calibri';
    textFont2.Size := 12;
    textFont3 := TFont.Create;
    textFont3.Name := 'Calibri';
    textFont3.Size := 12;

    sizeText := Image2.Canvas.textWidth('Default Origin, Destiny Properties');
    DrawTextOrientation(Image2.Canvas, Point(1, 120 + (sizeText div 2)), 90, ft, 'Default Origin, Destiny Properties', false, clwhite);
    ft.free;
    GetSettings;
end;

procedure TfrmOriginProperties.FormDestroy(Sender: TObject);
begin
    textFont1.free;
    textFont2.free;
    textFont3.free;
end;

procedure TfrmOriginProperties.FormShow(Sender: TObject);
begin
    GetSettings();
    AssignEditFont(edFont1, DefaultOriginNodeProperty.fontText);
    AssignEditFont(edFont2, DefaultDestinyNodeProperty.fontText);
    AssignEditFont(edFont3, DefaultLinkNodeProperty.fontText);
end;

procedure TfrmOriginProperties.GetSettings;
var
    ini: TIniFile;
begin
    ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
        penWidth1.Value := StrToInt(ini.ReadString('ORIGINNODE', 'PenWidth', '4'));
        cbBoxColor1.Selected := StrToInt(ini.ReadString('ORIGINNODE', 'BoxColor', '458496'));
        cbLineColor1.Selected := StrToInt(ini.ReadString('ORIGINNODE', 'LineColor', '0'));
        cbSelectedColor1.Selected := StrToInt(ini.ReadString('ORIGINNODE', 'SelectedColor', '255'));
        cbColorIfImage1.Selected := StrToInt(ini.ReadString('ORIGINNODE', 'ColorifImage', '255'));
        if Assigned(DefaultOriginNodeProperty) then
        begin
            FontDeserializer(ini, 'ORIGINNODE', DefaultOriginNodeProperty);
            AssignFont(textFont1, DefaultOriginNodeProperty.fontText);
        end;

        penWidth2.Value := StrToInt(ini.ReadString('DESTINYNODE', 'PenWidth', '4'));
        cbBoxColor2.Selected := StrToInt(ini.ReadString('DESTINYNODE', 'BoxColor', '16318719'));
        cbLineColor2.Selected := StrToInt(ini.ReadString('DESTINYNODE', 'LineColor', '0'));
        cbSelectedColor2.Selected := StrToInt(ini.ReadString('DESTINYNODE', 'SelectedColor', '255'));
        cbColorIfImage2.Selected := StrToInt(ini.ReadString('DESTINYNODE', 'ColorifImage', '255'));
        if Assigned(DefaultDestinyNodeProperty) then
        begin
            FontDeserializer(ini, 'DESTINYNODE', DefaultDestinyNodeProperty);
            AssignFont(textFont2, DefaultDestinyNodeProperty.fontText);
        end;

        penWidth3.Value := StrToInt(ini.ReadString('LINKNODE', 'PenWidth', '4'));
        cbBoxColor3.Selected := StrToInt(ini.ReadString('LINKNODE', 'BoxColor', '33023'));
        cbLineColor3.Selected := StrToInt(ini.ReadString('LINKNODE', 'LineColor', '0'));
        cbSelectedColor3.Selected := StrToInt(ini.ReadString('LINKNODE', 'SelectedColor', '255'));
        cbColorIfImage3.Selected := StrToInt(ini.ReadString('LINKNODE', 'ColorifImage', '255'));
        if Assigned(DefaultLinkNodeProperty) then
        begin
            FontDeserializer(ini, 'LINKNODE', DefaultLinkNodeProperty);
            AssignFont(textFont3, DefaultLinkNodeProperty.fontText);
        end;

        Draw();
    finally
        ini.free;
    end;
end;

procedure TfrmOriginProperties.penWidth1Change(Sender: TObject);
begin
    if (Sender as TSpinEdit).Text <> '' then
        Draw();
end;

procedure TfrmOriginProperties.SaveSettings;
var
    ini: TIniFile;
begin
    ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
        ini.WriteString('ORIGINNODE', 'PenWidth', InttoStr(penWidth1.Value));
        ini.WriteString('ORIGINNODE', 'BoxColor', InttoStr(cbBoxColor1.Selected));
        ini.WriteString('ORIGINNODE', 'LineColor', InttoStr(cbLineColor1.Selected));
        ini.WriteString('ORIGINNODE', 'SelectedColor', InttoStr(cbSelectedColor1.Selected));
        ini.WriteString('ORIGINNODE', 'ColorifImage', InttoStr(cbColorIfImage1.Selected));

        if Assigned(DefaultOriginNodeProperty) then
        begin
            DefaultOriginNodeProperty.penWidth := penWidth1.Value;
            DefaultOriginNodeProperty.FillColor := cbBoxColor1.Selected;
            DefaultOriginNodeProperty.LineColor := cbLineColor1.Selected;
            DefaultOriginNodeProperty.SelectedColor := cbSelectedColor1.Selected;
            DefaultOriginNodeProperty.ColorifImage := cbColorIfImage1.Selected;
            DefaultOriginNodeProperty.AssignText(textFont1);
            FontSerializer(ini, 'ORIGINNODE', DefaultOriginNodeProperty.fontText);
        end;

        ini.WriteString('DESTINYNODE', 'PenWidth', InttoStr(penWidth2.Value));
        ini.WriteString('DESTINYNODE', 'BoxColor', InttoStr(cbBoxColor2.Selected));
        ini.WriteString('DESTINYNODE', 'LineColor', InttoStr(cbLineColor2.Selected));
        ini.WriteString('DESTINYNODE', 'SelectedColor', InttoStr(cbSelectedColor2.Selected));
        ini.WriteString('DESTINYNODE', 'ColorifImage', InttoStr(cbColorIfImage2.Selected));

        if Assigned(DefaultDestinyNodeProperty) then
        begin
            DefaultDestinyNodeProperty.penWidth := penWidth2.Value;
            DefaultDestinyNodeProperty.FillColor := cbBoxColor2.Selected;
            DefaultDestinyNodeProperty.LineColor := cbLineColor2.Selected;
            DefaultDestinyNodeProperty.SelectedColor := cbSelectedColor2.Selected;
            DefaultDestinyNodeProperty.ColorifImage := cbColorIfImage2.Selected;
            DefaultDestinyNodeProperty.AssignText(textFont2);
            FontSerializer(ini, 'DESTINYNODE', DefaultDestinyNodeProperty.fontText);
        end;

        ini.WriteString('LINKNODE', 'PenWidth', InttoStr(penWidth3.Value));
        ini.WriteString('LINKNODE', 'BoxColor', InttoStr(cbBoxColor3.Selected));
        ini.WriteString('LINKNODE', 'LineColor', InttoStr(cbLineColor3.Selected));
        ini.WriteString('LINKNODE', 'SelectedColor', InttoStr(cbSelectedColor3.Selected));
        ini.WriteString('LINKNODE', 'ColorifImage', InttoStr(cbColorIfImage3.Selected));

        if Assigned(DefaultLinkNodeProperty) then
        begin
            DefaultLinkNodeProperty.penWidth := penWidth3.Value;
            DefaultLinkNodeProperty.FillColor := cbBoxColor3.Selected;
            DefaultLinkNodeProperty.LineColor := cbLineColor3.Selected;
            DefaultLinkNodeProperty.SelectedColor := cbSelectedColor3.Selected;
            DefaultLinkNodeProperty.ColorifImage := cbColorIfImage3.Selected;
            DefaultLinkNodeProperty.AssignText(textFont3);
            FontSerializer(ini, 'LINKNODE', DefaultLinkNodeProperty.fontText);
        end;

    finally
        ini.free;
    end;
end;

end.
