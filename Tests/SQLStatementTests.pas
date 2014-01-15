unit SQLStatementTests;

interface

uses
  DUnitX.TestFramework;

type
  {$M+}
  [TestFixture('SimpleSELECTTests', 'General SELECT Tests')]
  TSimpleSELECTTests = class
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestAddSqlClause;

    [Test]
    procedure TestUpdateParamString;
    [Test]
    procedure TestUpdateParamInteger;
    [Test]
    procedure TestUpdateParamTDateTime;
    [Test]
    procedure TestUpdateParamCurrency;
    [Test]
    procedure TestUpdateParamBoolean;
    [Test]
    procedure TestAddSqlStatement;
  end;

implementation

uses
  CodeSiteLogging, RTORM.Sql, SysUtils, DateUtils;

{ TSimpleSELECTTests }

procedure TSimpleSELECTTests.Setup;
begin
  CodeSite.Enabled := False;
end;

procedure TSimpleSELECTTests.TearDown;
begin
  CodeSite.Enabled := True;
end;

procedure TSimpleSELECTTests.TestAddSqlClause;
var
  SQLSt : ISqlStatement;
begin
  SQLSt := TSqlStatement.Create;
  SQLSt.AddSqlClause('SELECT');

  Assert.AreEqual(SQLSt.ToString, 'SELECT');
end;

procedure TSimpleSELECTTests.TestAddSqlStatement;
var
  SQLSt : ISqlStatement;
  SQL2 : ISqlStatement;
begin
  SQLSt := TSqlStatement.Create;

  SQL2 := TSqlStatement.Create;
  SQL2.AddSqlClause('SELECT * FROM TEST');

  SQLSt.AddSqlStatement(SQL2);

  Assert.AreEqual(SQLSt.ToString, 'SELECT * FROM TEST');
end;

procedure TSimpleSELECTTests.TestUpdateParamBoolean;
var
  SQLSt : ISqlStatement;
begin
  SQLSt := TSqlStatement.Create;
  SQLSt.AddSqlClause('WHERE (test_id = :TestId)');
  SQLSt.UpdateParam('TestId', True);
  Assert.AreEqual(SQLSt.ToString, Format('WHERE (test_id = %s)', [QuotedStr('Y')]));
end;

procedure TSimpleSELECTTests.TestUpdateParamCurrency;
var
  SQLSt : ISqlStatement;
  ACurrency : Currency;
begin
  SQLSt := TSqlStatement.Create;
  SQLSt.AddSqlClause('WHERE (test_id = :TestId)');
  ACurrency := 125.58;
  SQLSt.UpdateParam('TestId', ACurrency);
  Assert.AreEqual(SQLSt.ToString, 'WHERE (test_id = 125.58)');
end;

procedure TSimpleSELECTTests.TestUpdateParamInteger;
var
  SQLSt : ISqlStatement;
begin
  SQLSt := TSqlStatement.Create;
  SQLSt.AddSqlClause('WHERE (test_id = :TestId)');
  SQLSt.UpdateParam('TestId', 100);
  Assert.AreEqual(SQLSt.ToString, 'WHERE (test_id = 100)');
end;

procedure TSimpleSELECTTests.TestUpdateParamString;
var
  SQLSt : ISqlStatement;
begin
  SQLSt := TSqlStatement.Create;
  SQLSt.AddSqlClause('WHERE (test_id = :TestId)');
  SQLSt.UpdateParam('TestId', 'RTAPSON');
  Assert.AreEqual(SQLSt.ToString, 'WHERE (test_id = ''RTAPSON'')');
end;

procedure TSimpleSELECTTests.TestUpdateParamTDateTime;
var
  SQLSt : ISqlStatement;
begin
  SQLSt := TSqlStatement.Create;
  SQLSt.AddSqlClause('WHERE (test_id = :TestId)');
  SQLSt.UpdateParam('TestId', Today);
  Assert.AreEqual(SQLSt.ToString, Format('WHERE (test_id = %s)', [QuotedStr(DateToStr(Today))]));
end;

initialization
  TDUnitX.RegisterTestFixture(TSimpleSELECTTests);

end.
