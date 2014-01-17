unit RTORM.SQLServer;

interface

uses
  RTORM.persistencemechanism, SQLExpr, RTORM.Sql, RTORM.PersistentObject, RTORM.Maps.Attributes,
  RTORM.PersistenceMechanism.Database, Spring.Collections;

type
  IMSSQLServer = interface(IRelationalDatabase)
  ['{60135A53-FEB9-4478-BCCF-CFF5100BBE5A}']
    //function GetSQLConnection: TSQLConnection;

//    function ExecuteSQL(aSQLStatement : ISqlStatement): IPersistentObject;
    procedure ExecuteStatementNonQuery(aSQLStatement : ISqlStatement);
    //property SqlConnection : TSQLConnection read GetSQLConnection;
  end;

  TMSSQLServerPersistenceMechanism = class(TRelationalDatabase, IMSSQLServer)
  private
    FSQLConnection : TSQLConnection;
    FDataset : TSQLDataSet;
    FAttributes :  IDictionary<string, IAttributeMap>;
//    function GetSQLConnection: TSQLConnection;
    procedure DatasetToObject(aObj : IPersistentObject);
  public
    constructor Create;
    destructor Destroy; override;
    function Open: IPersistenceMechanism; override;
    function ExecuteSQL(aSQLStatement : ISqlStatement; Attributes : IDictionary<string, IAttributeMap>; const ClassName : string): IList<IPersistentObject>; override;
    procedure ExecuteStatementNonQuery(aSQLStatement : ISqlStatement); override;
    procedure Close; override;
    function GetClauseStringAndBegin: string; override;
    function GetClauseStringAndEnd: string; override;
    function GetClauseStringOrBegin: string; override;
    function GetClauseStringOrEnd: string; override;
    function GetClauseStringDelete: string; override;
    function GetClauseStringInsert: string; override;
    function GetClauseStringOrderBy: string; override;
    function GetClauseStringSelect: string; override;
    function GetClauseStringUpdate: string; override;
    function GetClauseStringWhere: string; override;
    function GetClauseStringFrom: string; override;
    function GetConnectionName: string;
    function GetClauseStringDistinct: string; override;
    function GetClauseStringSet: string; override;
    function GetClauseStringValues: string; override;
    function GetClauseStringInnerJoin: string; override;
    //function ProcessSQL(const SQLStatement: string): PersistentObjectList; override;
//    property SqlConnection : TSQLConnection read GetSQLConnection;
  end;

implementation

uses
  CodeSiteLogging, SysUtils, DBXMSSQL, DB, RTORM.Broker, RTORM.Maps,
  Rtti, System.TypInfo, ActiveX, Spring.Services;

{ MSSQLServerPersistenceMechanism }

procedure TMSSQLServerPersistenceMechanism.Close;
begin
  CodeSite.EnterMethod(Self, 'Close');
  FDataset.Close;
  FSQLConnection.Connected := False;
  CodeSite.ExitMethod(Self, 'Close');
end;

constructor TMSSQLServerPersistenceMechanism.Create;
begin
  CodeSite.EnterMethod(Self, 'Create');

  FSQLConnection := TSQLConnection.Create(nil);

  FDataset := TSQLDataSet.Create(nil);
  FDataset.SQLConnection := FSQLConnection;
  FDataset.CommandType := ctQuery;
  CodeSite.ExitMethod(Self, 'Create');
end;

procedure TMSSQLServerPersistenceMechanism.DatasetToObject(aObj: IPersistentObject);
var
  Attrib: IAttributeMap;
  context: TRttiContext;
  rtti: TRTTIType;
  value : TValue;
  i : integer;
begin
//  CodeSite.EnterMethod(Self, 'DatasetToObject');

  context := TRttiContext.Create;
  try
    rtti := context.GetType(TObject(aObj).ClassInfo);
    try
      for Attrib in FAttributes.Values do
      begin
        case rtti.GetField('F' + Attrib.Name).FieldType.TypeKind of
          tkWChar,
          tkLString,
          tkWString,
          tkString,
          tkChar,
          tkUString : Value := FDataset.FieldByName(Attrib.ColumnMap.Name).AsString;
          tkInteger,
          tkInt64  :
            begin
              Value := StrToIntDef(FDataset.FieldByName(Attrib.ColumnMap.Name).AsString, 0);
            end;
          tkFloat  :
            begin
              case  FDataset.FieldByName(Attrib.ColumnMap.Name).DataType of
                ftDateTime, ftTimeStamp : Value := FDataset.FieldByName(Attrib.ColumnMap.Name).AsDateTime;
              else
                Value := StrToFloat(FDataset.FieldByName(Attrib.ColumnMap.Name).AsString);
              end;
            end;
          tkEnumeration:
            begin
              if rtti.GetField('F' + Attrib.Name).FieldType.Name = 'Boolean' then
                Value := TValue.From(FDataset.FieldByName(Attrib.ColumnMap.Name).AsString = 'Y')
              else
                Value := TValue.FromOrdinal(Value.TypeInfo, GetEnumValue(Value.TypeInfo, FDataset.FieldByName(Attrib.ColumnMap.Name).AsString));
            end;
          tkSet:
            begin
              i :=  StringToSet(Value.TypeInfo, FDataset.FieldByName(Attrib.ColumnMap.Name).AsString);
              TValue.Make(@i, Value.TypeInfo, Value);
            end;
        else
          raise ETypeNotSupported.Create('Type not Supported');
        end;
        rtti.GetField('F' + Attrib.Name).SetValue(TObject(aObj), Value)
      end;
    finally
      rtti.Free;
    end;
  finally
    context.free;
  end;
//  CodeSite.ExitMethod(Self, 'DatasetToObject');
end;

destructor TMSSQLServerPersistenceMechanism.Destroy;
begin
  CodeSite.EnterMethod(Self, 'Destroy');
  Close;
  FDataset.Free;
  FSQLConnection.Free;
  CoUninitialize;
  inherited;
  CodeSite.ExitMethod(Self, 'Destroy');
end;

function TMSSQLServerPersistenceMechanism.ExecuteSQL(aSQLStatement : ISqlStatement;  Attributes : IDictionary<string, IAttributeMap>; const ClassName : string): IList<IPersistentObject>;
var
  Obj : IPersistentObject;
begin
  CodeSite.EnterMethod(Self, 'ExecuteSQL');
  CodeSite.Send(aSQLStatement.ToString);
  Codesite.Send('ClassName', ClassName);

  result := TCollections.CreateList<IPersistentObject>;
  FAttributes := Attributes;
  FDataset.CommandText := aSQLStatement.ToString;
  FDataset.Open;
  while not FDataset.Eof do
  begin
    Obj := ServiceLocator.GetService<IPersistentObject>(ClassName);
    DatasetToObject(Obj);
    result.Add(Obj);
    FDataset.Next;
  end;
  CodeSite.ExitMethod(Self, 'ExecuteSQL');
end;

procedure TMSSQLServerPersistenceMechanism.ExecuteStatementNonQuery(aSQLStatement : ISqlStatement);
var
  aDataset : TSQLDataSet;
begin
  CodeSite.EnterMethod(Self, 'ExecuteStatementNonQuery');

  CodeSite.Send(aSQLStatement.ToString);
//  CodeSite.Send(aSQLStatement.ToString);
{  aDataset := TSQLDataset.Create(nil);
  try
    aDataset.SQLConnection := FSQLConnection;
    aDataset.CommandType := ctQuery;
    aDataset.CommandText := aSQL;
    if aDataset.ExecSQL <> 0 then
      raise Exception.Create('Object delete failed');
  finally
    aDataset.Free;
  end;}
  CodeSite.ExitMethod(Self, 'ExecuteStatementNonQuery');
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringAndBegin: string;
begin
  result := 'AND (';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringAndEnd: string;
begin
  result := ')';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringOrBegin: string;
begin
  result := 'OR (';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringOrEnd: string;
begin
  result := ')';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringDelete: string;
begin
  result := 'DELETE';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringDistinct: string;
begin
  result := 'DISTINCT';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringFrom: string;
begin
  result := 'FROM';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringInnerJoin: string;
begin
  result := 'INNER JOIN';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringInsert: string;
begin
  result := 'INSERT INTO';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringOrderBy: string;
begin
  result := 'ORDER BY';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringSelect: string;
begin
  result := 'SELECT';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringSet: string;
begin
  result := 'SET';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringUpdate: string;
begin
  result := 'UPDATE';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringValues: string;
begin
  result := 'VALUES (';
end;

function TMSSQLServerPersistenceMechanism.GetClauseStringWhere: string;
begin
  result := 'WHERE';
end;

function TMSSQLServerPersistenceMechanism.GetConnectionName: string;
begin
  result := 'SQL';
end;

{function TMSSQLServerPersistenceMechanism.GetSQLConnection: TSQLConnection;
begin
  result := FSQLConnection;
end;}

function TMSSQLServerPersistenceMechanism.Open: IPersistenceMechanism;
begin
  CodeSite.EnterMethod(Self, 'Open');
  CoInitializeEx(nil, 0);
  FSQLConnection.DriverName := 'MSSQL';
  FSQLConnection.Params.Values['driver'] := 'MSSQL';
//  FSQLConnection.Params.Values['OS Authentication'] := 'False';
  FSQLConnection.Params.Values['OS Authentication'] := 'True';
  FSQLConnection.Params.Values['Database'] := 'orderentry';
  FSQLConnection.Params.Values['HostName'] := 'pdentdev\pattdent';
  //FSQLConnection.Params.Values['User_Name'] := 'vista';
  //FSQLConnection.Params.Values['Password'] := '2bsxlim3';
  FSQLConnection.Connected := True;
  result := Self;
  CodeSite.ExitMethod(Self, 'Open');
end;

{function TMSSQLServerPersistenceMechanism.ProcessSQL(const SQLStatement: string): PersistentObjectList;
var
  aDataset : TSQLDataSet;
begin
  Open;
  aDataset := TSQLDataSet.Create(nil);
  try
    aDataset.SQLConnection := FSQLConnection;
    aDataset.CommandType := ctStoredProc;
    aDataset.CommandText := SQLStatement;
    aDataset.Open;

    if aDataset.RecordCount > 0 then
      ShowMessage('got records');
  finally
    aDataset.Free;
  end;
end;}

//initialization
//  PersistenceBroker.AddPersistenceMechansim('SQL', TMSSQLServerPersistenceMechanism.Create);

end.
