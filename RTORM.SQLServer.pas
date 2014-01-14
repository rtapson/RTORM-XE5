unit RTORM.SQLServer;

interface

uses
  RTORM.persistencemechanism, SQLExpr, RTORM.Sql;

type
  IMSSQLServer = interface(IRelationalDatabase)
  ['{60135A53-FEB9-4478-BCCF-CFF5100BBE5A}']
    function GetSQLConnection: TSQLConnection;

//    function ExecuteSQL(aSQLStatement : ISqlStatement): TSQLDataSet;
    procedure ExecuteStatementNonQuery(aSQLStatement : ISqlStatement);
    property SqlConnection : TSQLConnection read GetSQLConnection;
  end;

  TMSSQLServerPersistenceMechanism = class(TRelationalDatabase, IMSSQLServer)
  private
    FSQLConnection : TSQLConnection;
    function GetSQLConnection: TSQLConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function Open: IPersistenceMechanism; override;
    function ExecuteSQL(aSQLStatement : ISqlStatement): TSQLDataSet; override;
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
    property SqlConnection : TSQLConnection read GetSQLConnection;
  end;

implementation

uses
  CodeSiteLogging, SysUtils, Dialogs, DBXMSSQL, DB, RTORM.Broker;

{ MSSQLServerPersistenceMechanism }

procedure TMSSQLServerPersistenceMechanism.Close;
begin
  FSQLConnection.Connected := False;
end;

constructor TMSSQLServerPersistenceMechanism.Create;
begin
  FSQLConnection := TSQLConnection.Create(nil);
end;

destructor TMSSQLServerPersistenceMechanism.Destroy;
begin
//  Close;
  FSQLConnection.Free;
  inherited;
end;

function TMSSQLServerPersistenceMechanism.ExecuteSQL(aSQLStatement : ISqlStatement): TSQLDataSet;
begin
  result := TSQLDataset.Create(nil);
  result.SQLConnection := FSQLConnection;
  result.CommandType := ctQuery;
  CodeSite.Send(aSQLStatement.ToString);
  result.CommandText := aSQLStatement.ToString;
  result.Open;
end;

procedure TMSSQLServerPersistenceMechanism.ExecuteStatementNonQuery(aSQLStatement : ISqlStatement);
var
  aDataset : TSQLDataSet;
begin
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

function TMSSQLServerPersistenceMechanism.GetSQLConnection: TSQLConnection;
begin
  result := FSQLConnection;
end;

function TMSSQLServerPersistenceMechanism.Open: IPersistenceMechanism;
begin
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

initialization
  PersistenceBroker.AddPersistenceMechansim('SQL', TMSSQLServerPersistenceMechanism.Create);

end.
