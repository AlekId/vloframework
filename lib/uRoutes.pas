unit uRoutes;

interface

uses
    StdCtrls, uArray;

type
    TNode = record
        source: integer;
        destiny: integer;
        pes: integer;
        visited: boolean;
        brother: boolean;
        father: integer;
        isSource: boolean;
        isDestination: Boolean;
    end;


    TAdjacentArray = array of TNode;
    TRuta = array of array of TAdjacentArray;

function GetConnections2(lista: TAdjacentArray; source: integer): TArrayInteger;
procedure SetAdjacentValue(var a: TAdjacentArray; valor1, valor2: integer); overload;
procedure SetAdjacentValue(var a: TAdjacentArray; valor: TNode); overload;
function isVisited(AdjacentList: TAdjacentArray; source: integer; destiny: integer; var pes: integer): boolean;
function getPes(AdjacentList: TAdjacentArray; source: integer): integer;
procedure Visit(AdjacentList: TAdjacentArray; source: integer; destiny: integer);
function ExamineNodes2(memo1: TMemo; firstNode: integer; lastNode: integer; AdjacentList: TAdjacentArray): string;
procedure PrintAdjacentList(memo1: TMemo; AdjacentList: TAdjacentArray);
procedure GetOrderedList(var lista: TAdjacentArray);
function GetInterlockList(Interlocklist: TAdjacentArray; id: integer): TArrayInteger;
procedure SetCheckArrayValue(var a: TArrayInteger; valor: integer);

var
    rutes: TAdjacentArray;

implementation

uses
    SysUtils, Dialogs;

function GetConnections2(lista: TAdjacentArray; source: integer): TArrayInteger;
var
    res: TArrayInteger;
    i: integer;
    lista2: TAdjacentArray;
begin
    for i := 0 to length(lista) - 1 do
    begin
        if lista[i].source = source then
            SetAdjacentValue(lista2, lista[i]);
        //SetArrayValue(res, lista[i].destiny);
    end;

    GetOrderedList(lista2);

    for i := (length(lista2) - 1) downto 0 do
    begin
        SetArrayValue(res, lista2[i].destiny);
    end;
    //    for i := 0 to (length(lista2) - 1)  do
    //    begin
    //        SetArrayValue(res, lista2[i].destiny);
    //    end;
    result := res;
end;

procedure GetOrderedList(var lista: TAdjacentArray);
var
    x, y: integer;
    aux: TNode;
begin
    for x := 0 to length(lista) - 1 do // Metodo de burbuja
    begin
        for y := 0 to length(lista) - 2 do
        begin
            if lista[y].pes > lista[y + 1].pes then
            begin
                aux := lista[y];
                lista[y] := lista[y + 1];
                lista[y + 1] := aux;
            end;
        end;
    end;
end;

procedure SetCheckArrayValue(var a: TArrayInteger; valor: integer);
var
    iPosArray: integer;
    i: integer;
    trobat: boolean;
begin
    trobat := false;
    for i := 0 to length(a) - 1 do
    begin
        trobat := (a[i] = valor);
    end;
    if not trobat then
    begin
        iPosArray := length(a);
        SetLength(a, iPosArray + 1);
        a[iPosArray] := valor;
    end;
end;

procedure SetAdjacentValue(var a: TAdjacentArray; valor1, valor2: integer);
var
    iPosArray: integer;
begin
    iPosArray := length(a);
    SetLength(a, iPosArray + 1);
    a[iPosArray].source := valor1;
    a[iPosArray].destiny := valor2;
end;

procedure SetAdjacentValue(var a: TAdjacentArray; valor: TNode);
var
    iPosArray: integer;
begin
    iPosArray := length(a);
    SetLength(a, iPosArray + 1);
    a[iPosArray] := valor;
end;

function getPes(AdjacentList: TAdjacentArray; source: integer): integer;
var
    count, count2, i: integer;
begin
    count := 0;
    count2 := 0;
    for i := 0 to length(AdjacentList) - 1 do
    begin
        if AdjacentList[i].source = source then
            count := count + 1;
    end;
    //     for i := 0 to length(AdjacentList) - 1 do
    //     begin
    //         if AdjacentList[i].destiny = source then
    //            count2 := count2 + 1;
    //         if AdjacentList[i].destiny = 19 then
    //         begin
    //            count2 := 0;
    //            break;
    //         end;
    //     end;
    if count > count2 then
        result := count
    else
        result := count2;
end;

function isVisited(AdjacentList: TAdjacentArray; source: integer; destiny: integer; var pes: integer): boolean;
var
    i, j: integer;
    val: integer;
begin
    val := 0;
    for i := 0 to length(AdjacentList) - 1 do
    begin
        if (AdjacentList[i].source = source) and (AdjacentList[i].destiny = destiny) then
        begin
            val := AdjacentList[i].pes;
            pes := val;
            if not AdjacentList[i].brother then
            begin
                for j := 0 to length(AdjacentList) - 1 do
                begin
                    if AdjacentList[j].brother then
                        AdjacentList[j].pes := 1;
                end;
            end;

            break;
        end;
    end;
    result := (val > 0);
end;

procedure Visit(AdjacentList: TAdjacentArray; source: integer; destiny: integer);
var
    i: integer;
begin
    for i := 0 to length(AdjacentList) - 1 do
    begin
        if (AdjacentList[i].source = source) and (AdjacentList[i].destiny = destiny) then
        begin
            AdjacentList[i].pes := AdjacentList[i].pes - 1;
            break;
        end;
    end;
end;

function ExamineNodes2(memo1: TMemo; firstNode: integer; lastNode: integer; AdjacentList: TAdjacentArray): string;
var
    nodeVisited: integer;
    res: TArrayInteger;
    i, iPosArray: integer;
    father: integer;
    val: string;
    pes: integer;
begin
    nodeVisited := firstNode;
    val := Inttostr(nodeVisited) + ' ';
    // 1
    father := nodeVisited; // 1
    while (nodeVisited <> lastNode) do
    begin
        // Aquí hay el 4 y el 5
        res := GetConnections2(AdjacentList, nodeVisited);
        for i := 0 to length(res) - 1 do
        begin

            nodeVisited := res[i]; // 4
            if isVisited(AdjacentList, father, nodeVisited, pes) then
            begin
                Visit(AdjacentList, father, nodeVisited);
                memo1.lines.add('  Father: ' + Inttostr(father) + ' Visited: ' + Inttostr(nodeVisited));
                iPosArray := length(rutes);
                SetLength(rutes, iPosArray + 1);
                rutes[iPosArray].source := nodeVisited;
                rutes[iPosArray].father := father;
                val := val + ExamineNodes2(memo1, nodeVisited, lastNode, AdjacentList) + ' ';
            end
            else
            begin
                memo1.lines.add('       **No visited' + ' Visited: ' + Inttostr(nodeVisited));
            end;
            memo1.lines.add('       ****Peso' + Inttostr(pes) + ' Visited: ' + Inttostr(nodeVisited));
        end;
        if length(res) = 0 then
        begin
            showmessage('Error' + Inttostr(father));
            exit;
        end;
    end;
    result := result + val + ' ';
end;

procedure PrintAdjacentList(memo1: TMemo; AdjacentList: TAdjacentArray);
var
    i: integer;
begin
    for i := 0 to length(AdjacentList) - 1 do
    begin
        //        memo1.lines.add('Source ' + Inttostr(AdjacentList[i].source) + ' Destiny ' + Inttostr(AdjacentList[i].destiny) + ' Weight ' + Inttostr(AdjacentList[i].pes) + ' unique ' + booltostr
        //                (AdjacentList[i].brother));
        memo1.lines.add('Source ' + Inttostr(AdjacentList[i].source) + ' Destiny ' + Inttostr(AdjacentList[i].destiny) + ' isSource ' + BoolToStr(AdjacentList[i].isSource) + ' isDestination ' + booltostr
            (AdjacentList[i].isDestination));
    end;
end;

function GetInterlockList(Interlocklist: TAdjacentArray; id: integer): TArrayInteger;
var
    father: integer;
    i: integer;
    list: TArrayInteger;
begin
    setLength(list, 0);
    father := 0;
    for i := 0 to Length(InterLockList) - 1 do
    begin
        if InterLockList[i].source = id then
        begin
            father := InterLockList[i].destiny;
            break;
        end;
    end;
    if father <> 0 then
    begin
        for i := 0 to length(InterlockList) - 1 do
        begin
            if (InterLockList[i].source = father) and (InterLockList[i].destiny <> id) then
                SetCheckArrayValue(list, InterLockList[i].destiny);
        end;
    end;
    result := list;
end;

end.

