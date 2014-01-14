unit RTORM.DataSnap;

interface

uses
  RTORM.PersistenceMechanism, SqlExpr;

type
  IDataSnapMechanism = interface(IPersistenceMechanism)
    ['{42230812-F898-43DB-A265-860E520AFAB8}']
  end;

  TDataSnapMechanism = class(TPersistenceMechanism, IDataSnapMechanism)
  private
    FSQLConnection : TSQLConnection;
  public
    constructor Create;
    function IsOpen: boolean; override;
    function Open: IPersistenceMechanism; override;
    procedure Close; override;
  end;

implementation

uses
  RTORM.Broker, SysUtils;

{ TDataSnapMechanism }

procedure TDataSnapMechanism.Close;
begin
//  inherited;
  FSQLConnection.Close;
end;

constructor TDataSnapMechanism.Create;
begin
  FSQLConnection := TSQLConnection.Create(nil);
end;

function TDataSnapMechanism.IsOpen: boolean;
begin
  result := FSQLConnection.Connected;
end;

function TDataSnapMechanism.Open: IPersistenceMechanism;
begin
  FSQLConnection.DriverName := 'Datasnap';
  FSQLConnection.Params.Values['driver'] := 'Datasnap';

  FSQLConnection.Params.Add(Format('HostName=%s', ['localhost']));
  FSQLConnection.Params.Add(Format('Port=%d', [211]));
  FSQLConnection.Params.Add(Format('BufferKBSize=%d', [32]));


{  FSQLConnection.Params.Add(Format('HostName=%s', [Configuration.HostName]));
  FSQLConnection.Params.Add(Format('Port=%d', [Configuration.Port]));
  FSQLConnection.Params.Add(Format('BufferKBSize=%d', [Configuration.BufferKBSize]));
 }
  FSQLConnection.Connected := True;
  result := Self;
end;

initialization
  PersistenceBroker.AddPersistenceMechansim('Datasnap', TDataSnapMechanism.Create);

end.
