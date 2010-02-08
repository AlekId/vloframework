unit frmLayout;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, uLayout;

type
    TfLayout = class(TForm)
        GroupBox1: TGroupBox;
        repEpsilon: TEdit;
        Label1: TLabel;
        GroupBox2: TGroupBox;
        Label2: TLabel;
        attEpsilon: TEdit;
        Label3: TLabel;
        repLyEpsilon: TEdit;
        repLyOffset: TEdit;
        Label4: TLabel;
        Label5: TLabel;
        attlyEpsilon: TEdit;
        Label6: TLabel;
        attLyOffset: TEdit;
        GroupBox3: TGroupBox;
        Label7: TLabel;
        Label8: TLabel;
        Label9: TLabel;
        speed: TEdit;
        friction: TEdit;
        changelimit: TEdit;
        Label10: TLabel;
        maxSpeed: TEdit;
        MaxSteps: TEdit;
        Label11: TLabel;
        Button1: TButton;
        Button2: TButton;
        chkStop: TCheckBox;
        Button3: TButton;
        chkEnergy: TCheckBox;
        chkCenter: TCheckBox;
        procedure FormShow(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
    private
        { Private declarations }
    public
        layout: TLayoutApplication;
    end;

const
    mask = '#0.##########';

var
    fLayout: TfLayout;

implementation

{$R *.dfm}

procedure TfLayout.Button1Click(Sender: TObject);
begin
    if Assigned(layout) then
    begin
        layout.epsilon_repulsive_force := StrToFloat(repEpsilon.Text);
        layout.epsilon_repulsive_lying_nodes := StrToFloat(repLyEpsilon.Text);
        layout.epsilon_repulsive_lying_nodes_offset := StrToFloat(repLyOffset.Text);

        layout.epsilon_attractive_force := StrToFloat(attEpsilon.Text);
        layout.epsilon_attractive_lying_nodes := StrToFloat(attlyEpsilon.Text);
        layout.epsilon_attractive_lying_nodes_offset := StrToFloat(attLyOffset.Text);

        layout.speed_offset := StrToFloat(speed.Text);
        layout.friction := StrToFloat(friction.Text);
        layout.energy_change_limit := StrToFloat(changelimit.Text);
        layout.maximum_speed := StrToFloat(maxSpeed.Text);
        layout.max_steps_to_stop := StrToInt(MaxSteps.Text);
        layout.show_every_step := chkStop.Checked;
        layout.showEnergy := chkEnergy.Checked;
        layout.centerGraph := chkCenter.Checked;
        layout.SaveToFile;
        close;
    end;
end;

procedure TfLayout.Button2Click(Sender: TObject);
begin
    close;
end;

procedure TfLayout.Button3Click(Sender: TObject);
begin
    repEpsilon.Text := FormatFloat(mask, 100);
    repLyEpsilon.Text := FormatFloat(mask, 1);
    repLyOffset.Text := FormatFloat(mask, 0.5);

    attEpsilon.Text := FormatFloat(mask, 100);
    attlyEpsilon.Text := FormatFloat(mask, 10);
    attLyOffset.Text := FormatFloat(mask, 0.5);

    speed.Text := FormatFloat(mask, 0.1);
    friction.Text := FormatFloat(mask, 5);
    changelimit.Text := FormatFloat(mask, 0.000001);
    maxSpeed.Text := FormatFloat(mask, 1);
    MaxSteps.Text := InttoStr(2000);
    chkStop.Checked := true;
    chkEnergy.Checked := true;
    chkCenter.Checked := true;
end;

procedure TfLayout.FormShow(Sender: TObject);
begin
    if Assigned(layout) then
    begin
        repEpsilon.Text := FormatFloat(mask, layout.epsilon_repulsive_force);
        repLyEpsilon.Text := FormatFloat(mask, layout.epsilon_repulsive_lying_nodes);
        repLyOffset.Text := FormatFloat(mask, layout.epsilon_repulsive_lying_nodes_offset);

        attEpsilon.Text := FormatFloat(mask, layout.epsilon_attractive_force);
        attlyEpsilon.Text := FormatFloat(mask, layout.epsilon_attractive_lying_nodes);
        attLyOffset.Text := FormatFloat(mask, layout.epsilon_attractive_lying_nodes_offset);

        speed.Text := FormatFloat(mask, layout.speed_offset);
        friction.Text := FormatFloat(mask, layout.friction);
        changelimit.Text := FormatFloat(mask, layout.energy_change_limit);
        maxSpeed.Text := FormatFloat(mask, layout.maximum_speed);
        MaxSteps.Text := InttoStr(layout.max_steps_to_stop);
        chkStop.Checked := layout.show_every_step;
        chkEnergy.Checked := layout.showEnergy;
        chkCenter.Checked := layout.centerGraph;
    end;
end;

end.
