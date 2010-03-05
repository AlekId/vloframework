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
unit uLog;

interface

uses
    StdCtrls, ComCtrls;

type
    TLogObject = class(TObject)
    private
        FMemo: TMemo;
        FListView: TListView;
        FSaveToDisk: Boolean;
        FaddTimeStamp: Boolean;
        procedure SetaddTimeStamp(const Value: Boolean);
        procedure SetSaveToDisk(const Value: Boolean);
        procedure SaveToFile(description: string);
    public
        property SaveToDisk: Boolean read FSaveToDisk write SetSaveToDisk;
        property addTimeStamp: Boolean read FaddTimeStamp write SetaddTimeStamp;
        constructor Create(memo: TMemo); overload;
        constructor Create(ListView: TListView); overload;
        destructor Destroy; Override;
        procedure add(s: string);
        procedure Clear;
    end;

implementation

uses
    Windows, SysUtils;

{ TLogObject }

procedure TLogObject.add(s: string);
var
    sText: string;
begin
    sText := '';
    if FaddTimeStamp and (s <> '') then
        sText := sText + DateTimeToStr(Now) + ' ';
    sText := sText + s;
    if Assigned(FMemo) then
        FMemo.Lines.add(sText);
    if Assigned(FListView) then
        FListView.Items.add.Caption := sText;
    SaveToFile(sText);
end;

procedure TLogObject.Clear;
begin
    if Assigned(FMemo) then
        Self.FMemo.Clear;
    if Assigned(FListView) then
        FListView.Items.Clear;
    if FileExists(ExtractFilePath(ParamStr(0)) + '\app.log') then
        DeleteFile(ExtractFilePath(ParamStr(0)) + '\app.log');
end;

constructor TLogObject.Create(ListView: TListView);
begin
    Self.FListView := ListView;
end;

constructor TLogObject.Create(memo: TMemo);
begin
    Self.FMemo := memo;
end;

destructor TLogObject.Destroy;
begin
    Self.FMemo := nil;
    inherited;
end;

procedure TLogObject.SaveToFile(description: string);
var
    LogFile: TextFile;
begin
    if not FSaveToDisk then
        Exit;
    AssignFile(LogFile, ExtractFilePath(ParamStr(0)) + '\app.log');
    try
        if FileExists(ExtractFilePath(ParamStr(0)) + '\app.log') then
            Append(LogFile) // If existing file
        else
            Rewrite(LogFile); // Create if new
        WRITELN(LogFile, description);
        CloseFile(LogFile) except
    end;
end;

procedure TLogObject.SetaddTimeStamp(const Value: Boolean);
begin
    FaddTimeStamp := Value;
end;

procedure TLogObject.SetSaveToDisk(const Value: Boolean);
begin
    FSaveToDisk := Value;
end;

end.
