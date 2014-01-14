unit RTORM.PersistentObject;

interface

uses
  Classes;

type
  IPersistentObject = interface
  ['{C0CFEF17-530F-4FBE-83FF-EF133970ABF8}']
    function GetIsPersistent(): boolean;
    function GetIsDirty: Boolean;
    function GetIsProxy: Boolean;
    procedure Delete;
    procedure Retrieve;
    procedure RetrieveAsProxy;
    procedure Save;
    property IsPersistent: boolean read GetIsPersistent;
    property IsDirty : Boolean read GetIsDirty;
    property IsProxy: Boolean read GetIsProxy;
  end;

  TPersistentObject = class(TInterfacedPersistent, IPersistentObject)
  private
    FIsPersistent: boolean;
    FIsDirty: Boolean;
    FIsProxy : Boolean;
    function GetIsPersistent: boolean;
    function GetIsDirty: Boolean;
    procedure SetIsPersistent(val: boolean);
    function GetIsProxy: Boolean;
  public
    constructor Create; virtual;
    procedure Delete;
    procedure Retrieve;
    procedure RetrieveAsProxy;
    procedure Save;
    property IsPersistent: boolean read GetIsPersistent;
    property IsDirty : Boolean read GetIsDirty;
    property IsProxy: Boolean read GetIsProxy;
  end;

implementation

uses
  RTORM.Broker;

constructor TPersistentObject.Create;
begin
  FIsPersistent := False;
  FIsDirty := False;
  FIsProxy := False;
end;

procedure TPersistentObject.Delete;
begin
  PersistenceBroker.DeleteObject(Self);
end;

function TPersistentObject.GetIsDirty: Boolean;
begin
  Result := FIsDirty;
end;

function TPersistentObject.GetIsPersistent: boolean;
begin
  result := FIsPersistent;
end;

function TPersistentObject.GetIsProxy: Boolean;
begin
  result := FIsProxy;
end;

procedure TPersistentObject.Retrieve;
begin
  PersistenceBroker.RetrieveObject(Self);
  FIsPersistent := True;
end;

procedure TPersistentObject.RetrieveAsProxy;
begin
  PersistenceBroker.RetrieveObject(Self);
end;

procedure TPersistentObject.Save;
begin
  PersistenceBroker.SaveObject(Self);
end;

procedure TPersistentObject.SetIsPersistent(val: boolean);
begin
  FIsPersistent := val;
end;

end.
