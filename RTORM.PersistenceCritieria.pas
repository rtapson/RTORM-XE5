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

    function ToString: string;
    property ObjectClassName : string read GetObjectClassName;
    property AreSubClassesIncluded: Boolean read GetAreSubClassesIncluded write SetAreSubClassesIncluded;
    property CritieriaList : IList<ISelectionCritieria> read GetCritieriaList write SetCritieriaList;
  end;

  TPersistentCritieria = class(TInterfacedObject, IPersistenceCritieria)
  private
    //FClassMap : IClassMap;
    //FAttributeMap : IAttributeMap;
    FPersistentObject : string;
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
  FPersistentObject := ObjectClassName;
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
  result := FPersistentObject;
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
  if FUseQuotes then
    result := Format('%s = %s', [AttributeName, QuotedStr(FValueString)])
  else
    result := Format('%s = %s', [AttributeName, FValueString]);
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

end.
