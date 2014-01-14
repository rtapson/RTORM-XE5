unit RTORM.Test.Maps;

interface

uses
  DUnitX.TestFramework, RTORM.SQLServer;

type
  {$M+}
  [TestFixture('RelationalDatabaseMapperTests', 'General Map Tests')]
  TRelationalDatabaseMapperMapTests = class
  private
    FDatabase : IMSSQLServer;
  public
    [Setup]
    procedure Setup;

    [Test]
    procedure TestRetrieveObject;

  end;

implementation

uses
  RTORM.Maps, ApplicationUserOM;

{ TRelationalDatabaseMapperMapTests }

procedure TRelationalDatabaseMapperMapTests.Setup;
begin
  FDatabase := TMSSQLServerPersistenceMechanism.Create;
end;

procedure TRelationalDatabaseMapperMapTests.TestRetrieveObject;
var
  Mapper : IApplicationUserMapper;
  User : IAppplicationUser;
begin
  Mapper := TApplicationMapperMapper.Create;
  User := TApplicationUser.Create('RTAPSON', '020');

  Mapper.RetrieveObject(User, FDatabase);
  //Mapper.GetSelectSQLFor(User, FDatabase);
end;

initialization
  TDUnitX.RegisterTestFixture(TRelationalDatabaseMapperMapTests);

end.
