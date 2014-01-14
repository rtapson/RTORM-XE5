unit RTORM.SQLServer.StoredProcedure;

interface

uses
  RTORM.SQLServer, RTORM.Sql, SQLExpr;

type
  ISqlServerStoredProcedure = interface(IMSSQLServer)
    ['{E3289085-66C5-4DA8-87C4-BC4AF76B3CA3}']
    function ExecuteStoredProcedure(aSqlStatement : ISqlStatement): integer;
    function OpenStoredProcedure(aSqlStatement : ISqlStatement): TSQLDataSet;
  end;

  TSqlServerStoredProcedure = class(TMSSQLServerPersistenceMechanism, ISqlServerStoredProcedure)
  public
    function ExecuteStoredProcedure(aSqlStatement: ISqlStatement): Integer;
    function OpenStoredProcedure(aSqlStatement: ISqlStatement): TSQLDataSet;
  end;

implementation

uses
  CodeSiteLogging, Data.DB;

{ TSqlServerStoredProcedure }

function TSqlServerStoredProcedure.ExecuteStoredProcedure(aSqlStatement: ISqlStatement): Integer;
begin
{  result := TSQLDataset.Create(nil);
  result.SQLConnection := FSQLConnection;
  result.CommandType := ctQuery;
  CodeSite.Send(aSQLStatement.ToString);
  result.CommandText := aSQLStatement.ToString;
  result.Open;}
end;

function TSqlServerStoredProcedure.OpenStoredProcedure(aSqlStatement: ISqlStatement): TSQLDataSet;
begin
  result := TSQLDataset.Create(nil);
  result.SQLConnection := SQLConnection;
  result.CommandType := ctQuery;
  CodeSite.Send(aSQLStatement.ToString);
  result.CommandText := aSQLStatement.ToString;
  result.Open;
end;

end.
