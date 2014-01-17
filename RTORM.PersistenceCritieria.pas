unit RTORM.PersistenceCritieria;

interface

uses
  RTORM.Maps.Attributes, Spring.Collections, RTORM.PersistentObject;

type
  ISelectionCritieria = interface
    ['{E3572CA5-2119-4F0B-A7DD-A1B32DC4DE9B}']
    function GetAttributeName: string;
    procedure SetAttributeName(const Value: string);

    function AsSQLClause(): string;

    property AttributeName : string read GetAttributeName write SetAttributeName;
  end;

  TSelectionCritieria = class(TInterfacedObject, ISelectionCritieria)
  private
    FAttributeName : string;
    FValue : TObject;
    FValueString : string;
    FUseQuotes : Boolean;
    function GetAttributeName: string;
    procedure SetAttributeName(const Value: string);
  public
    constructor Create(AttributeName: string; Value : TObject); overload;
    constructor Create(AttributeName: string; Value : string); overload;
    constructor Create(AttributeName: string; Value : integer); overload;
    constructor Create(AttributeName: string; Value : Currency); overload;
    constructor Create(AttributeName: string; Value : TDateTime); overload;
    constructor Create(AttributeName: string; Value : Boolean); overload;
    function AsSQLClause: string; virtual; abstract;
    property AttributeName : string read GetAttributeName write SetAttributeName;
  end;


  IPersistenceCritieria = interface
    ['{676A9F80-68D2-41D8-AFEB-1D42830A9260}']
    procedure SetAreSubClassesIncluded(const Value: Boolean);
    function GetAreSubClassesIncluded: Boolean;
    function GetObjectClassName: string;
    function GetCritieriaList: IList<ISelectionCritieria>;
    procedure SetCritieriaList(const Value: IList<ISelectionCritieria>);

    function Perform: IList<IPersistentObject>; //overload;
    //function Perform<T>: IList<IPersistentObject>; overload;


    procedure AddOrCritieria;
    procedure AddSelect;

    procedure AddSelectEqualTo(AttributeName : string; Value : string); overload;
    procedure AddSelectEqualTo(AttributeName : string; Value : Integer); overload;
    procedure AddSelectEqualTo(AttributeName : string; Value : Currency); overload;
    procedure AddSelectEqualTo(AttributeName : string; Value : Boolean); overload;
    procedure AddSelectEqualTo(AttributeName : string; Value : TDateTime); overload;


    procedure AddGreaterThan(AttributeName : string; Value : string); overload;
    procedure AddGreaterThan(AttributeName : string; Value : integer); overload;
    procedure AddGreaterThan(AttributeName : string; Value : TDateTime); overload;
    procedure AddGreaterThan(AttributeName : string; Value : Currency); overload;

    procedure AddGreaterThanOrEqualTo(AttributeName : string; Value : string); overload;
    procedure AddGreaterThanOrEqualTo(AttributeName : string; Value : integer); overload;
    procedure AddGreaterThanOrEqualTo(AttributeName : string; Value : TDateTime); overload;
    procedure AddGreaterThanOrEqualTo(AttributeName : string; Value : Currency); overload;

    procedure AddLessThan(AttributeName : string; Value : string); overload;
    procedure AddLessThan(AttributeName : string; Value : integer); overload;
    procedure AddLessThan(AttributeName : string; Value : TDateTime); overload;
    procedure AddLessThan(AttributeName : string; Value : Currency); overload;

    procedure AddLessThanOrEqualTo(AttributeName : string; Value : string); overload;
    procedure AddLessThanOrEqualTo(AttributeName : string; Value : integer); overload;
    procedure AddLessThanOrEqualTo(AttributeName : string; Value : TDateTime); overload;
    procedure AddLessThanOrEqualTo(AttributeName : string; Value : Currency); overload;

    function ToString: string;
    property ObjectClassName : string read GetObjectClassName;
    property AreSubClassesIncluded: Boolean read GetAreSubClassesIncluded write SetAreSubClassesIncluded;
    property CritieriaList : IList<ISelectionCritieria> read GetCritieriaList write SetCritieriaList;
  end;

  TPersistentCritieria = class(TInterfacedObject, IPersistenceCritieria)
  private
    //FClassMap : IClassMap;
    //FAttributeMap : IAttributeMap;
    FCritieriaList : IList<ISelectionCritieria>;
    FAreSubClassesIncluded : boolean;
    FObjectClassName: string;
    function GetAreSubClassesIncluded: Boolean;
    procedure SetAreSubClassesIncluded(const Value: Boolean);
    function GetObjectClassName: string;

    function GenerateWhereClause: string;
    function GetCritieriaList: IList<ISelectionCritieria>;
    procedure SetCritieriaList(const Value: IList<ISelectionCritieria>);
  public
    constructor Create(ObjectClassName : string);
    //constructor Create(ClassMap : IClassMap; AttributeMap : IAttributeMap);
    procedure AddOrCritieria;
    procedure AddSelect;
    function Perform: IList<IPersistentObject>;

    procedure AddSelectEqualTo(AttributeName : string; Value : string); overload;
    procedure AddSelectEqualTo(AttributeName : string; Value : Integer); overload;
    procedure AddSelectEqualTo(AttributeName : string; Value : Currency); overload;
    procedure AddSelectEqualTo(AttributeName : string; Value : Boolean); overload;
    procedure AddSelectEqualTo(AttributeName : string; Value : TDateTime); overload;


    procedure AddGreaterThan(AttributeName : string; Value : string); overload;
    procedure AddGreaterThan(AttributeName : string; Value : integer); overload;
    procedure AddGreaterThan(AttributeName : string; Value : TDateTime); overload;
    procedure AddGreaterThan(AttributeName : string; Value : Currency); overload;

    procedure AddGreaterThanOrEqualTo(AttributeName : string; Value : string); overload;
    procedure AddGreaterThanOrEqualTo(AttributeName : string; Value : integer); overload;
    procedure AddGreaterThanOrEqualTo(AttributeName : string; Value : TDateTime); overload;
    procedure AddGreaterThanOrEqualTo(AttributeName : string; Value : Currency); overload;

    procedure AddLessThan(AttributeName : string; Value : string); overload;
    procedure AddLessThan(AttributeName : string; Value : integer); overload;
    procedure AddLessThan(AttributeName : string; Value : TDateTime); overload;
    procedure AddLessThan(AttributeName : string; Value : Currency); overload;

    procedure AddLessThanOrEqualTo(AttributeName : string; Value : string); overload;
    procedure AddLessThanOrEqualTo(AttributeName : string; Value : integer); overload;
    procedure AddLessThanOrEqualTo(AttributeName : string; Value : TDateTime); overload;
    procedure AddLessThanOrEqualTo(AttributeName : string; Value : Currency); overload;

    function ToString: string; override;
    property ObjectClassName : string read GetObjectClassName;
    property AreSubClassesIncluded: Boolean read GetAreSubClassesIncluded write SetAreSubClassesIncluded;
    property CritieriaList : IList<ISelectionCritieria> read GetCritieriaList write SetCritieriaList;
  end;


  IEqualToCritieria = interface(ISelectionCritieria)
  end;

  TEqualToCritieria = class(TSelectionCritieria, IEqualToCritieria)
  public
    function AsSQLClause: string; override;
  end;

  IGreaterThanCritieria = interface(ISelectionCritieria)
    ['{18ECD740-7E4D-4944-9EBE-9FF6C1C56AB0}']
  end;

  TGreaterThanCritieria = class(TSelectionCritieria, IGreaterThanCritieria)
  public
    function AsSQLClause: string; override;
  end;

  ILessThanCritieria = interface(ISelectionCritieria)
    ['{EB6915CD-7202-4997-9ECB-A567786601B0}']
  end;

  TLessThanCritieria = class(TSelectionCritieria, ILessThanCritieria)
  public
    function AsSQLClause: string; override;
  end;


  IGreaterThanOrEqualToCritieria = interface(ISelectionCritieria)
    ['{8D98F462-9B41-45B2-BD62-E32F8847E2B9}']
  end;

  TGreaterThanEqualToCritieria = class(TSelectionCritieria, IGreaterThanOrEqualToCritieria)
  public
    function AsSQLClause: string; override;
  end;

  ILessThanOrEqualToCritieria = interface(ISelectionCritieria)
    ['{4975CD03-CFB4-46E3-9872-2AB72A1C2795}']
  end;

  TLessThanOrEqualToCritieria = class(TSelectionCritieria, ILessThanOrEqualToCritieria)
  public
    function AsSQLClause: string; override;
  end;


  IRetrieveCritieria = interface(IPersistenceCritieria)
    ['{88AB714B-13DE-4CE5-8644-B427E8A907AE}']
    //function AsCursor: IList;
    //function AsRecords: IRecord;
    function AsProxies : IList<IPersistentObject>;
    function AsObjects: IList<IPersistentObject>;
  end;

  TRetrieveCritieria = class(TPersistentCritieria, IRetrieveCritieria)
  private
    function AsCursor: IList;
  public
    //function AsCursor: IList;
    function AsObjects: IList<IPersistentObject>;
    function AsProxies : IList<IPersistentObject>;
  end;

implementation

uses
  CodeSiteLogging, SysUtils, RTORM.Broker;

{ TPersistentCritieria }

procedure TPersistentCritieria.AddGreaterThan(AttributeName, Value: string);
begin
  FCritieriaList.Add(TGreaterThanCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddGreaterThan(AttributeName: string; Value: integer);
begin
  FCritieriaList.Add(TGreaterThanCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddGreaterThan(AttributeName: string; Value: TDateTime);
begin
  FCritieriaList.Add(TGreaterThanCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddGreaterThan(AttributeName: string; Value: Currency);
begin
  FCritieriaList.Add(TGreaterThanCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddGreaterThanOrEqualTo(AttributeName: string; Value: integer);
begin
  FCritieriaList.Add(TGreaterThanEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddGreaterThanOrEqualTo(AttributeName, Value: string);
begin
  FCritieriaList.Add(TGreaterThanEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddGreaterThanOrEqualTo(AttributeName: string; Value: Currency);
begin
  FCritieriaList.Add(TGreaterThanEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddGreaterThanOrEqualTo(AttributeName: string; Value: TDateTime);
begin
  FCritieriaList.Add(TGreaterThanEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddLessThan(AttributeName: string; Value: integer);
begin
  FCritieriaList.Add(TLessThanCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddLessThan(AttributeName, Value: string);
begin
  FCritieriaList.Add(TLessThanCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddLessThan(AttributeName: string; Value: Currency);
begin
  FCritieriaList.Add(TLessThanCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddLessThanOrEqualTo(AttributeName: string; Value: integer);
begin
  FCritieriaList.Add(TLessThanOrEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddLessThanOrEqualTo(AttributeName, Value: string);
begin
  FCritieriaList.Add(TLessThanOrEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddLessThanOrEqualTo(AttributeName: string; Value: Currency);
begin
  FCritieriaList.Add(TLessThanOrEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddLessThanOrEqualTo(AttributeName: string; Value: TDateTime);
begin
  FCritieriaList.Add(TLessThanOrEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddLessThan(AttributeName: string; Value: TDateTime);
begin
  FCritieriaList.Add(TLessThanCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddOrCritieria;
begin
  CodeSite.EnterMethod(Self, 'AddOrCritieria');

  CodeSite.ExitMethod(Self, 'AddOrCritieria');
end;

procedure TPersistentCritieria.AddSelect;
begin
  CodeSite.EnterMethod(Self, 'AddSelect');
  CodeSite.ExitMethod(Self, 'AddSelect');
end;

procedure TPersistentCritieria.AddSelectEqualTo(AttributeName: string; Value: Currency);
begin
  FCritieriaList.Add(TEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddSelectEqualTo(AttributeName: string; Value: Boolean);
begin
  FCritieriaList.Add(TEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddSelectEqualTo(AttributeName: string; Value: TDateTime);
begin
  FCritieriaList.Add(TEqualToCritieria.Create(AttributeName, Value));
end;

procedure TPersistentCritieria.AddSelectEqualTo(AttributeName: string; Value: Integer);
begin
  CodeSite.EnterMethod(Self, 'AddSelectEqualTo');
  FCritieriaList.Add(TEqualToCritieria.Create(AttributeName, Value));
  CodeSite.ExitMethod(Self, 'AddSelectEqualTo');
end;

procedure TPersistentCritieria.AddSelectEqualTo(AttributeName, Value: string);
begin
  CodeSite.EnterMethod(Self, 'AddSelectEqualTo');
  FCritieriaList.Add(TEqualToCritieria.Create(AttributeName, Value));
  CodeSite.ExitMethod(Self, 'AddSelectEqualTo');
end;

constructor TPersistentCritieria.Create(ObjectClassName : string);
begin
  CodeSite.EnterMethod(Self, 'Create');
  FObjectClassName := ObjectClassName;
  FCritieriaList := TCollections.CreateList<ISelectionCritieria>;
  CodeSite.ExitMethod(Self, 'Create');
end;

{constructor TPersistentCritieria.Create(ClassMap: IClassMap; AttributeMap: IAttributeMap);
begin
  FClassMap := ClassMap;
  FAttributeMap := AttributeMap;
end;}

function TPersistentCritieria.GenerateWhereClause: string;
begin

end;

function TPersistentCritieria.GetAreSubClassesIncluded: Boolean;
begin
  result := FAreSubClassesIncluded;
end;

function TPersistentCritieria.GetCritieriaList: IList<ISelectionCritieria>;
begin
  result := FCritieriaList;
end;

function TPersistentCritieria.GetObjectClassName: string;
begin
  result := FObjectClassName;
end;

function TPersistentCritieria.Perform: IList<IPersistentObject>;
begin
  result := PersistenceBroker.ProcessCritieria(Self);
end;

procedure TPersistentCritieria.SetAreSubClassesIncluded(const Value: Boolean);
begin
  FAreSubClassesIncluded := Value;
end;

procedure TPersistentCritieria.SetCritieriaList(const Value: IList<ISelectionCritieria>);
begin
  FCritieriaList := Value;
end;

function TPersistentCritieria.ToString: string;
var
  aCritieria: ISelectionCritieria;
begin
  for aCritieria in FCritieriaList do
  begin
    if result = '' then
      result := aCritieria.AsSQLClause
    else
      result := Format('%s AND %s', [result, aCritieria.AsSQLClause]);
  end;
end;

{ TSelectionCritieria }

constructor TSelectionCritieria.Create(AttributeName: string; Value : TObject);
begin
  FAttributeName := AttributeName;
  FValue := Value;
end;

constructor TSelectionCritieria.Create(AttributeName: string; Value: integer);
begin
  FAttributeName := AttributeName;
  FValueString := IntToStr(Value);
  FUseQuotes := False;
end;

constructor TSelectionCritieria.Create(AttributeName, Value: string);
begin
  FAttributeName := AttributeName;
  FValueString := Value;
  FUseQuotes := True;
end;

constructor TSelectionCritieria.Create(AttributeName: string; Value: Currency);
begin
  FAttributeName := AttributeName;
  FValueString := CurrToStr(Value);
  FUseQuotes := False;
end;

constructor TSelectionCritieria.Create(AttributeName: string; Value: Boolean);
begin
  FAttributeName := AttributeName;
  FValueString := BoolToStr(Value, True);
  FUseQuotes := True;
end;

function TSelectionCritieria.GetAttributeName: string;
begin
  result := FAttributeName;
end;

procedure TSelectionCritieria.SetAttributeName(const Value: string);
begin
  FAttributeName := Value;
end;

constructor TSelectionCritieria.Create(AttributeName: string; Value: TDateTime);
begin
  FAttributeName := AttributeName;
  FValueString := DateTimeToStr(Value);
  FUseQuotes := True;
end;

{ TEqualToCritieria }

function TEqualToCritieria.AsSQLClause: string;
begin
  CodeSite.EnterMethod( Self, 'AsSQLClause' );
  if FUseQuotes then
    result := Format(' = %s', [QuotedStr(FValueString)])
  else
    result := Format(' = %s', [FValueString]);
  CodeSite.ExitMethod( Self, 'AsSQLClause', result);
end;

function TRetrieveCritieria.AsCursor: IList;
begin
end;

function TRetrieveCritieria.AsObjects: IList<IPersistentObject>;
begin

end;

function TRetrieveCritieria.AsProxies: IList<IPersistentObject>;
begin

end;

{ TGreaterThanCritieria }

function TGreaterThanCritieria.AsSQLClause: string;
begin
  CodeSite.EnterMethod( Self, 'AsSQLClause' );
  if FUseQuotes then
    result := Format(' > %s', [QuotedStr(FValueString)])
  else
    result := Format(' > %s', [FValueString]);
  CodeSite.ExitMethod( Self, 'AsSQLClause', result);
end;

{ TLessThanCritieria }

function TLessThanCritieria.AsSQLClause: string;
begin
  CodeSite.EnterMethod( Self, 'AsSQLClause' );
  if FUseQuotes then
    result := Format(' < %s', [QuotedStr(FValueString)])
  else
    result := Format(' < %s', [FValueString]);
  CodeSite.ExitMethod( Self, 'AsSQLClause', result);
end;

{ TGreaterThanEqualToCritieria }

function TGreaterThanEqualToCritieria.AsSQLClause: string;
begin
  CodeSite.EnterMethod( Self, 'AsSQLClause' );
  if FUseQuotes then
    result := Format(' >= %s', [QuotedStr(FValueString)])
  else
    result := Format(' >= %s', [FValueString]);
  CodeSite.ExitMethod( Self, 'AsSQLClause', result);
end;

{ TLessThanOrEqualToCritieria }

function TLessThanOrEqualToCritieria.AsSQLClause: string;
begin
  CodeSite.EnterMethod( Self, 'AsSQLClause' );
  if FUseQuotes then
    result := Format(' <= %s', [QuotedStr(FValueString)])
  else
    result := Format(' <= %s', [FValueString]);
  CodeSite.ExitMethod( Self, 'AsSQLClause', result);
end;

end.
