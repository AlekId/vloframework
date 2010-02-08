unit frmOptions;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Spin, uOptions, ExtCtrls;

type
    TfOptions = class(TForm)
        GroupBox1: TGroupBox;
        CheckBox1: TCheckBox;
        CheckBox2: TCheckBox;
        Label1: TLabel;
        spnPrecision: TSpinEdit;
        Button1: TButton;
        Button2: TButton;
        Label2: TLabel;
        Label3: TLabel;
        spnGridSize: TSpinEdit;
        Label4: TLabel;
        cbBackColor: TColorBox;
        cbGridColor: TColorBox;
        Label5: TLabel;
        Label6: TLabel;
        procedure Button1Click(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure Button2Click(Sender: TObject);
    private
        { Private declarations }
    public
        option: TOptionsApplication end;

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
    end;
end;

end.
