unit RTORM.PersistenceMechanism;

interface

uses
  RTORM.Sql, SQLExpr;

type
  IPersistenceMechanism = interface
  ['{BD0C032B-BAB3-4BD4-8A6D-7BAC2D14DC07}']
    function IsOpen: boolean;
    procedure Close;
    function Open: IPersistenceMechanism;
    procedure SetConnectionName(const Value: string);
    function GetConnectionName(): string;
    property ConnectionName: string read GetConnectionName write SetConnectionName;
  end;

  TPersistenceMechanism = class(TInterfacedObject, IPersistenceMechanism)
  private
    FConnectionName: string;
    function GetConnectionName: string;
    procedure SetConnectionName(const Value: string);
  public
    function IsOpen: boolean; virtual; abstract;
    function Open: IPersistenceMechanism; virtual; abstract;
    procedure Close; virtual; abstract;
    property ConnectionName: string read GetConnectionName write SetConnectionName;
  end;

  TFlatFile = class(TPersistenceMechanism)
  end;

  TTestTextFile = class(TFlatFile)
  private
    FFileName: string;
  public
    constructor Create(const Name: string; const FileName: string);
    function IsOpen: boolean; override;
    procedure Close; override;
    function Open: IPersistenceMechanism; override;
  end;

  IRelationalDatabase = interface(IPersistenceMechanism)
  ['{A6E39C21-8C74-42E3-B7E1-1A4DB09020F5}']
    procedure ProcessSql;
    function ExecuteSQL(aSQLStatement : ISqlStatement): TSQLDataSet;
    procedure ExecuteStatementNonQuery(aSQLStatement : ISqlStatement);
    function GetClauseStringDelete: string;
    function GetClauseStringSelect: string;
    function GetClauseStringInsert: string;
    function GetClauseStringUpdate: string;
    function GetClauseStringFrom: string;
    function GetClauseStringOrderBy: string;
    function GetClauseStringWhere: string;
    function GetClauseStringAndBegin: string;
    function GetClauseStringAndEnd: string;
    function GetClauseStringOrBegin: string;
    function GetClauseStringOrEnd: string;
    function GetClauseStringDistinct: string;
    function GetClauseStringSet: string;
    function GetClauseStringValues: string;
    function GetClauseStringInnerJoin: string;
  end;

  TRelationalDatabase = class(TPersistenceMechanism, IRelationalDatabase)
  public
    procedure ProcessSql; virtual; abstract;
    function ExecuteSQL(aSQLStatement : ISqlStatement): TSQLDataSet; virtual; abstract;
    procedure ExecuteStatementNonQuery(aSQLStatement : ISqlStatement); virtual; abstract;
    function GetClauseStringDelete: string; virtual; abstract;
    function GetClauseStringSelect: string; virtual; abstract;
    function GetClauseStringInsert: string; virtual; abstract;
    function GetClauseStringUpdate: string; virtual; abstract;
    function GetClauseStringFrom: string; virtual; abstract;
    function GetClauseStringOrderBy: string; virtual; abstract;
    function GetClauseStringWhere: string; virtual; abstract;
    function GetClauseStringAndBegin: string; virtual; abstract;
    function GetClauseStringAndEnd: string; virtual; abstract;
    function GetClauseStringOrBegin: string; virtual; abstract;
    function GetClauseStringOrEnd: string; virtual; abstract;
    function GetClauseStringDistinct: string; virtual; abstract;
    function GetClauseStringSet: string; virtual; abstract;
    function GetClauseStringValues: string; virtual; abstract;
    function GetClauseStringInnerJoin: string; virtual; abstract;
  end;

implementation

function TPersistenceMechanism.GetConnectionName: string;
begin
  result := FConnectionName;
end;

procedure TPersistenceMechanism.SetConnectionName(const Value: string);
begin
  FConnectionName := Value;
end;

procedure TTestTextFile.Close;
begin
end;

function TTestTextFile.IsOpen: boolean;
begin
  result := True;
end;

function TTestTextFile.Open: IPersistenceMechanism;
begin
  result := TPersistenceMechanism.Create;
end;

constructor TTestTextFile.Create(const Name: string; const FileName: string);
begin
  FConnectionName := Name;
  FFileName := FileName;
end;

end.
