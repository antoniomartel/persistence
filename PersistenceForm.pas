unit PersistenceForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBTables, Db,

  ClassesRTTI, IBDatabase, IBCustomDataSet, IBQuery, IBStoredProc;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    bClose: TButton;
    bOpen: TButton;
    bSave: TButton;
    EditStreet1: TEdit;
    EditCity1: TEdit;
    EditPostCode1: TEdit;
    EditCountry1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditStreet2: TEdit;
    EditCity2: TEdit;
    EditPostCode2: TEdit;
    EditCountry2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditName1: TEdit;
    EditPhone1: TEdit;
    EditOrganisation1: TEdit;
    EditLastContact1: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditName2: TEdit;
    EditPhone2: TEdit;
    EditOrganisation2: TEdit;
    EditLastContact2: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    GroupBox5: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    EditBalance1: TEdit;
    Label17: TLabel;
    EditBalance2: TEdit;
    Label18: TLabel;
    bCopy: TButton;
    Query: TIBQuery;
    IBTransaction: TIBTransaction;
    dbPersistence: TIBDatabase;
    StoredProcNextId: TIBStoredProc;
    procedure bCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure bOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bCopyClick(Sender: TObject);
  private
    { Private declarations }

    FModel1,
    FModel2: CCustomer;

    procedure ShowObject(Index: Integer);
    procedure UpdateObject(Index: Integer);

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  Constants, Prvider;



//------------------------------------------------------------------------------
//                 Published (automatic) methods implementation
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//                         Procedure bCopyClick
//------------------------------------------------------------------------------

procedure TForm1.bCopyClick(Sender: TObject);
begin
  FModel2.CopyModel(FModel1);
  ShowObject(2);
end;


//------------------------------------------------------------------------------
//                         Procedure Button2Click
//------------------------------------------------------------------------------

procedure TForm1.bCloseClick(Sender: TObject);
begin
  Close;
end;


//------------------------------------------------------------------------------
//                          Procedure FormCreate
//------------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  
begin
  if FileExists(strDBPersistence) then
  begin
    // The database already exists
    dbPersistence.Params.Clear;
    dbPersistence.Params.Add('USER_NAME=SYSDBA');
    dbPersistence.Params.Add('PASSWORD=masterkey');
    dbPersistence.Connected := True;
    // Delete tables to re-create them later with maybe new fields
    // Deletes all tables when exiting
    for i := High(TPersistentClasses) downto 0 do
      CModel(TPersistentClasses[i]).DeleteTable(Query, TPersistentClasses[i]);
  end
  else
  begin
    // Creates database if it doesn't exist
    dbPersistence.CreateDatabase;
    // Creates generator
    try
      Query.SQL.Clear;
      Query.SQL.Add('create generator Identifier;');
      Query.ExecSQL;
    except;
      raise Exception.Create(strCreateTableError);
    end;
    // Adds Stored Procedured (NextIdentifier)
    try
      Query.SQL.Clear;
      Query.SQL.Add('create procedure NextIdentifier returns (Id integer) as');
      Query.SQL.Add('begin');
      Query.SQL.Add('Id = gen_id( Identifier, 1);');
      Query.SQL.Add('end;');
      Query.ExecSQL;
    except;
      raise Exception.Create(strCreateTableError);
    end;
    // Commit work
    try
      Query.SQL.Clear;
      Query.SQL.Add('Commit;');
      Query.ExecSQL;
    except;
      raise Exception.Create(strCommitCreateTableError);
    end;
  end;
  
  // Step through all permanent classes defined in the system and
  // it re-constructs its tables
  for i := 0 to High(TPersistentClasses) do
    CModel(TPersistentClasses[i]).CreateTable(Query, TPersistentClasses[i]);
  // Create models, load controls data into models and save them
  FModel1 := CCustomer.Create;
  FModel2 := CCustomer.Create;
  UpdateObject(1);
  FModel1.Save(Query, CCustomer, StoredProcNextId);
  UpdateObject(2);
  FModel2.Save(Query, CCustomer, StoredProcNextId);
end;


//------------------------------------------------------------------------------
//                       Procedure ButtonSaveClick
//------------------------------------------------------------------------------

procedure TForm1.bSaveClick(Sender: TObject);
begin
  if RadioButton1.Checked then
  begin
    UpdateObject(1);
    FModel1.Save(Query, CCustomer, StoredProcNextId);
  end
  else
  begin
    UpdateObject(2);
    FModel2.Save(Query, CCustomer, StoredProcNextId);
  end;
end;


//------------------------------------------------------------------------------
//                       Procedure ButtonOpenClick
//------------------------------------------------------------------------------

procedure TForm1.bOpenClick(Sender: TObject);
var
  Id: Integer;
  
begin
  if RadioButton1.Checked then
  begin
    Id := FModel1.Id;
    if FModel1.Id <> -1 then
    begin
      FModel1.Free;
      FModel1 := CCustomer(CCustomer.Load(Query, Id));
      ShowObject(1);
    end
    else
      ShowMessage(strSaveFirst);
  end
  else
  begin
    Id := FModel2.Id;
    if FModel2.Id <> -1 then
    begin
      FModel2.Free;
      FModel2 := CCustomer(CCustomer.Load(Query, Id));
      ShowObject(2);
    end
    else
      ShowMessage(strSaveFirst);
  end;
end;


//------------------------------------------------------------------------------
//                           Procedure FormClose
//------------------------------------------------------------------------------

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dbPersistence.Close;
end;


//------------------------------------------------------------------------------
//                     Private methods implementation
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//                          Procedure ShowObject
//------------------------------------------------------------------------------

procedure TForm1.ShowObject(Index: Integer);
begin
  if Index = 1 then
  begin
    EditName1.Text := FModel1.Name;
    EditPhone1.Text := FModel1.Phone;
    EditOrganisation1.Text := FModel1.Organisation;
    EditBalance1.Text := IntToStr(FModel1.Balance);
    EditLastContact1.Text := DateToStr(FModel1.LastContact);
    EditStreet1.Text := FModel1.Address.Street;
    EditCity1.Text := FModel1.Address.City;
    EditPostCode1.Text := FModel1.Address.PostCode;
    EditCountry1.Text := FModel1.Address.Country;
  end
  else
  begin
    EditName2.Text := FModel2.Name;
    EditPhone2.Text := FModel2.Phone;
    EditOrganisation2.Text := FModel2.Organisation;
    EditBalance2.Text := IntToStr(FModel2.Balance);
    EditLastContact2.Text := DateToStr(FModel2.LastContact);
    EditStreet2.Text := FModel2.Address.Street;
    EditCity2.Text := FModel2.Address.City;
    EditPostCode2.Text := FModel2.Address.PostCode;
    EditCountry2.Text := FModel2.Address.Country;
  end;
end;


//------------------------------------------------------------------------------
//                         Procedure UpdateObject
//------------------------------------------------------------------------------

procedure TForm1.UpdateObject(Index: Integer);
begin
  if Index = 1 then
  begin
    FModel1.Name := EditName1.Text;
    FModel1.Phone := EditPhone1.Text;
    FModel1.Organisation := EditOrganisation1.Text;
    FModel1.LastContact := StrToDate(EditLastContact1.Text);
    FModel1.Balance := StrToInt(EditBalance1.Text);
    FModel1.Address.Street := EditStreet1.Text;
    FModel1.Address.City := EditCity1.Text;
    FModel1.Address.PostCode := EditPostCode1.Text;
    FModel1.Address.Country := EditCountry1.Text;
  end
  else
  begin
    FModel2.Name := EditName2.Text;
    FModel2.Phone := EditPhone2.Text;
    FModel2.Organisation := EditOrganisation2.Text;
    FModel2.LastContact := StrToDate(EditLastContact2.Text);
    FModel2.Balance := StrToInt(EditBalance2.Text);
    FModel2.Address.Street := EditStreet2.Text;
    FModel2.Address.City := EditCity2.Text;
    FModel2.Address.PostCode := EditPostCode2.Text;
    FModel2.Address.Country := EditCountry2.Text;
  end;
end;


end.
