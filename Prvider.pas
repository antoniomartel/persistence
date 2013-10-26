unit Prvider;

interface

uses Classes, SysUtils, TypInfo;

type

  TProvider = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;
    // Mapping Pascal types to SQL types
    function GetSQLType(PropertyKind: TTypeKind; PropertyClass: string): string;
  end;

var

  Provider: TProvider;

implementation

uses
  Constants;

{ TProvider }


//------------------------------------------------------------------------------
//                              Constructor Create
//------------------------------------------------------------------------------

constructor TProvider.Create;
begin
  if Provider = nil then
    Provider := inherited Create
  else
    raise Exception.Create(strSingletonCreationError);
end;



//------------------------------------------------------------------------------
//                               Destructor Create
//------------------------------------------------------------------------------

destructor TProvider.Destroy;
begin
  Provider := nil;
  inherited;
end;


//------------------------------------------------------------------------------
//                          Procedure GetSQLType
//------------------------------------------------------------------------------


function TProvider.GetSQLType(PropertyKind: TTypeKind; PropertyClass: string): string;
begin
  case PropertyKind of
    tkInteger:
      if (PropertyClass = 'Byte') or (PropertyClass = 'ShortInt') or
        (PropertyClass = 'SmallInt') then
        Result := itSmallInt
      else
        Result := itInteger;

    tkChar: Result := itChar;
    tkEnumeration: Result := itInteger;
    tkClass: Result := itInteger;

    tkFloat:
      if PropertyClass = 'TDateTime' then
        Result := itDate
      else
        if PropertyClass = 'TDate' then
          Result := itDate
        else
          if PropertyClass = 'TTime' then
            Result := itDate
          else
            Result := itNumeric;

    tkString:
      if PropertyClass = ptString15 then
        Result := itVarChar15
      else
        if PropertyClass = ptString30 then
          Result := itVarChar30
        else
          if PropertyClass = ptString50 then
            Result := itVarChar50
          else
            Result := itVarChar;

    else
      Result := itInteger;
  end;
end;


initialization
  Provider := TProvider.Create;

finalization
  Provider.Free;

end.
 