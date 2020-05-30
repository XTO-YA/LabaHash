{����� ����� ������� ��������� ���������: ���������� ������ (������),
��� ���������, ����� ��������. �� ���������� ������ ���������� ���
��������� � �����.}
unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, UPerson,  Menus, Grids, UHashTable,
  AddPersonForm, FindForm, RemoveForm;

type
  THashForm = class(TForm)
    mmMain: TMainMenu;
    mniFile: TMenuItem;
    mniOpen: TMenuItem;
    mniSave: TMenuItem;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    matPersons: TStringGrid;
    mniFind: TMenuItem;
    mniRemove: TMenuItem;
    mniAdd: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure mniOpenClick(Sender: TObject);
    procedure mniSaveClick(Sender: TObject);
    procedure FindPerson(passport:TPassportData);
    procedure mniAddClick(Sender: TObject);
    procedure mniFindClick(Sender: TObject);
    procedure mniRemoveClick(Sender: TObject);
  private
    procedure showPerson(person: TPerson);
  public
    procedure addPerson(person: TPerson);
    procedure RemovePerson(passport:TPassportData);
  end;

var
  HashForm: THashForm;
  table: THashTable;
implementation

{$R *.dfm}

procedure THashForm.FormCreate(Sender: TObject);
begin
  table := THashTable.Create;
  with(matPersons) do
    begin
      Cols[0].Text := '����� ��������';
      Cols[1].Text := '����� ��������';
      Cols[2].Text := '���';
      Cols[3].Text := '����� ��������';
      RowCount := 1;
    end;
end;

procedure THashForm.mniOpenClick(Sender: TObject);
var
  loadedCount: integer;
begin
  if dlgOpen.Execute then
    begin
      loadedCount := table.loadFromFile(dlgOpen.FileName);
      table.showInTable(matPersons);
      if loadedCount > 0 then
        ShowMessage('��������� '+IntToStr(loadedCount)+' �������')
      else
        ShowMessage('���� ����');
    end;
end;

procedure THashForm.mniSaveClick(Sender: TObject);
begin
  if dlgSave.Execute then
    begin
      table.saveToFile(dlgSave.FileName);
      ShowMessage('������ ���������!');
    end;
end;

procedure THashForm.FindPerson(passport:TPassportData);
begin
  showPerson(table.get(passport));
end;

procedure THashForm.RemovePerson(passport:TPassportData);
begin
  if table.remove(passport) then
      begin
        table.showInTable(matPersons);
        ShowMessage('������ �������');
      end
    else
      ShowMessage('������ �� �������');
end;

procedure THashForm.addPerson(person: TPerson);
begin
  table.add(person.FPassport,person);
  table.showInTable(matPersons);
end;

procedure THashForm.showPerson(person: TPerson);
begin
  if person <> nil then
    with(person) do
      ShowMessage(person.FFIO + #10#13 + person.FAddress)
  else
    ShowMessage('������ �� �������');
end;

procedure THashForm.mniAddClick(Sender: TObject);
begin
  AddUserForm.Show;
end;

procedure THashForm.mniFindClick(Sender: TObject);
begin
  FindForm.Form1.Show;
end;

procedure THashForm.mniRemoveClick(Sender: TObject);
begin
  RemoveForm.Form2.Show;
end;

end.
