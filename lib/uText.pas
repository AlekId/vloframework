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
unit uText;

interface

uses
    Graphics, Types, Windows, ExtCtrls, Math;

procedure DrawTextOrientation(canvas: TCanvas; position: TPoint; epsilon: integer; font: TFont; text: string; ExistImage : Boolean; ifImageColor : TColor);
procedure GradienteVertical(image: TImage; ColorOrigen, ColorDestino: TColor);

implementation

uses
    uZoom;

procedure DrawTextOrientation(canvas: TCanvas; position: TPoint; epsilon: integer; font: TFont; text: string; ExistImage : Boolean; ifImageColor : TColor);
    function iif(condition: boolean; resultTrue: integer; resultFalse: integer): integer;
    begin
        result := resultFalse;
        if Condition then
            result := resultTrue
    end;
var
    newFont, FontSelected: integer;
    FontSize : integer;
begin
    if text = '' then
        exit;
    FontSize := MulDiv(font.Size, 100, globalZoom);
    SetBkMode(canvas.handle, transparent);
    newFont := CreateFont(
        -FontSize,
        0,
        epsilon * 10,
        0,
        iif(fsBold in font.Style, FW_BOLD, FW_NORMAL),
        iif(fsItalic in font.Style, 1, 0),
        iif(fsUnderline in font.Style, 1, 0),
        iif(fsStrikeOut in font.Style, 1, 0),
        ANSI_CHARSET,
        OUT_TT_PRECIS,
        CLIP_DEFAULT_PRECIS,
        ANTIALIASED_QUALITY {PROOF_QUALITY},
        FF_DONTCARE,
        PChar(font.Name));

    if ExistImage then
        canvas.Font.Color := ifImageColor
    else
        canvas.font.color := font.color;
    FontSelected := SelectObject(canvas.handle, newFont);
    TextOut(canvas.handle, position.x, position.y, PChar(text), length(text));
    SelectObject(canvas.handle, FontSelected);
    DeleteObject(newFont);
end;

procedure GradienteVertical(image: TImage; ColorOrigen, ColorDestino: TColor);
    procedure ColorToRGB(iColor: TColor; var R, G, B: Byte);
    begin
        R := GetRValue(iColor);
        G := GetGValue(iColor);
        B := GetBValue(iColor);
    end;
var
    dif, dr, dg, db: Extended;
    r1, r2, g1, g2, b1, b2: Byte;
    R, G, B: Byte;
    i, j: integer;
begin
    ColorToRGB(ColorOrigen, R1, G1, B1);
    ColorToRGB(ColorDestino, R2, G2, B2);

    dif := image.ClientRect.Right - image.ClientRect.Left;
    dr := (R2 - R1) / dif;
    dg := (G2 - G1) / dif;
    db := (B2 - B1) / dif;

    j := 0;
    for i := image.ClientRect.Top to image.ClientRect.Bottom - 1 do
    begin
        R := R1 + Ceil(dr * j);
        G := G1 + Ceil(dg * j);
        B := B1 + Ceil(db * j);
        image.Canvas.Pen.Color := RGB(R, G, B);
        image.Canvas.MoveTo(i, image.ClientRect.Top);
        image.Canvas.LineTo(i, image.ClientRect.Bottom);
        j := j + 1;
    end;
end;

end.
