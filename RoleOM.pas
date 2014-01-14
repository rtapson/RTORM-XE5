unit RoleOM;

interface

uses
  rtorm.maps, Spring.Collections, rtorm.PersistentObject;

type
  {
    What I'd like to do is this
      TRoleType = (rtUser = 1, rtSystem = 2);
    But I can't because delphi will not give rtti for enums with ordinal positions.
  }
  TRoleType = (rtUser, rtSystem);

  IPermission = interface
    ['{EF2F7909-4BE9-48CE-9513-EF32356BC93C}']
    function GetApplicationResourceID: integer;
    function GetClientResourceID: integer;
    function GetParentResourceID: integer;
    function GetResourceName: string;
    function GetHasAccess: Boolean;
    function GetGrantor: string;
    procedure SetHasAccess(const Value : boolean);
    procedure SetGrantor(const Value: string);
    property ApplicationResourceID : integer read GetApplicationResourceID;
    property ClientResourceID : integer read GetClientResourceID;
    property ParentResourceID : integer read GetParentResourceID;
    property ResourceName : string read GetResourceName;
    property HasAccess : Boolean read GetHasAccess write SetHasAccess;
    property Grantor : string read GetGrantor Write SetGrantor;
  end;

  TPermission = class(TPersistentObject, IPermission)
  private
    FApplicationRoleID : integer;
    FApplicationResourceID : integer;
    FClientResourceID : integer;
    FParentResourceID: integer;
    FResourceName: string;
    FHasAccess: Boolean;
    FGrantor: string;

    function GetApplicationResourceID: integer;
    function GetClientResourceID: integer;
    function GetGrantor: string;
    function GetHasAccess: Boolean;
    function GetParentResourceID: integer;
    function GetResourceName: string;
    procedure SetGrantor(const Value: string);
    procedure SetHasAccess(const Value: Boolean);
  public
    property ApplicationResourceID : integer read GetApplicationResourceID;
    property ClientResourceID : integer read GetClientResourceID;
    property ParentResourceID : integer read GetParentResourceID;
    property ResourceName : string read GetResourceName;
    property HasAccess : Boolean read GetHasAccess write SetHasAccess;
    property Grantor : string read GetGrantor Write SetGrantor;
  end;

  IRole = interface(IPersistentObject)
    ['{B6EFA8C9-E31E-4901-8D2A-2C2250FFE295}']
    function Getname: string;
    function GetActive: Boolean;
    function GetModifiedByLoginId: string;
    function GetDateModified: TDateTime;
    function GetDateCreated: TDateTime;
    function GetPermissions: IDictionary<integer, IPermission>;
    function GetID: integer;

    procedure SetName(const Value : string);
    procedure SetActive(const Value: boolean);
    procedure SetModifiedByLoginId(const Value : string);
    procedure SetDateModified(const Value : TDateTime);
    procedure SetDateCreated(const Value: TDateTime);
    procedure SetPermissions(const Value: IDictionary<integer, IPermission>);
    function GetRoleType: TRoleType;
    procedure SetRoleType(const Value: TRoleType);

    property ID : integer read GetID;
    property Name : string read GetName write SetName;
    property Active : boolean read GetActive write SetActive;
    property ModifiedByLoginId : string read GetModifiedByLoginId write SetModifiedByLoginId;
    property DateModified : TDateTime read GetDateModified write SetDateModified;
    property DateCreated : TDateTime read GetDateCreated write SetDateCreated;
    property RoleType : TRoleType read GetRoleType write SetRoleType;
    property Permissions : IDictionary<integer, IPermission> read GetPermissions write SetPermissions;
  end;

  TRole = class(TPersistentObject, IRole)
  private
    FActive : boolean;
    FName : string;
    FModifiedByLoginId : string;
    FDateModified : TDateTime;
    FDateCreated : TDateTime;
    FRoleType : Integer;
    FPermissions : IDictionary<integer, IPermission>;
    FID : integer;

    function GetActive: boolean;
    function GetDateCreated: TDateTime;
    function GetDateModified: TDateTime;
    function GetModifiedByLoginId: string;
    function GetName: string;
    function GetPermissions: IDictionary<integer, IPermission>;
    procedure SetActive(const Value: boolean);
    procedure SetDateCreated(const Value: TDateTime);
    procedure SetDateModified(const Value: TDateTime);
    procedure SetModifiedByLoginId(const Value: string);
    procedure SetName(const Value: string);
    procedure SetPermissions(const Value: IDictionary<integer, IPermission>);
    function GetRoleType: TRoleType;
    procedure SetRoleType(const Value: TRoleType);
    function GetID: integer;
  public
    constructor Create(ObjectID : integer); overload;
    property ID : integer read GetID;
    property Name : string read GetName write SetName;
    property Active : boolean read GetActive write SetActive;
    property ModifiedByLoginId : string read GetModifiedByLoginId write SetModifiedByLoginId;
    property DateModified : TDateTime read GetDateModified write SetDateModified;
    property DateCreated : TDateTime read GetDateCreated write SetDateCreated;
    property RoleType : TRoleType read GetRoleType write SetRoleType;
    property Permissions : IDictionary<integer, IPermission> read GetPermissions write SetPermissions;
  end;

  IRoleMapper = interface(IClassMap)
    ['{FC3065F1-56AC-4E82-B7C2-A497ED8107BC}']
  end;

  TRoleMapper = class(TRelationalDatabaseMapper, IRoleMapper)
  public
    constructor Create; override;
  end;

  IPermissionMapper = interface(IClassMap)
    ['{76496373-33FC-478C-9B79-08050AF81666}']
  end;

  TPermsissionMapper = class(TRelationalDatabaseMapper, IPermissionMapper)
  public
    constructor Create; override;
  end;

implementation

uses
  CodeSiteLogging, RTORM.maps.Attributes, RTORM.Broker, Classes,
  RTORM.UniDirectionalAssociationMap, Spring.Container;

{ TRole }

constructor TRole.Create(ObjectID: integer);
begin
  FID := ObjectID;
  FPermissions := TCollections.CreateDictionary<integer, IPermission>;
end;

function TRole.GetActive: boolean;
begin
  result := FActive;
end;

function TRole.GetDateCreated: TDateTime;
begin
  result := FDateCreated;
end;

function TRole.GetDateModified: TDateTime;
begin
  result := FDateModified;
end;

function TRole.GetID: integer;
begin
  result := FID;
end;

function TRole.GetModifiedByLoginId: string;
begin
  result := FModifiedByLoginId;
end;

function TRole.GetName: string;
begin
  result := FName;
end;

function TRole.GetPermissions: IDictionary<integer, IPermission>;
begin
  result := FPermissions;
end;

function TRole.GetRoleType: TRoleType;
begin
  result := TRoleType(FRoleType - 1);
end;

procedure TRole.SetActive(const Value: boolean);
begin
  FActive := Value;
end;

procedure TRole.SetDateCreated(const Value: TDateTime);
begin
  FDateCreated := Value;
end;

procedure TRole.SetDateModified(const Value: TDateTime);
begin
  FDateModified := Value;
end;

procedure TRole.SetModifiedByLoginId(const Value: string);
begin
  FModifiedByLoginId := Value;
end;

procedure TRole.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TRole.SetPermissions(const Value: IDictionary<integer, IPermission>);
begin
  FPermissions := Value;
end;

procedure TRole.SetRoleType(const Value: TRoleType);
begin
  FRoleType := Ord(Value) + 1;
end;

{ TRoleMapper }

constructor TRoleMapper.Create;
var
  ID, NameAtt, ActiveAtt, ModifiedByAtt, DateModAtt, DateCreatedAtt, RoleTypeAtt : IAttributeMap;
  UniMap : IUniDirectionalAssociationMap;
begin
  inherited;

  ID := TAttributeMap.Create('ID');
  ID.ColumnMap.Name := 'application_role_id';
  ID.ColumnMap.ColumnType := ktPrimary;
  ID.ColumnMap.TableMap.Name := 'APPLICATION_ROLE';
  AttributeMaps.Add('ID', ID);

  NameAtt := TAttributeMap.Create('Name');
  NameAtt.ColumnMap.Name := 'application_role_name';
  //NameAtt.ColumnMap.ColumnType := ktPrimary;
  NameAtt.ColumnMap.TableMap.Name := 'APPLICATION_ROLE';
  AttributeMaps.Add('Name', NameAtt);

  ActiveAtt := TAttributeMap.Create('Active');
  ActiveAtt.ColumnMap.Name := 'is_active';
  ActiveAtt.ColumnMap.TableMap.Name := 'APPLICATION_ROLE';
  AttributeMaps.Add('Active', ActiveAtt);

  ModifiedByAtt := TAttributeMap.Create('ModifiedByLoginId');
  ModifiedByAtt.ColumnMap.Name := 'modified_by_login_id';
  ModifiedByAtt.ColumnMap.TableMap.Name := 'APPLICATION_ROLE';
  AttributeMaps.Add('ModifiedByLoginId', ModifiedByAtt);

  DateModAtt := TAttributeMap.Create('DateModified');
  DateModAtt.ColumnMap.Name := 'date_modified';
  DateModAtt.ColumnMap.TableMap.Name := 'APPLICATION_ROLE';
  AttributeMaps.Add('DateModified', DateModAtt);

  DateCreatedAtt := TAttributeMap.Create('DateCreated');
  DateCreatedAtt.ColumnMap.Name := 'date_created';
  DateCreatedAtt.ColumnMap.TableMap.Name := 'APPLICATION_ROLE';
  AttributeMaps.Add('DateCreated', DateCreatedAtt);

  RoleTypeAtt := TAttributeMap.Create('RoleType');
  RoleTypeAtt.ColumnMap.Name := 'application_role_type';
  //RoleTypeAtt.ColumnMap.ColumnType := ktForeign;
  RoleTypeAtt.ColumnMap.TableMap.Name := 'APPLICATION_ROLE';
  AttributeMaps.Add('RoleType', RoleTypeAtt);

  UniMap := TUniDirectionalAssociationMap.Create;
  UniMap.TargetClassName := TPermission.ClassName;
  UniMap.TargetName := 'Permissions';
  UniMap.AddParam(ID, 'ApplicationRoleID');
  UniMap.Cardinality := cnOnetoMany;
  Associations.Add(UniMap);
end;

{ TPermission }

function TPermission.GetApplicationResourceID: integer;
begin
  result := FApplicationResourceID;
end;

function TPermission.GetClientResourceID: integer;
begin
  result := FClientResourceID;
end;

function TPermission.GetGrantor: string;
begin
  result := FGrantor;
end;

function TPermission.GetHasAccess: Boolean;
begin
  result := FHasAccess;
end;

function TPermission.GetParentResourceID: integer;
begin
  result := FParentResourceID;
end;

function TPermission.GetResourceName: string;
begin
  result := FResourceName;
end;

procedure TPermission.SetGrantor(const Value: string);
begin
  FGrantor := Value;
end;

procedure TPermission.SetHasAccess(const Value: Boolean);
begin
  FHasAccess := Value;
end;

{ TPermsissionMapper }

constructor TPermsissionMapper.Create;
var
  ClassAttr : IAttributeMap;
begin
  inherited;

  ClassAttr := TAttributeMap.Create('ApplicationRoleID');
  ClassAttr.ColumnMap.Name := 'application_role_id';
  ClassAttr.ColumnMap.ColumnType := ktPrimary;
  ClassAttr.ColumnMap.TableMap.Name := 'APPLICATION_PERMISSION';
  AttributeMaps.Add('ApplicationRoleID', ClassAttr);


  ClassAttr := TAttributeMap.Create('ApplicationResourceID');
  ClassAttr.ColumnMap.Name := 'application_resource_id';
  //ClassAttr.ColumnMap.ColumnType := ktPrimary;
  ClassAttr.ColumnMap.TableMap.Name := 'APPLICATION_PERMISSION';
  AttributeMaps.Add('ApplicationResourceID', ClassAttr);

  ClassAttr := TAttributeMap.Create('HasAccess');
  ClassAttr.ColumnMap.Name := 'has_access';
  ClassAttr.ColumnMap.TableMap.Name := 'APPLICATION_PERMISSION';
  AttributeMaps.Add('HasAccess', ClassAttr);

  ClassAttr := TAttributeMap.Create('Grantor');
  ClassAttr.ColumnMap.Name := 'grantor';
  ClassAttr.ColumnMap.TableMap.Name := 'APPLICATION_PERMISSION';
  AttributeMaps.Add('Grantor', ClassAttr);

  ClassAttr := TAttributeMap.Create('ClientResourceID');
  ClassAttr.ColumnMap.Name := 'application_resource_id';
  ClassAttr.ColumnMap.ColumnType := ktForeign;
  ClassAttr.ColumnMap.TableMap.Name := 'APPLICATION_RESOURCE';
  AttributeMaps.Add('ClientResourceID', ClassAttr);

  ClassAttr := TAttributeMap.Create('ParentResourceID');
  ClassAttr.ColumnMap.Name := 'parent_resource_id';
  ClassAttr.ColumnMap.TableMap.Name := 'APPLICATION_RESOURCE';
  AttributeMaps.Add('ParentResourceID', ClassAttr);

  ClassAttr := TAttributeMap.Create('ResourceName');
  ClassAttr.ColumnMap.Name := 'resource_name';
  ClassAttr.ColumnMap.TableMap.Name := 'APPLICATION_RESOURCE';
  AttributeMaps.Add('ResourceName', ClassAttr);
end;

initialization
  RegisterClasses([TRole, TPermission]);
  PersistenceBroker.AddClassMap(TRole.ClassName + '.SQL', TRoleMapper.Create as IClassMap);
  PersistenceBroker.AddClassMap(TRole.ClassName + '.TextFile', TTextFileMapper.Create as IClassMap);
  PersistenceBroker.AddClassMap(TPermission.ClassName + '.SQL', TPermsissionMapper.Create as IClassMap);
  GlobalContainer.RegisterComponent<TRole>.Implements<IRole>(TRole.ClassName);
  GlobalContainer.RegisterComponent<TPermission>.Implements<IPermission>;

end.
