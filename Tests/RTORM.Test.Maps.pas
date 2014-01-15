unit RTORM.Test.Maps;

interface

uses
  DUnitX.TestFramework;

type
  {$M+}
  [TestFixture('RelationalDatabaseMapperTests', 'General Map Tests')]
  TRelationalDatabaseMapperMapTests = class
  private

  public
    [Setup]
    procedure Setup;

    [Test]
    procedure TestRetrieveObject;

  end;

implementation

uses
  RTORM.Maps, ApplicationUserOM, RTORM.SQLServer;

{ TRelationalDatabaseMapperMapTests }

procedure TRelationalDatabaseMapperMapTests.Setup;
begin
end;

procedure TRelationalDatabaseMapperMapTests.TestRetrieveObject;
var
  Database : IMSSQLServer;
  Mapper : IApplicationUserMapper;
  User : IApplicationUser;
begin
  Database := TMSSQLServerPersistenceMechanism.Create;

  Mapper := TApplicationMapperMapper.Create;
  User := TApplicationUser.Create('RTAPSON', '020');

  Mapper.RetrieveObject(User, Database);
  //Mapper.GetSelectSQLFor(User, FDatabase);
  Assert.AreEqual(User.ApplicationLoginId, 'RTAPSON');
end;

//initialization
//  TDUnitX.RegisterTestFixture(TRelationalDatabaseMapperMapTests);

end.
