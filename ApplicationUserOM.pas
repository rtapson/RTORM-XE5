unit ApplicationUserOM;

interface

uses
  rtorm.PersistentObject, RTORM.Maps;

type
  IAppplicationUser = interface(IPersistentObject)
    ['{5B30B445-7D61-473F-B2B8-D723F550D66A}']
    function GetApplicationLoginId: string;
    function GetCompanyNumber: string;
    function GetADPEmployeeId: string;
    procedure SetADPEmployeeId(const value: string);

    function GetEmailAddress: string;
    procedure SetEmailAddress(const value: string);
    property EmailAddress: string read GetEmailAddress write SetEmailAddress;
    property ADPEmployeeId: string read GetADPEmployeeId write SetADPEmployeeId;
    property CompanyNumber: string read GetCompanyNumber;
    property ApplicationLoginId: string read GetApplicationLoginId;
  end;

  TApplicationUser = class(TPersistentObject, IAppplicationUser)
  private
    FApplicationLoginId : string;
    FCompanyNumber : string;
    FADPEmployeeId : string;
    FEmailAddress : string;

    function GetApplicationLoginId: string;
    function GetCompanyNumber: string;
    function GetADPEmployeeId: string;
    procedure SetADPEmployeeId(const value: string);
    function GetEmailAddress: string;
    procedure SetEmailAddress(const value: string);
  public
    constructor Create(const ApplicationLoginId, CompanyNumber : string); overload;
    constructor Create(const ApplicationLoginId, ADPEmployeeId, CompanyNumber : string); overload;

    property EmailAddress: string read GetEmailAddress write SetEmailAddress;
    property ADPEmployeeId: string read GetADPEmployeeId write SetADPEmployeeId;
    property CompanyNumber: string read GetCompanyNumber;
    property ApplicationLoginId: string read GetApplicationLoginId;
  end;

  IApplicationUserMapper = interface(IClassMap)
    ['{FC3065F1-56AC-4E82-B7C2-A497ED8107BC}']
  end;

  TApplicationMapperMapper = class(TRelationalDatabaseMapper, IApplicationUserMapper)
  public
    constructor Create; override;
  end;


implementation

uses
  System.Classes, RTORM.Maps.Attributes, RTORM.Broker, Spring.Container;

{ TApplicationUser }

constructor TApplicationUser.Create(const ApplicationLoginId,
  ADPEmployeeId, CompanyNumber: string);
begin
  FApplicationLoginId := ApplicationLoginId;
  FADPEmployeeId := ADPEmployeeId;
  FCompanyNumber := CompanyNumber;
end;

constructor TApplicationUser.Create(const ApplicationLoginId,
  CompanyNumber: string);
begin
  FApplicationLoginId := ApplicationLoginId;
  FCompanyNumber := CompanyNumber;
end;

function TApplicationUser.GetADPEmployeeId: string;
begin
  result := FADPEmployeeId;
end;

function TApplicationUser.GetApplicationLoginId: string;
begin
  result := FApplicationLoginId;
end;

function TApplicationUser.GetCompanyNumber: string;
begin
  result := FCompanyNumber;
end;

function TApplicationUser.GetEmailAddress: string;
begin
  result := FEmailAddress;
end;

procedure TApplicationUser.SetADPEmployeeId(const value: string);
begin
  FADPEmployeeId := Value;
end;

procedure TApplicationUser.SetEmailAddress(const value: string);
begin
  FEmailAddress := Value;
end;

{ TApplicationMapperMapper }

constructor TApplicationMapperMapper.Create;
var
  ID, ADP, CompanyNumber, EmailAddress : IAttributeMap;
begin
  inherited;

  ID := TAttributeMap.Create('ApplicationLoginId');
  ID.ColumnMap.Name := 'application_login_id';
  ID.ColumnMap.ColumnType := ktPrimary;
  ID.ColumnMap.TableMap.Name := 'APPLICATION_USER';
  AttributeMaps.Add('ApplicationLoginId', ID);

  ADP := TAttributeMap.Create('ADPEmployeeId');
  ADP.ColumnMap.Name := 'adp_employee_id';
  ADP.ColumnMap.TableMap.Name := 'APPLICATION_USER';
  AttributeMaps.Add('ADPEmployeeId', ADP);

  CompanyNumber := TAttributeMap.Create('CompanyNumber');
  CompanyNumber.ColumnMap.Name := 'company_number';
  CompanyNumber.ColumnMap.ColumnType := ktPrimary;
  CompanyNumber.ColumnMap.TableMap.Name := 'APPLICATION_USER';
  AttributeMaps.Add('CompanyNumber', CompanyNumber);

  EmailAddress := TAttributeMap.Create('EmailAddress');
  EmailAddress.ColumnMap.Name := 'email_address';
  EmailAddress.ColumnMap.TableMap.Name := 'APPLICATION_USER';
  AttributeMaps.Add('EmailAddress', EmailAddress);
end;

initialization
  RegisterClasses([TApplicationUser]);
  PersistenceBroker.AddClassMap(TApplicationUser.ClassName + '.SQL', TApplicationMapperMapper.Create as IClassMap);
  GlobalContainer.RegisterComponent<TApplicationUser>.Implements<IAppplicationUser>(TApplicationUser.ClassName);


end.
