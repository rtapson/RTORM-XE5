unit RTORM.Test.RetrieveCritieria;

interface

uses
  DUnitX.TestFramework;

type
  {$M+}
  [TestFixture('RetrieveCritieriaTests', 'General RetrieveCritieria Tests')]
  TRetrieveCritieriaTests = class
  private

  public
    [Setup]
    procedure Setup;

    [Test]
    procedure TestCreateRetrieveCritieria;

    [Test]
    procedure TestRetrieveCritieria;

  end;


implementation

uses
  RTORM.PersistenceCritieria, Sysutils, ApplicationUserOM, Spring.Collections,
  RTORM.Broker, RTORM.Maps;

{ TRetrieveCritieriaTests }

procedure TRetrieveCritieriaTests.Setup;
begin

end;

procedure TRetrieveCritieriaTests.TestCreateRetrieveCritieria;
var
  Crit : IEqualToCritieria;
begin
  Crit := TEqualToCritieria.Create('ID', 'RTAPSON');

  Assert.AreEqual(Crit.AttributeName, 'ID');
  Assert.AreEqual(Crit.AsSQLClause, Format('ID = %s', [QuotedStr('RTAPSON')]));
end;

procedure TRetrieveCritieriaTests.TestRetrieveCritieria;
var
  RetCrit : IRetrieveCritieria;
  ObjList : IList<IApplicationUser>;
begin
  PersistenceBroker.DataStore := 'SQL';
  PersistenceBroker.AddClassMap(TApplicationUser.ClassName + '.SQL', TApplicationMapperMapper.Create as IClassMap);

  RetCrit := TRetrieveCritieria.Create(TApplicationUser.ClassName);
  RetCrit.AddSelectEqualTo('ApplicationLoginId', 'RTAPSON');
  RetCrit.Perform;
end;

initialization
  TDUnitX.RegisterTestFixture(TRetrieveCritieriaTests);

end.
