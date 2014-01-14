unit SQLStatementTests.Statement;

interface

uses
  DUnitX.TestFramework;

type
  {$M+}
  [TestFixture('SQLStatementTests', 'General SQLStatementTests Tests')]
  TSQLStatementTests = class
  public
    [Test]
    procedure TestAddSqlStatement;
  end;

implementation

uses
  RTORM.Sql;

{ TSQLStatementTests }

procedure TSQLStatementTests.TestAddSqlStatement;
var
  SQLSt : ISqlStatement;
begin
  SQLSt := TSqlStatement.Create;

end;

initialization
  TDUnitX.RegisterTestFixture(TSQLStatementTests);

end.
