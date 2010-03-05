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
 unit frmOptions;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Spin, uOptions, ExtCtrls, Buttons;

type
    TfOptions = class(TForm)
        GroupBox1: TGroupBox;
        CheckBox1: TCheckBox;
        CheckBox2: TCheckBox;
        Label1: TLabel;
        spnPrecision: TSpinEdit;
        Label2: TLabel;
        Label3: TLabel;
        spnGridSize: TSpinEdit;
        Label4: TLabel;
        cbBackColor: TColorBox;
        cbGridColor: TColorBox;
        Label5: TLabel;
        Label6: TLabel;
        chkRewrite: TCheckBox;
        Label7: TLabel;
        cbBackProp: TColorBox;
        Label8: TLabel;
        cbSelection: TColorBox;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
        procedure Button1Click(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure Button2Click(Sender: TObject);
    private
        { Private declarations }
    public
        option: TOptionsApplication;
    end;

var
    fOptions: TfOptions;

implementation

{$R *.dfm}

procedure TfOptions.Button1Click(Sender: TObject);
begin
    if Assigned(option) then
    begin
        option.ShowGrid := CheckBox1.Checked;
        option.SnapToGrid := CheckBox2.Checked;
        option.MovementPrecision := spnPrecision.Value;
        option.gridSize := spnGridSize.Value;
        option.BackGroundColor := cbBackColor.Selected;
        option.GridColor := cbGridColor.Selected;
        option.RewriteOnFilling := chkRewrite.Checked;
        option.BackGroundProperties := cbBackProp.Selected;
        option.SelectionColorMark := cbSelection.Selected;
        option.SaveToFile;
        close;
    end;
end;

procedure TfOptions.Button2Click(Sender: TObject);
begin
    close;
end;

procedure TfOptions.FormShow(Sender: TObject);
begin
    if Assigned(option) then
    begin
        CheckBox1.Checked := option.ShowGrid;
        CheckBox2.Checked := option.SnapToGrid;
        spnPrecision.Value := option.MovementPrecision;
        spnGridSize.Value := option.gridSize;
        cbBackColor.Selected := option.BackGroundColor;
        cbGridColor.Selected := option.GridColor;
        chkRewrite.Checked := option.RewriteOnFilling;
        cbBackProp.Selected := option.BackGroundProperties;
        cbSelection.Selected := option.SelectionColorMark;
    end;
end;

end.
