unit ClassesRTTI;


interface

uses

  classes, dbtables, Controls, TypInfo, IBQuery, IBStoredProc;


{$M+}

type

  TModelClass = class of CModel;

  prkyInteger = type Integer;  // Primary Key Type

  String15 = string[15];
  String30 = string[30];
  String50 = string[50];


  CModel = class(TPersistent)
  private
    { Private declarations }

    FId: prkyInteger;

    function GetParentProperties(ClassRef: TClass): TStringList;
  public
    { Public declarations }

    constructor Create; dynamic;

    procedure CopyModel(Model: CModel);

    procedure CreateTable(Query: TIBQuery; ClassRef: TClass);
    class procedure DeleteTable(Query: TIBQuery; ClassRef: TClass);

    class function Load(Query: TIBQuery; Identifier: Integer): CModel;
    function Save(Query: TIBQuery; ClassRef: TClass; StoredProcNextId: TIBStoredProc): Integer;

  published
    { Published declarations }

    // Primary Key Prefix
    property Id: prkyInteger read FId write FId default -1;
  end;


  CAddress = class(CModel)
  private
    { Private declarations }
    FCity: String50;
    FCountry: String30;
    FPostCode: String15;
    FStreet: String50;
  public
    { Public declarations }
  published
    { Published declarations }
    property Street: String50 read FStreet write FStreet;
    property City: String50 read FCity write FCity;
    property PostCode: String15 read FPostCode write FPostCode;
    property Country: String30 read FCountry write FCountry;
  end;


  dcucCAddress = type CAddress;

  CContact = class(CModel)
  private
    { Private declarations }
    FLastContact: TDate;
    FName: String50;
    FOrganisation: String50;
    FAddress: dcucCAddress;
    FPhone: String15;
  public
    { Private declarations }
    constructor Create; override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Name: String50 read FName write FName;
    property Organisation: String50 read FOrganisation write FOrganisation;
    property Phone: String15 read FPhone write FPhone;
    // Address will be a Foreign Key; dcun -> Delete Cascade, Update No action
    property Address: dcucCAddress read FAddress write FAddress;
    property LastContact: TDate read FLastContact write FLastContact;
  end;


  CCustomer = class(CContact)
  private
    { Private declarations }
    FBalance: integer;
  published
    { Private declarations }
    property Balance: integer read FBalance write FBalance;
  end;


implementation

uses
  SysUtils,
  Constants, Prvider;


//------------------------------------------------------------------------------
//                             Private methods
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//                       Procedure GetParentProperties
//------------------------------------------------------------------------------

function CModel.GetParentProperties(ClassRef: TClass): TStringList;
var
  Parent: TClass;
  PropertiesCount, i: integer;
  PropList: TPropList;
  Prefix: string;
begin
  Result := TStringList.Create;
  try
    Parent := ClassRef.ClassParent;
    PropertiesCount := GetPropList(Parent.ClassInfo, tkProperties, @PropList);
    for i := 0 to PropertiesCount - 1 do
    begin
      // If the property has pk prefix it doesn't include it, that way
      // the descendant table will have a field with this property
      Prefix := copy(LowerCase(PropList[i].PropType^.Name), 1, PrefixLong);
      if Prefix <> strPrimaryKeyPrefix then
        Result.Add(PropList[i].Name);
    end;
  except
    raise Exception.Create(strParentPropListError);
  end;
end;


//------------------------------------------------------------------------------
//                             Public methods
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//                           Constructor Create
//------------------------------------------------------------------------------

constructor CModel.Create;
begin
  inherited;
  FId := -1;
end;


//------------------------------------------------------------------------------
//                             Constructor Assign
//------------------------------------------------------------------------------

procedure CModel.CopyModel(Model: CModel);
var
  PropertiesCount, i: Integer;
  PropList: TPropList;
  PropValue: Variant;
  Instance: CModel;
begin
  // Obtains the properties list of this class
  PropertiesCount := GetPropList(Model.ClassInfo, tkProperties, @PropList);

  for i := 0 to PropertiesCount - 1 do
  begin
    if PropList[i].PropType^.Kind = tkClass then // Property it is a class
    begin
      Instance := CModel(GetObjectProp(Self, PropList[i].Name));
      Instance.CopyModel(CModel(GetObjectProp(Model, PropList[i].Name)));
    end
    else
    begin
      PropValue := GetPropValue(Model, PropList[i].Name);
      case PropList[i].PropType^.Kind of
        tkInteger:
          SetOrdProp(Self, PropList[i].Name, PropValue);
        tkFloat:
          SetFloatProp(Self, PropList[i].Name, PropValue);
        tkString, tkChar:
          SetStrProp(Self, PropList[i].Name, String(PropValue));
        else
          SetVariantProp(Self, PropList[i].Name, PropValue);
      end;  // End case
    end;
  end;
end;


//------------------------------------------------------------------------------
//                           Constructor Create
//------------------------------------------------------------------------------

constructor CContact.Create;
begin
  inherited;
  Address := dcucCAddress(CAddress.Create);
end;


//------------------------------------------------------------------------------
//                            Destructor Destroy
//------------------------------------------------------------------------------

destructor CContact.Destroy;
begin
  Address.Free;
  inherited;
end;


//------------------------------------------------------------------------------
//                          Procedure CreateTable
//------------------------------------------------------------------------------

procedure CModel.CreateTable(Query: TIBQuery; ClassRef: TClass);
var
  Sentence: TStringList;
  PropList: TPropList;
  PropertiesCount, i: Integer;
  FirstProperty: Boolean;
  PropertyType, Prefix, Key, ReferenceAction, ReferenceTable, Table: string;
  List: TStringList;
begin
  Sentence := TStringList.Create;
  try
    // Adds the first part of Create table sql sentence
    Sentence.Add(strCreateTable + ClassRef.ClassName + strOpenParenthesis);

    // Obtains the properties list of this class
    PropertiesCount := GetPropList(ClassRef.ClassInfo, tkProperties, @PropList);

    // Obtains the list of parent properties
    List := GetParentProperties(ClassRef);

    FirstProperty := True;
    for i := 0 to PropertiesCount - 1 do
    begin
      // If it is not an inherited property then it adds to sql sentence
      if List.IndexOf(PropList[i].Name) = -1 then
      begin
        if not FirstProperty then
          Sentence.Text := Sentence.Text + strComma + strSpace;

        Prefix := Copy(LowerCase(PropList[i].PropType^.Name), 1, PrefixLong);

        // If the property has pk prefix it includes property as a primary key
        if Prefix = strPrimaryKeyPrefix then
          Key := strPrimaryKey
        else
          Key := '';

        // Sets action according to the property prefix. Example: 'dnun' -> 'on delete no action on update no action'
        ReferenceAction := '';
        if Prefix = strReferenceDNoActionUNoAction then
          ReferenceAction := strNoDeleteNoUpdate;
        if Prefix = strReferenceDCascadeUCascade then
          ReferenceAction := strDeleteCascadeUpdateCascade;
        if Prefix = strReferenceDNoActionUCascade then
          ReferenceAction := strNoDeleteUpdateCascade;
        if Prefix = strReferenceDCascadeUNoAction then
          ReferenceAction := strDeleteCascadeNoUpdate;

        if ReferenceAction <> '' then
        begin
          Table := Copy(PropList[i].PropType^.Name, PrefixLong + 1,
            Length(PropList[i].PropType^.Name) - PrefixLong);
          ReferenceTable := strReferences + Table +
            strOpenParenthesis + strId + strEndParenthesis;
        end;

        PropertyType := Provider.GetSQLType(PropList[i].PropType^.Kind,
          LowerCase(PropList[i].PropType^.Name));

        Sentence.Add(PropList[i].Name + strSpace + PropertyType + Key);

        if ReferenceAction <> '' then
        begin
          Sentence.Add(strConstraint + strFK + Table + strSpace + ReferenceTable);
          Sentence.Add(ReferenceAction);
        end;

        FirstProperty := False;
      end;
    end;

    Sentence.Add(strEndQuery);

    // Execute Create table sentence
    try
      Query.SQL.Clear;
      Query.SQL.Assign(Sentence);
      Query.ExecSQL;
    except;
      raise Exception.Create(strCreateTableError);
    end;

    try
      Query.SQL.Clear;
      Query.SQL.Add('Commit;');
      Query.ExecSQL;
    except;
      raise Exception.Create(strCommitCreateTableError);
    end;
  finally
    Sentence.Free;
  end;
  List.Free;
end;


//------------------------------------------------------------------------------
//                         Procedure DeleteTable
//------------------------------------------------------------------------------

class procedure CModel.DeleteTable(Query: TIBQuery; ClassRef: TClass);
begin
  try
    // Execute Drop Table sentence
    Query.SQL.Clear;
    Query.SQL.Add(strDropTable + strSpace + ClassRef.ClassName + strSemiColon);
    Query.ExecSQL;
  except
  end;
end;


//------------------------------------------------------------------------------
//                              Procedure Load
//------------------------------------------------------------------------------

class function CModel.Load(Query: TIBQuery; Identifier: Integer): CModel;
var
  PropertiesCount, i, ClassPropertyId: Integer;
  ClassIndex: TClass;
  PropList: TPropList;
  FirstProperty: Boolean;
  Field, Prefix, WhereCondition: string;
  Model: CModel;
  ClassProperty: TModelClass;
  PropertyQuery: TIBQuery;

begin
  Model := Self.Create;

  Query.Close;
  Query.SQL.Clear;

  // Adds the first part of Select sentence
  Query.SQL.Add(strSelect);

  // Obtains the properties list of this class
  PropertiesCount := GetPropList(Model.ClassInfo, tkProperties, @PropList);

  // Adds names of fields
  FirstProperty := True;
  for i := 0 to PropertiesCount - 1 do
  begin
    if not FirstProperty then
      Query.SQL.Text := Query.SQL.Text + strComma;

    // If the property has pk prefix it includes property as a primary key
    Prefix := copy(LowerCase(PropList[i].PropType^.Name), 1, PrefixLong);
    if Prefix = strPrimaryKeyPrefix then
      Field := Model.ClassName + strDot + PropList[i].Name
    else
      Field := PropList[i].Name;
    Query.SQL.Text := Query.SQL.Text + Field;

    FirstProperty := False;
  end;

  // Adds From + tables and prepare Where condition
  Query.SQL.Add(strFrom + Model.ClassName);
  WhereCondition := strWhere + Model.ClassName + strDot + strId + strEqual + IntToStr(Identifier);
  ClassIndex := Model.ClassParent;
  while ClassIndex <> TPersistent do
  begin
    Query.SQL.Text := Query.SQL.Text + strComma + ClassIndex.ClassName;
    WhereCondition := WhereCondition + strAnd + ClassIndex.ClassName + strDot +
      strId + strEqual + IntToStr(Identifier);
    ClassIndex := ClassIndex.ClassParent;
  end;

  // Adds Where condition
  Query.SQL.Add(WhereCondition + strSemiColon);

  try
    Query.Open;
  except;
    FreeAndNil(Model);
  end;

  for i := 0 to PropertiesCount - 1 do
  begin
    // Property is a class, so we also load the class
    if PropList[i].PropType^.Kind = tkClass then
    begin
      ClassPropertyId := Query.FieldByName(PropList[i].Name).AsInteger;
      ClassProperty := TModelClass(GetObjectPropClass(Model, PropList[i].Name));

      PropertyQuery := TIBQuery.Create(nil);
      try
        PropertyQuery.DataBase := Query.Database;
        SetObjectProp(Model, PropList[i].Name, ClassProperty.Load(PropertyQuery, ClassPropertyId));
      finally
        PropertyQuery.Free;
      end;
    end
    else
    begin
      case PropList[i].PropType^.Kind of
        tkInteger:
          SetOrdProp(Model, PropList[i].Name, Query.FieldByName(PropList[i].Name).AsInteger);
        tkFloat:
          SetFloatProp(Model, PropList[i].Name, Query.FieldByName(PropList[i].Name).AsFloat);
        tkString, tkChar:
          SetStrProp(Model, PropList[i].Name, Query.FieldByName(PropList[i].Name).AsString);
        else
          SetVariantProp(Model, PropList[i].Name, Query.FieldByName(PropList[i].Name).AsVariant);
      end;  // End case
    end;
  end;

  Result := Model;
end;


//------------------------------------------------------------------------------
//                              Procedure Save
//------------------------------------------------------------------------------

function CModel.Save(Query: TIBQuery; ClassRef: TClass; StoredProcNextId: TIBStoredProc): Integer;
var
  i: Integer;
  Properties, Values, PropValue: string;
  Sentence: TStringList;
  PropList: TPropList;
  PropertiesCount: Integer;
  List: TStringList;
  FirstProperty: Boolean;
begin
  // It is a new object, so it inserts it in DB
  if FId = -1 then
  begin
    StoredProcNextId.StoredProcName := 'NEXTIDENTIFIER';
    StoredProcNextId.ExecProc;
    FId := StoredProcNextId.ParamByName('Id').AsInteger;
    Result := FId;

    while ClassRef <> TPersistent do
    begin
      Sentence := TStringList.Create;
      try
        // Adds the first part of Create table sql sentence
        Sentence.Add(strInsert + ClassRef.ClassName);

        // Obtains the properties list of this class
        PropertiesCount := GetPropList(ClassRef.ClassInfo, tkProperties, @PropList);

        // Obtains the list of parent properties
        List := GetParentProperties(ClassRef);

        FirstProperty := True;
        Properties := strOpenParenthesis;
        Values := strOpenParenthesis;
        for i := 0 to PropertiesCount - 1 do
        begin
          // If it is not an inherited property then it adds to sql sentence
          if List.IndexOf(PropList[i].Name) = -1 then
          begin
            if not FirstProperty then
            begin
              Properties := Properties + strComma + strSpace;
              Values := Values + strComma + strSpace;
            end;

            Properties := Properties + PropList[i].Name;

            // Property is a class, so we get its Id to store it
            if PropList[i].PropType^.Kind = tkClass then
            begin
              PropValue := IntToStr(CModel(GetObjectProp(Self, PropList[i].Name)).Save(Query,
                GetObjectPropClass(Self, PropList[i].Name), StoredProcNextId));
            end
            else
              PropValue := GetPropValue(Self, PropList[i].Name);

            if PropValue = null then
              PropValue := '0';

            Values := Values + '''' + PropValue + '''';

            FirstProperty := False;
          end;
        end;

        Properties := Properties + strEndParenthesis;
        Values := Values + strEndParenthesis;

        Sentence.Text := Sentence.Text + Properties + strValues + Values + strSemiColon;

        // Execute insert sentence
        try
          Query.SQL.Clear;
          Query.SQL.Assign(Sentence);
          Query.ExecSQL;
        except;
          Result := ecInsertion;
        end;

      finally
        Sentence.Free;
      end;

      List.Free;

      ClassRef := ClassRef.ClassParent;
    end; // End while
  end
  else // It is an existing object, so it updates it
  begin
    Result := FId;

    while ClassRef <> TPersistent do
    begin
      Sentence := TStringList.Create;
      try
        // Adds the first part of Update sql sentence
        Sentence.Add(strUpdate + ClassRef.ClassName);
        Sentence.Add(strSet);

        // Obtains the properties list of this class
        PropertiesCount := GetPropList(ClassRef.ClassInfo, tkProperties, @PropList);

        // Obtains the list of parent properties
        List := GetParentProperties(ClassRef);

        FirstProperty := True;
        for i := 0 to PropertiesCount - 1 do
        begin
          // If it is not an inherited property then it adds to sql sentence
          if List.IndexOf(PropList[i].Name) = -1 then
          begin
            if not FirstProperty then
              Sentence.Text := Sentence.Text + strComma + strSpace;

            // Property is a class, so we get its Id to store it
            if PropList[i].PropType^.Kind = tkClass then
            begin
              PropValue := IntToStr(CModel(GetObjectProp(Self, PropList[i].Name)).Save(Query,
                GetObjectPropClass(Self, PropList[i].Name), StoredProcNextId));
            end
            else
              PropValue := GetPropValue(Self, PropList[i].Name);

            if PropValue = null then
              PropValue := '0';

            Sentence.Add(PropList[i].Name + strEqual + '''' + PropValue + '''');
            FirstProperty := False;
          end;
        end;

        Sentence.Add(strWhere + strId + strEqual + IntToStr(Id) + strSemiColon);

        // Execute update sentence
        try
          Query.SQL.Clear;
          Query.SQL.Assign(Sentence);
          Query.ExecSQL;
        except;
          Result := ecUpdate;
        end;
      finally
        Sentence.Free;
      end;

      List.Free;

      ClassRef := ClassRef.ClassParent;
    end; // End of While
  end;
end;


end.
