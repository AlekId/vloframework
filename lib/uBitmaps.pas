unit uBitmaps;

interface

uses
    Windows, Classes, SysUtils, Graphics, Forms;

Const PixelMax = 32768;
Type
   pPixelArray = ^TPixelArray;
   TPixelArray = Array[0..PixelMax-1] Of TRGBTriple;

Procedure RotateBitmap_ads(
   SourceBitmap : TBitmap;
   out DestBitmap : TBitmap;
   Center : TPoint;
   Angle : Double) ;

implementation

Procedure RotateBitmap_ads(
   SourceBitmap : TBitmap;
   out DestBitmap : TBitmap;
   Center : TPoint;
   Angle : Double) ;
Var
   cosRadians : Double;
   inX : Integer;
   inXOriginal : Integer;
   inXPrime : Integer;
   inXPrimeRotated : Integer;
   inY : Integer;
   inYOriginal : Integer;
   inYPrime : Integer;
   inYPrimeRotated : Integer;
   OriginalRow : pPixelArray;
   Radians : Double;
   RotatedRow : pPixelArray;
   sinRadians : Double;
begin
   DestBitmap.Width := SourceBitmap.Width;
   DestBitmap.Height := SourceBitmap.Height;
   DestBitmap.PixelFormat := pf24bit;
   Radians := -(Angle) * PI / 180;
   sinRadians := Sin(Radians) ;
   cosRadians := Cos(Radians) ;
   For inX := DestBitmap.Height-1 Downto 0 Do
   Begin
     RotatedRow := DestBitmap.Scanline[inX];
     inXPrime := 2*(inX - Center.y) + 1;
     For inY := DestBitmap.Width-1 Downto 0 Do
     Begin
       inYPrime := 2*(inY - Center.x) + 1;
       inYPrimeRotated := Round(inYPrime * CosRadians - inXPrime * sinRadians) ;
       inXPrimeRotated := Round(inYPrime * sinRadians + inXPrime * cosRadians) ;
       inYOriginal := (inYPrimeRotated - 1) Div 2 + Center.x;
       inXOriginal := (inXPrimeRotated - 1) Div 2 + Center.y;
       If
         (inYOriginal >= 0) And
         (inYOriginal <= SourceBitmap.Width-1) And
         (inXOriginal >= 0) And
         (inXOriginal <= SourceBitmap.Height-1)
       Then
       Begin
         OriginalRow := SourceBitmap.Scanline[inXOriginal];
         RotatedRow[inY] := OriginalRow[inYOriginal]
       End
       Else
       Begin
         RotatedRow[inY].rgbtBlue := 255;
         RotatedRow[inY].rgbtGreen := 0;
         RotatedRow[inY].rgbtRed := 0
       End;
     End;
   End;
End;

end.
