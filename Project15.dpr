program Project15;

uses
  Vcl.Forms,
  Spring.Container,
  Unit1 in 'Unit1.pas' {Form1},
  RTORM.Broker in 'RTORM.Broker.pas',
  RTORM.PersistenceCritieria in 'RTORM.PersistenceCritieria.pas',
  RTORM.SQLServer in 'RTORM.SQLServer.pas',
  RTORM.PersistentObject in 'RTORM.PersistentObject.pas',
  RoleOM in 'RoleOM.pas',
  RTORM.PersistenceMechanism in 'RTORM.PersistenceMechanism.pas',
  RTORM.Maps in 'RTORM.Maps.pas',
  RTORM.Maps.Attributes in 'RTORM.Maps.Attributes.pas',
  RTORM.DataSnap in 'RTORM.DataSnap.pas',
  RTORM.Sql in 'RTORM.Sql.pas',
  RTORM.SQLServer.StoredProcedure in 'RTORM.SQLServer.StoredProcedure.pas',
  RTORM.PersistenceMechanism.TextFiles in 'RTORM.PersistenceMechanism.TextFiles.pas',
  RTORM.UniDirectionalAssociationMap in 'RTORM.UniDirectionalAssociationMap.pas',
  ApplicationUserOM in 'ApplicationUserOM.pas';

{$R *.res}

begin
  GlobalContainer.Build;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
