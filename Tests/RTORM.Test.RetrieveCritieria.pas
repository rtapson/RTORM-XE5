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
  CodeSiteLogging,
  RTORM.PersistenceCritieria, Sysutils, ApplicationUserOM, Spring.Collections,
  RTORM.Broker, RTORM.Maps, RTORM.SQLServer, RTORM.PersistentObject;

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
  SQL : IMSSQLServer;
  RetCrit : IRetrieveCritieria;
  ObjList : IList<IApplicationUser>;
  aDateTime : TDateTime;
begin
  //Upfront work, not needed in an actual system
  SQL := TMSSQLServerPersistenceMechanism.Create;
  PersistenceBroker.DataStore := 'SQL';
  PersistenceBroker.AddClassMap(TApplicationUser.ClassName + '.SQL', TApplicationMapperMapper.Create as IClassMap);
  PersistenceBroker.AddPersistenceMechansim('SQL', SQL);

  //Stuff that a developer would need to do
  ObjList := TCollections.CreateList<IApplicationUser>;

  RetCrit := TRetrieveCritieria.Create(TApplicationUser.ClassName);
//  RetCrit.AddSelectEqualTo('ApplicationLoginId', 'RTAPSON');
  RetCrit.AddSelectEqualTo('CompanyNumber', '020');
  aDateTime := Now - 360;
  RetCrit.AddGreaterThan('LastLoginDate', aDateTime);
  RetCrit.AddLessThanOrEqualTo('ApplicationLoginId', 'RTAPSON');

  CodeSite.Send(RetCrit.ToString);
{  RetCrit.Perform.ForEach(
    procedure(const Obj : IPersistentObject)
    begin
      ObjList.Add(Obj as IApplicationUser);
    end);}

//  Assert.AreEqual(ObjList.First.ApplicationLoginId, 'RTAPSON');
end;

initialization
  TDUnitX.RegisterTestFixture(TRetrieveCritieriaTests);

end.
