program RTORMTests;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  SQLStatementTests in 'SQLStatementTests.pas',
  RTORM.Sql in '..\RTORM.Sql.pas',
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.XML.NUnit,
  DUnitX.Windows.Console,
  RTORM.Test.Maps in 'RTORM.Test.Maps.pas',
  RTORM.Maps in '..\RTORM.Maps.pas',
  RTORM.Maps.Attributes in '..\RTORM.Maps.Attributes.pas',
  RTORM.PersistentObject in '..\RTORM.PersistentObject.pas',
  RTORM.PersistenceMechanism.TextFiles in '..\RTORM.PersistenceMechanism.TextFiles.pas',
  RTORM.PersistenceMechanism in '..\RTORM.PersistenceMechanism.pas',
  RTORM.PersistenceCritieria in '..\RTORM.PersistenceCritieria.pas',
  RTORM.UniDirectionalAssociationMap in '..\RTORM.UniDirectionalAssociationMap.pas',
  RTORM.Broker in '..\RTORM.Broker.pas',
  ApplicationUserOM in '..\ApplicationUserOM.pas',
  RTORM.SQLServer in '..\RTORM.SQLServer.pas',
  Spring.Container;

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
  try
    GlobalContainer.Build;

    //Create the runner
    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    //tell the runner how we will log things
    logger := TDUnitXConsoleLogger.Create(true);
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create;
    runner.AddLogger(logger);
    runner.AddLogger(nunitLogger);


    //Run tests
    results := runner.Execute;

    System.Write('Done.. press <Enter> key to quit.');
    System.Readln;
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
