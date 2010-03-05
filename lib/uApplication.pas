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
unit uApplication;

interface

uses
    Windows, SysUtils, ShlObj;

function GetAppVersion: string;
function GetFolderDialog(Handle: Integer; Caption: string; var strFolder: string): Boolean;

implementation

function BrowseCallbackProc(hwnd: HWND; uMsg: UINT; lParam: LPARAM; lpData: LPARAM): Integer; stdcall;
begin
    if (uMsg = BFFM_INITIALIZED) then
        SendMessage(hwnd, BFFM_SETSELECTION, 1, lpData);
    BrowseCallbackProc := 0;
end;

function GetFolderDialog(Handle: Integer; Caption: string; var strFolder: string): Boolean;
const
    BIF_STATUSTEXT = $0004;
    BIF_NEWDIALOGSTYLE = $0040;
    BIF_RETURNONLYFSDIRS = $0080;
    BIF_SHAREABLE = $0100;
    BIF_USENEWUI = BIF_EDITBOX or BIF_NEWDIALOGSTYLE;
var
    BrowseInfo: TBrowseInfo;
    ItemIDList: PItemIDList;
    JtemIDList: PItemIDList;
    Path: PWideChar;
begin
    Result := False;
    Path := StrAlloc(MAX_PATH);
    SHGetSpecialFolderLocation(Handle, CSIDL_DRIVES, JtemIDList);
    with BrowseInfo do
    begin
        hwndOwner := GetActiveWindow;
        pidlRoot := JtemIDList;
        SHGetSpecialFolderLocation(hwndOwner, CSIDL_DRIVES, JtemIDList);
        pszDisplayName := StrAlloc(MAX_PATH);
        lpszTitle := PChar(Caption);
        lpfn := @BrowseCallbackProc;
        lParam := LongInt(PChar(strFolder));
    end;
    ItemIDList := SHBrowseForFolder(BrowseInfo);
    if (ItemIDList <> nil) then
        if SHGetPathFromIDList(ItemIDList, Path) then
        begin
            strFolder := Path;
            Result := True
       end;
end;

function GetAppVersion: string;
var
    Size, Size2: DWord;
    Pt, Pt2: Pointer;
begin
    Size := GetFileVersionInfoSize(PChar(ParamStr(0)), Size2);
    if Size > 0 then
    begin
        GetMem(Pt, Size);
        try
            GetFileVersionInfo(PChar(ParamStr(0)), 0, Size, Pt);
            VerQueryValue(Pt, '\', Pt2, Size2);
            with TVSFixedFileInfo(Pt2^) do
            begin
                Result := ' v' +
                    IntToStr(HiWord(dwFileVersionMS)) + '.' +
                    IntToStr(LoWord(dwFileVersionMS)) + '.' +
                    IntToStr(HiWord(dwFileVersionLS)) + ' Build ' +
                    IntToStr(LoWord(dwFileVersionLS));
            end;
        finally
            FreeMem(Pt);
        end;
    end;
end;

end.
