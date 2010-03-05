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
unit uPaths;

interface

uses
    uNode, uConnector, uLog, Grids, uArray, uRoutes;

type
    TPath = class(TObject)
    private
        FLog: TLogObject;
        FNodeList: TNodeList;
        FConnectorList: TConnectorList;
        sgCalc: TStringGrid;
        sgResult: TStringGrid;
        sgCalcRes: TStringGrid;
        sgResultRes: TStringGrid;
        InterlockList: TadjacentArray;
        procedure GetList(var Conn: TadjacentArray; Adjacent: TadjacentArray; node: Integer);
        function AllRowsFinished(filas: Integer; DestinoList: TArrayInteger): Boolean;
        function getLastColumn(fila: Integer): Integer;
        function CloneRow(fila: Integer; Connector: TadjacentArray): Integer;
    public
        OrigenList: TArrayInteger;
        DestinoList: TArrayInteger;
        constructor Create(nodeList: TNodeList; connectorList: TConnectorList; log: TLogObject; sgCalc, sgResult, sgCalcRes, sgResultRes : TStringGrid);
        destructor Destroy(); override;
        procedure Calc;
        procedure ExportRoutes();
        procedure Initialize();
    end;

implementation

uses
    SysUtils, Dialogs, Graphics, StrUtils;

{ TPath }

procedure TPath.GetList(var Conn: TadjacentArray; Adjacent: TadjacentArray; node: Integer);
var
    i: Integer;
begin
    for i := 0 to length(Adjacent) - 1 do
    begin
        if Adjacent[i].source = node then
            SetAdjacentValue(Conn, Adjacent[i]);
    end;
end;

procedure TPath.Initialize;
var
    i, j : integer;
begin
    for i := 0 to 100 do
        for j := 0 to 100 do
            sgCalc.Cells[i, j] := '';
    for i := 0 to 100 do
        for j := 0 to 100 do
            sgResult.Cells[i, j] := '';
    for i := 0 to 100 do
        for j := 0 to 100 do
            sgCalcRes.Cells[i, j] := '';
    for i := 0 to 100 do
        for j := 0 to 100 do
            sgResultRes.Cells[i, j] := '';
end;

function TPath.getLastColumn(fila: Integer): Integer;
var
    i, res: Integer;
begin
    res := 0;
    for i := 1 to 100 do
    begin
        if sgCalc.Cells[i, fila] = '' then
        begin
            res := i;
            break;
        end;
    end;
    Result := res;
end;

function TPath.AllRowsFinished(filas: Integer; DestinoList: TArrayInteger): Boolean;
var
    i, columna: Integer;
    sum, j: Integer;
begin
    sum := 0;
    for i := 1 to filas do
    begin
        columna := getLastColumn(i);
        for j := 0 to length(DestinoList) - 1 do
        begin
            if inttostr(DestinoList[j]) = sgCalc.Cells[columna - 1, i] then
                sum := sum + 1;
        end;
    end;
    Result := (sum = filas);
end;

function TPath.CloneRow(fila: Integer; Connector: TadjacentArray): Integer;
var
    i, filan, j: Integer;
    new: Integer;
begin
    new := 0;
    for j := 1 to length(Connector) - 1 do
    begin

        filan := 0;
        for i := 1 to 100 do
        begin
            if sgCalc.Cells[1, i] = '' then
            begin
                filan := i;
                break;
            end;
        end;

        if filan <> 0 then
        begin
            i := 1;
            while sgCalc.Cells[i, fila] <> '' do
            begin
                sgCalc.Cells[i, filan] := sgCalc.Cells[i, fila];
                i := i + 1;
            end;
            sgCalc.Cells[i - 1, filan] := inttostr(Connector[j].destiny);
            new := new + 1;
        end;
    end;
    Result := new;
end;

procedure TPath.Calc;
var
    firstNode, LastNode: Integer;
    i, j, k, l, pos1, pos2: Integer;
    Conn: TConnector;
    AdjacentList: TadjacentArray;
    fila, columna: Integer;
    novaFila, bTrobat: Boolean;
    t1: TDateTime;
    bVisited: Boolean;
    filas, newRows, sum: Integer;
    Connector: TadjacentArray;
    hayOrigen, hayDestino: Boolean;
    list: TArrayInteger;
begin
    // Calculamos los origenes i destinos
    FLog.Clear;
    if (FNodeList.Count = 0) or (FConnectorList.Count = 0) then
        exit;
    t1 := now;
    FLog.Add('Calculating routing points (Source, Destiny)');
    FLog.Add(FormatDateTime('"Start: " hh:nn:ss.zzz', t1));
    SetLength(OrigenList, 0);
    SetLength(DestinoList, 0);
    for i := 0 to FNodeList.Count - 1 do
    begin
        if FNodeList.items[i].properties.getText = '' then
        begin
            showMessage('Boxes without ID were found!');
            exit;
        end;

        if FNodeList.items[i].nodeType = nOrigin then
            SetArrayValue(OrigenList, StrToInt(FNodeList.items[i].properties.getText));
        if FNodeList.items[i].nodeType = nDestiny then
            SetArrayValue(DestinoList, StrToInt(FNodeList.items[i].properties.getText));
    end;
    FLog.Add(FormatDateTime('"Stop: " hh:nn:ss.zzz', now));
    FLog.Add(FormatDateTime('"Diff: " hh:nn:ss.zzz "ms"', now - t1));
    FLog.Add('');

    // Calculamos la lista de adyacencias
    t1 := now;
    FLog.Add('Calculating adjacent list');
    FLog.Add(FormatDateTime('"Start: " hh:nn:ss.zzz', t1));
    for i := 0 to FConnectorList.Count - 1 do
    begin
        Conn := FConnectorList.items[i];
        try
            pos1 := StrToInt(Conn.SourceNode.properties.getText);
            pos2 := StrToInt(Conn.TargetNode.properties.getText);
            if not Conn.Edge.ClassNameIs('TAbstractDottedDoubleLinkedArrowEdge') and not Conn.Edge.ClassNameIs('TAbstractSimpleDoubleLinkedArrowEdge') then
                SetAdjacentValue(AdjacentList, pos1, pos2)
            else
            begin
                SetAdjacentValue(InterlockList, pos1, pos2);
                SetAdjacentValue(InterlockList, pos2, pos1);
            end;
        except
            showMessage('Nodes not correctly set up!');
            exit;
        end;
    end;
    FLog.Add(FormatDateTime('"Stop: " hh:nn:ss.zzz', now));
    FLog.Add(FormatDateTime('"Diff: " hh:nn:ss.zzz "ms"', now - t1));
    FLog.Add('');

    t1 := now;
    FLog.Add('Checking sources and destinations');
    FLog.Add(FormatDateTime('"Start: " hh:nn:ss.zzz', t1));
    hayOrigen := false;
    hayDestino := false;
    for i := 0 to length(AdjacentList) - 1 do
    begin
        for j := 0 to length(OrigenList) - 1 do
        begin
            if AdjacentList[i].source = OrigenList[j] then
            begin
                AdjacentList[i].isSource := True;
                hayOrigen := True;
            end;
        end;
        for j := 0 to length(DestinoList) - 1 do
        begin
            if AdjacentList[i].destiny = DestinoList[j] then
            begin
                AdjacentList[i].isDestination := True;
                hayDestino := True;
            end;
        end;
    end;
    if not hayOrigen and not hayDestino then
    begin
        showMessage('The diagram is not corrected! Check de sources and destinations nodes');
        exit;
    end;
    PrintAdjacentList(FLog, AdjacentList);
    FLog.Add(FormatDateTime('"Stop: " hh:nn:ss.zzz', now));
    FLog.Add(FormatDateTime('"Diff: " hh:nn:ss.zzz "ms"', now - t1));
    FLog.Add('');

    t1 := now;
    FLog.Add('Calculating and Showing results');
    FLog.Add(FormatDateTime('"Start: " hh:nn:ss.zzz', t1));
    for i := 0 to 100 do
        for j := 0 to 100 do
            sgCalc.Cells[i, j] := '';

    fila := 1;
    filas := 0;
    columna := 1;
    for i := 0 to length(AdjacentList) - 1 do
    begin
        if AdjacentList[i].isSource then
        begin
            sgCalc.Cells[columna, fila] := inttostr(AdjacentList[i].source);
            sgCalc.Cells[columna + 1, fila] := inttostr(AdjacentList[i].destiny);
            AdjacentList[i].visited := True;
            filas := filas + 1;
            fila := fila + 1;
        end;
    end;

    bVisited := false;
    while not bVisited do
    begin
        sum := 0;
        for i := 1 to filas do
        begin
            columna := getLastColumn(i);
            SetLength(Connector, 0);
            GetList(Connector, AdjacentList, StrToInt(sgCalc.Cells[columna - 1, i]));
            if length(Connector) <> 0 then
            begin
                sgCalc.Cells[columna, i] := inttostr(Connector[0].destiny);
                if length(Connector) > 1 then
                begin
                    newRows := CloneRow(i, Connector);
                    sum := sum + newRows;
                end;
            end;
        end;
        filas := filas + sum;
        bVisited := AllRowsFinished(filas, DestinoList);
    end;
    for i := 1 to filas do
        sgCalc.Cells[0, i] := inttostr(i);

    FLog.Add(FormatDateTime('"Stop: " hh:nn:ss.zzz', now));
    FLog.Add(FormatDateTime('"Diff: " hh:nn:ss.zzz "ms"', now - t1));
    FLog.Add('');

    // Copia de los datos de una grid a la otra:
    t1 := now;
    FLog.Add('Calculating interlock results');
    FLog.Add(FormatDateTime('"Start: " hh:nn:ss.zzz', t1));
    for i := 0 to 100 do
        for j := 0 to 100 do
            sgResult.Cells[i, j] := '';

    for i := 1 to filas do
    begin
        sgResult.Cells[0, i] := inttostr(i);
        j := 1;
        k := j;
        while sgCalc.Cells[j, i] <> '' do
        begin
            list := GetInterlockList(InterlockList, StrToInt(sgCalc.Cells[j, i]));
            if length(list) <> 0 then
            begin
                for l := 0 to length(list) - 1 do
                begin
                    sgResult.Cells[k, i] := inttostr(list[l]);
                    k := k + 1;
                end;
                sgResult.Cells[k, i] := sgCalc.Cells[j, i];
                k := k + 1;
            end
            else
            begin
                sgResult.Cells[k, i] := sgCalc.Cells[j, i];
                k := k + 1;
            end;
            j := j + 1;
        end;
    end;
    FLog.Add(FormatDateTime('"Stop: " hh:nn:ss.zzz', now));
    FLog.Add(FormatDateTime('"Diff: " hh:nn:ss.zzz "ms"', now - t1));
    FLog.Add('');

    ExportRoutes();
end;

constructor TPath.Create(nodeList: TNodeList; connectorList: TConnectorList; log: TLogObject; sgCalc, sgResult, sgCalcRes, sgResultRes : TStringGrid);
begin
    Self.FNodeList := nodeList;
    Self.FConnectorList := connectorList;
    Self.FLog := log;
    Self.sgCalc := sgCalc;
    Self.sgResult := sgResult;
    Self.sgCalcRes := sgCalcRes;
    self.sgResultRes := sgResultRes;
    Initialize();
end;

destructor TPath.Destroy;
begin
    FLog := nil;
    FNodeList := nil;
    FConnectorList := nil;
    sgCalc := nil;
    sgResult := nil;
    sgCalcRes := nil;
    sgResultRes := nil;
    inherited;
end;

procedure TPath.ExportRoutes;
    function getWeightConnector(id1, id2: String): Integer;
    var
        i: Integer;
        con: TConnector;
        weight: String;
    begin
        for i := 0 to FconnectorList.Count - 1 do
        begin
            con := FconnectorList[i];
            if (con.SourceNode.properties.getText = id1) and (con.TargetNode.properties.getText = id2) then
            begin
                weight := con.Edge.properties.getText;
                break;
            end;
        end;
        if weight = '' then
            weight := '0';
        Result := StrToInt(weight);
    end;
    function getValue(val: string): string;
    var
        position: Integer;
    begin
        position := AnsiPos('.', val);
        if position <> 0 then
            Result := AnsiLeftStr(val, position - 1)
        else
            Result := val;
    end;

var
    i, j, filas, k, l: Integer;
    SourceNumber, targetNumber: String;
    weight: Integer;
    list: TArrayInteger;
    t1: TDateTime;
begin
    t1 := now;
    FLog.Add('Calculating exportable results');
    FLog.Add(FormatDateTime('"Start: " hh:nn:ss.zzz', t1));
    i := 1;
    while sgCalc.Cells[1, i] <> '' do
    begin
        sgCalcRes.Cells[0, i] := inttostr(i);
        j := 1;
        while sgCalc.Cells[j, i] <> '' do
        begin
            SourceNumber := sgCalc.Cells[j, i];
            targetNumber := sgCalc.Cells[j + 1, i];
            weight := getWeightConnector(SourceNumber, targetNumber);
            if weight <> 0 then
                sgCalcRes.Cells[j, i] := SourceNumber + '.' + inttostr(weight);
            if (weight = 0) and (targetNumber = '') then
                sgCalcRes.Cells[j, i] := SourceNumber;
            j := j + 1;
        end;
        i := i + 1;
    end;
    FLog.Add(FormatDateTime('"Stop: " hh:nn:ss.zzz', now));
    FLog.Add(FormatDateTime('"Diff: " hh:nn:ss.zzz "ms"', now - t1));
    FLog.Add('');

    t1 := now;
    FLog.Add('Calculating definitive results');
    FLog.Add(FormatDateTime('"Start: " hh:nn:ss.zzz', t1));
    filas := i - 1;
    for i := 1 to filas do
    begin
        sgResultRes.Cells[0, i] := inttostr(i);
        j := 1;
        k := j;
        while sgCalcRes.Cells[j, i] <> '' do
        begin
            list := GetInterlockList(InterlockList, StrToInt(getValue(sgCalcRes.Cells[j, i])));
            if length(list) <> 0 then
            begin
                for l := 0 to length(list) - 1 do
                begin
                    sgResultRes.Cells[k, i] := inttostr(list[l]) + '.0';
                    k := k + 1;
                end;
                sgResultRes.Cells[k, i] := sgCalcRes.Cells[j, i];
                k := k + 1;
            end
            else
            begin
                sgResultRes.Cells[k, i] := sgCalcRes.Cells[j, i];
                k := k + 1;
            end;
            j := j + 1;
        end;
    end;
    FLog.Add(FormatDateTime('"Stop: " hh:nn:ss.zzz', now));
    FLog.Add(FormatDateTime('"Diff: " hh:nn:ss.zzz "ms"', now - t1));
    FLog.Add('');
end;

end.
