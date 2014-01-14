unit RTORM.Maps.Attributes;

interface

uses
  Spring.Collections, Data.DB;

type
  TKeyType = (ktNone, ktPrimary, ktForeign);

  ITableMap = interface
    ['{4EB1C3A1-1F76-48EB-85CE-98256A352C6E}']
    function GetName: string;
    procedure SetName(const Value: string);

    function FullyQualifiedName: string;
    property Name : string read GetName write SetName;
  end;

  TTableMap = class(TInterfacedObject, ITableMap)
  private
    FName : string;
    function GetName: string;
    procedure SetName(const Value: string);
  public
    function FullyQualifiedName: string;
    property Name : string read GetName write SetName;
  end;

  IColumnMap = interface
    ['{70E65C46-CB8C-484E-9AFF-31ABA0A44703}']
    procedure SetColumnType(const Value: TKeyType);
    function GetColumnType: TKeyType;
    function GetIsKeyColumn: Boolean;
    procedure SetName(const Value: string);
    function GetName: string;
    function GetTableMap: ITableMap;
    function FullyQualifiedName: string;
    property Name: string read GetName write SetName;
    property IsKeyColumn: Boolean read GetIsKeyColumn;
    property ColumnType: TKeyType read GetColumnType write SetColumnType;
    property TableMap: ITableMap read GetTableMap;
  end;

  TColumnMap = class(TInterfacedObject, IColumnMap)
  private
    FColumnType : TKeyType;
    FName : string;
    FTableMap : ITableMap;
    function GetColumnType: TKeyType;
    function GetIsKeyColumn: Boolean;
    function GetName: string;
    procedure SetColumnType(const Value: TKeyType);
    procedure SetName(const Value: string);
    function GetTableMap: ITableMap;
  public
    constructor Create; overload;
    constructor Create(aName: string; aColumnType : TKeyType); overload;
    function FullyQualifiedName: string;
    property Name: string read GetName write SetName;
    property IsKeyColumn: Boolean read GetIsKeyColumn;
    property ColumnType: TKeyType read GetColumnType write SetColumnType;
    property TableMap: ITableMap read GetTableMap;
  end;


  IAttributeMap = interface
    ['{51699FA9-9373-4BFF-8CC6-5770F18731D7}']
    procedure SetIsOptimistCheckAttribute(const Value: boolean);
    function GetIsOptimistCheckAttribute: boolean;
    procedure SetIsProxy(const Value: boolean);
    function GetIsProxy: boolean;
    procedure SetName(const Value: string);
    function GetName: string;
    function GetColumnMap: IColumnMap;

    property Name: string read GetName write SetName;
    property IsOptimistCheckAttribute: boolean read GetIsOptimistCheckAttribute write SetIsOptimistCheckAttribute;
    property IsProxy: boolean read GetIsProxy write SetIsProxy;
    property ColumnMap : IColumnMap read GetColumnMap;
  end;

  TAttributeMap = class(TInterfacedObject, IAttributeMap)
  private
    FColumnMap : IColumnMap;
    FName : string;
    FIsOptimistCheckAttribute : Boolean;
    FIsProxy : Boolean;

    function GetIsOptimistCheckAttribute: boolean;
    function GetIsProxy: boolean;
    function GetName: string;
    procedure SetIsOptimistCheckAttribute(const Value: boolean);
    procedure SetIsProxy(const Value: boolean);
    procedure SetName(const Value: string);
    function GetColumnMap: IColumnMap;
  public
    constructor Create(aName : string);
    property Name: string read GetName write SetName;
    property IsOptimistCheckAttribute: boolean read GetIsOptimistCheckAttribute write SetIsOptimistCheckAttribute;
    property IsProxy: boolean read GetIsProxy write SetIsProxy;
    property ColumnMap : IColumnMap read GetColumnMap;
  end;

  IStoredProcedureParam = interface
    ['{B291F0BC-379F-44CE-9A4B-0CF1048E7D6F}']
    function GetName: string;
    function GetParamType: TFieldType;
    procedure SetName(const Value: string);
    procedure SetParamType(const Value: TFieldType);

    property Name : string read GetName write SetName;
    property ParamType : TFieldType read GetParamType write SetParamType;
  end;

  TStoredProcedureParam = class(TInterfacedObject, IStoredProcedureParam)
  private
    FName : string;
    FParamType : TFieldType;
    function GetName: string;
    function GetParamType: TFieldType;
    procedure SetName(const Value: string);
    procedure SetParamType(const Value: TFieldType);
  public
    property Name : string read GetName write SetName;
    property ParamType : TFieldType read GetParamType write SetParamType;
  end;

  IStoredProcedureMap = interface
    ['{65796950-DDA9-4CEF-A01B-AA3F098E56D4}']
    function GetStoredProcedureName: string;
    procedure SetStoredProcedureName(const Value: string);
    function GetParams: IDictionary<string, IStoredProcedureParam>;
    property StoredProcedureName : string read GetStoredProcedureName write SetStoredProcedureName;
    property Params : IDictionary<string, IStoredProcedureParam> read GetParams;
  end;

  TStoredProcedureMap = class(TInterfacedObject, IStoredProcedureMap)
  private
    FStoredProcedureName : string;
    FParams : IDictionary<string, IStoredProcedureParam>;
    function GetStoredProcedureName: string;
    procedure SetStoredProcedureName(const Value: string);
    function GetParams: IDictionary<string, IStoredProcedureParam>;
  public
    property StoredProcedureName : string read GetStoredProcedureName write SetStoredProcedureName;
    property Params : IDictionary<string, IStoredProcedureParam> read GetParams;
  end;

implementation

uses
  SysUtils;

{ TAttributeMap }

constructor TAttributeMap.Create(aName : string);
begin
  FName := aName;
  FColumnMap := TColumnMap.Create;
  FIsOptimistCheckAttribute := False;
  FIsProxy := False;
end;

function TAttributeMap.GetColumnMap: IColumnMap;
begin
  result := FColumnMap;
end;

function TAttributeMap.GetIsOptimistCheckAttribute: boolean;
begin
  result := FIsOptimistCheckAttribute;
end;

function TAttributeMap.GetIsProxy: boolean;
begin
  result := FIsProxy;
end;

function TAttributeMap.GetName: string;
begin
  result := FName;
end;

procedure TAttributeMap.SetIsOptimistCheckAttribute(const Value: boolean);
begin
  FIsOptimistCheckAttribute := Value;
end;

procedure TAttributeMap.SetIsProxy(const Value: boolean);
begin
  FIsProxy := Value;
end;

procedure TAttributeMap.SetName(const Value: string);
begin
  FName := Value;
end;

{ TColumnMap }

constructor TColumnMap.Create(aName: string; aColumnType: TKeyType);
begin
  FName := aName;
  FColumnType := aColumnType;
  FTableMap := TTableMap.Create;
end;

function TColumnMap.FullyQualifiedName: string;
begin
  result := Format('%s.%s', [TableMap.Name, Name]);
end;

constructor TColumnMap.Create;
begin
  FName := '';
  FColumnType := ktNone;
  FTableMap := TTableMap.Create;
end;

function TColumnMap.GetColumnType: TKeyType;
begin
  result := FColumnType;
end;

function TColumnMap.GetIsKeyColumn: Boolean;
begin
  result := FColumnType <> ktNone;
end;

function TColumnMap.GetName: string;
begin
  result := FName;
end;

function TColumnMap.GetTableMap: ITableMap;
begin
  result := FTableMap;
end;

procedure TColumnMap.SetColumnType(const Value: TKeyType);
begin
  FColumnType := Value;
end;

procedure TColumnMap.SetName(const Value: string);
begin
  FName := Value;
end;

{ TTableMap }

function TTableMap.FullyQualifiedName: string;
begin
  result := Format('dbo.%s', [FName]);
end;

function TTableMap.GetName: string;
begin
  result := FName;
end;

procedure TTableMap.SetName(const Value: string);
begin
  FName := Value;
end;

{ TStoredProcedureMap }

function TStoredProcedureMap.GetParams: IDictionary<string, IStoredProcedureParam>;
begin
  result := FParams;
end;

function TStoredProcedureMap.GetStoredProcedureName: string;
begin
  result := FStoredProcedureName;
end;

procedure TStoredProcedureMap.SetStoredProcedureName(const Value: string);
begin
  FStoredProcedureName := Value;
end;

{ TStoredProcedureParam }

function TStoredProcedureParam.GetName: string;
begin
  result := FName;
end;

function TStoredProcedureParam.GetParamType: TFieldType;
begin
  result := FParamType;
end;

procedure TStoredProcedureParam.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TStoredProcedureParam.SetParamType(const Value: TFieldType);
begin
  FParamType := Value;
end;

end.
