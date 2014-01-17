unit ApplicationUserOM;

interface

uses
  rtorm.PersistentObject, RTORM.Maps;

type
  IApplicationUser = interface(IPersistentObject)
    ['{5B30B445-7D61-473F-B2B8-D723F550D66A}']
    function GetApplicationLoginId: string;
    function GetCompanyNumber: string;
    function GetADPEmployeeId: string;
    function GetEmailAddress: string;
    procedure SetADPEmployeeId(const value: string);
    procedure SetEmailAddress(const value: string);
    function GetLastLoginDate: TDateTime;

    property LastLoginDate: TDateTime read GetLastLoginDate;
    property EmailAddress: string read GetEmailAddress write SetEmailAddress;
    property ADPEmployeeId: string read GetADPEmployeeId write SetADPEmployeeId;
    property CompanyNumber: string read GetCompanyNumber;
    property ApplicationLoginId: string read GetApplicationLoginId;
  end;

  TApplicationUser = class(TPersistentObject, IApplicationUser)
  private
    FApplicationLoginId : string;
    FCompanyNumber : string;
    FADPEmployeeId : string;
    FEmailAddress : string;
    FLastLoginDate : TDateTime;

    function GetApplicationLoginId: string;
    function GetCompanyNumber: string;
    function GetADPEmployeeId: string;
    procedure SetADPEmployeeId(const value: string);
    function GetEmailAddress: string;
    procedure SetEmailAddress(const value: string);
    function GetLastLoginDate: TDateTime;
  public
    constructor Create(const ApplicationLoginId, CompanyNumber : string); overload;
    constructor Create(const ApplicationLoginId, ADPEmployeeId, CompanyNumber : string); overload;

    property LastLoginDate: TDateTime read GetLastLoginDate;
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
  System.Classes, RTORM.Maps.Attributes{, RTORM.Broker}, Spring.Container;

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

function TApplicationUser.GetLastLoginDate: TDateTime;
begin
  result := FLastLoginDate;
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
  ID, ADP, CompanyNumber, EmailAddress, LastLoginDate : IAttributeMap;
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

  LastLoginDate := TAttributeMap.Create('LastLoginDate');
  LastLoginDate.ColumnMap.Name := 'last_login_date';
  LastLoginDate.ColumnMap.TableMap.Name := 'APPLICATION_USER';
  AttributeMaps.Add('LastLoginDate', LastLoginDate);
end;

initialization
  RegisterClasses([TApplicationUser]);
//  PersistenceBroker.AddClassMap(TApplicationUser.ClassName + '.SQL', TApplicationMapperMapper.Create as IClassMap);
  GlobalContainer.RegisterType<TApplicationUser>.Implements<IPersistentObject>(TApplicationUser.ClassName);

end.
