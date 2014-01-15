unit RTORM.PersistenceMechanism;

interface

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
