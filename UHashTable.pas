unit UHashTable;

interface

uses ULinkedList, UEntries, Grids;

const
  TABLE_SIZE = 100;

type

  THashTable = class
    private
       table: array[0..TABLE_SIZE-1] of TLinkedList;
       function hash(key: TKey): integer;
    public
      constructor Create;
      procedure add(key: TKey; value: TValue);
      function get(key: TKey): TValue;
      function remove(key: TKey): Boolean;
      procedure clear();
      procedure saveToFile(fileName: String);
      function loadFromFile(fileName: String): integer;
      procedure showInTable(table: TStringGrid);
      destructor Destroy; override;
  end;

implementation
constructor THashTable.Create;
var
  i:integer;
begin
  for i:=0 to TABLE_SIZE-1 do
    table[i] := nil;
end;

procedure THashTable.add(key: TKey; value: TValue);
var
  index: integer;
begin
  index := hash(key);
  if table[index] = nil then
    table[index] := TLinkedList.Create;
  table[index].add(THashEntry.Create(key, value));
end;


function THashTable.get(key: TKey): TValue;
var
  index: integer;
begin
  result := nil;
  index := hash(key);
  if table[index] <> nil then
    result := table[index].get(key);
end;

function THashTable.remove(key: TKey): Boolean;
var
  index: integer;
begin
  index := hash(key);
  Result := false;
  if table[index] <> nil then
    result := table[index].remove(key);
end;
                                
function THashTable.hash(key: TKey): integer;
begin
  Result := (key.series + key.number) mod TABLE_SIZE;
end;


procedure THashTable.clear();
var
  i: integer;
begin
    for i:=0 to TABLE_SIZE-1 do
    begin
      table[i].Free;
      table[i] := nil;
    end;
end;
procedure THashTable.saveToFile(fileName: String);
var
  f: TFile;
  i:integer;
begin
  Assign(f, fileName);
  Rewrite(f);
  for i:=0 to TABLE_SIZE - 1 do
    if table[i] <> nil then
      table[i].saveToFile(f);
  Close(f);
end;


function THashTable.loadFromFile(fileName: String): integer;
var
  f: TFile;
  value : TValue;
begin
  result := 0;
  clear();
  Assign(f, fileName);
  Reset(f);
  while not Eof(f) do
    begin
      value := TValue.Create();
      readln(f,value.FPassport.series);
      readln(f, value.FPassport.number);
      readln(f, value.FFIO);
      readln(f, value.FAddress);
      add(value.FPassport, value);
      inc(result);
    end;
  Close(f);
end;

procedure THashTable.showInTable(table: TStringGrid);
var
  i:Integer;
begin
  table.RowCount := 1;
  for i:=0 to TABLE_SIZE - 1 do
    if self.table[i] <> nil then
      Self.table[i].showInTable(table)
end;

destructor THashTable.Destroy;
begin
  clear();
  inherited;
end;
end.
