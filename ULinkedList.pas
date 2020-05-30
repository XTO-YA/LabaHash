unit ULinkedList;

interface

uses UEntries, Grids, SysUtils;

type
  TLinkedList = class
    private
      head: TListEntry;
      function findEntry(key: TKey): TListEntry;
    public
      constructor Create;
      procedure add(value: TBase);
      function remove(key: TKey): boolean;
      function get(key: TKey): TValue;
      procedure clear;
      function isEmpty: Boolean;
      procedure saveToFile(var f: TFile);
      procedure showInTable(table: TStringGrid);
      destructor Destroy; override;
  end;

implementation

constructor TLinkedList.Create;
begin
    inherited Create;
    head := nil;
end;

procedure TLinkedList.add(value: TBase);
var
  lastHead: TListEntry;
  entry: TListEntry;
begin
  entry := findEntry(value.key);
  if entry <> nil then
     entry.data := value
  else
    begin
      lastHead := head;
      head := TListEntry.Create(value, lastHead);
    end;
end;

function TLinkedList.get(key: TKey): TValue;
var
  entry : TListEntry;
begin
  entry := findEntry(key);
  if entry = nil then
    result := nil
  else
    result := entry.data.value;
end;

function TLinkedList.findEntry(key: TKey): TListEntry;
begin
  Result := head;
  while (result <> nil) and (result.data.key.series <> key.series)
        and (result.data.key.number <> key.number) do
    result := result.next;
end;

function TLinkedList.remove(key: TKey): Boolean;
var
  current,
  entryToRemove: TListEntry;
begin
  result := False;
  if head <> nil then
    if (head.data.key.series = key.series) and
        (head.data.key.number = key.number) then
      begin
        entryToRemove := head;
        head := head.next;
        entryToRemove.Free;
        result:= True;
      end
    else
      begin
        current := head;
        while (current.next <> nil) and (current.next.data.key.series <> key.series)
                and (current.next.data.key.number <> key.number) do
          current := current.next;
        entryToRemove := current.next;

        if(entryToRemove <> nil) then
          begin
            current.next := entryToRemove.next;
            entryToRemove.Free;
            result := True;
          end;
      end;
end;

function TLinkedList.isEmpty: Boolean;
begin
  Result := head = nil;
end;

procedure TLinkedList.clear;
var
  lastHead: TListEntry;
begin
  while not isEmpty do
    begin
      lastHead := head;
      head := head.next;
      lastHead.Free;
    end;
end;

procedure TLinkedList.saveToFile(var f: TFile);
var
  current: TListEntry;
begin
  current := head;
  while current <> nil do
    begin
      writeln(f,current.data.value.FPassport.series);
      writeln(f,current.data.value.FPassport.number);
      writeln(f, current.data.value.FFIO);
      writeln(f,current.data.value.FAddress);
      current := current.next;
    end;
end;
          
procedure TLinkedList.showInTable(table: TStringGrid);
var
  entry: TListEntry;
  rowIndex: Integer;
begin
  entry := head;
  while entry<>nil do
    with(table) do
      with(entry.data.value) do
        begin
          rowIndex := RowCount;
          Cells[0,rowIndex] := IntToStr(FPassport.series);
          Cells[1,rowIndex] := IntToStr(FPassport.number);
          Cells[2,rowIndex] := FFIO;
          Cells[3,rowIndex] := FAddress;
          RowCount := rowIndex + 1;
          entry := entry.next;
        end;
end;

destructor TLinkedList.Destroy;
begin
  clear;
  inherited Destroy;
end;
end.
