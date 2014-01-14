unit RTORM.UniDirectionalAssociationMap;

interface

uses
 RTORM.Maps.Attributes, Spring.Collections;

type
  TCardinality = (cnOneToOne, cnOnetoMany);

  IUniDirectionalAssociationMap = interface
    function GetCardinality: TCardinality;
    function GetIsDeleteAutomatic: Boolean;
    function GetIsMust: boolean;
    function GetIsRetrieveAutomatic: Boolean;
    function GetIsSaveAutomatic: Boolean;
    procedure SetCardinality(const Value: TCardinality);
    procedure SetIsDeleteAutomatic(const Value: Boolean);
    procedure SetIsMust(const Value: boolean);
    procedure SetIsRetrieveAutomatic(const Value: Boolean);
    procedure SetIsSaveAutomatic(const Value: Boolean);
    function GetTargetName: string;
    procedure SetTargetName(const Value: string);
    function GetTargetClassName: string;
    procedure SetTargetClassName(const Value: string);
    function GetParams: IDictionary<string, IAttributeMap>;

    procedure AddParam(AttributeMap : IAttributeMap; TargetAtrributeName : string);

    property TargetName : string read GetTargetName write SetTargetName;
    property TargetClassName : string read GetTargetClassName write SetTargetClassName;
    property Params : IDictionary<string, IAttributeMap> read GetParams;

    property Cardinality: TCardinality read GetCardinality write SetCardinality;
    property IsRetrieveAutomatic: Boolean read GetIsRetrieveAutomatic write SetIsRetrieveAutomatic;
    property IsDeleteAutomatic: Boolean read GetIsDeleteAutomatic write SetIsDeleteAutomatic;
    property IsSaveAutomatic: Boolean read GetIsSaveAutomatic write SetIsSaveAutomatic;
    property IsMust: boolean read GetIsMust write SetIsMust;
  end;

  TUniDirectionalAssociationMap = class(TInterfacedObject, IUniDirectionalAssociationMap)
  private
    FCardinality : TCardinality;
    FisDeleteAutomatic : Boolean;
    FIsMust : Boolean;
    FIsRetrieveAutomatic: Boolean;
    FIsSaveAutomatic : Boolean;
    FTargetName : string;
    FTargetClassName : string;
    FParams : IDictionary<string, IAttributeMap>;

    function GetCardinality: TCardinality;
    function GetIsDeleteAutomatic: Boolean;
    function GetIsMust: boolean;
    function GetIsRetrieveAutomatic: Boolean;
    function GetIsSaveAutomatic: Boolean;
    procedure SetCardinality(const Value: TCardinality);
    procedure SetIsDeleteAutomatic(const Value: Boolean);
    procedure SetIsMust(const Value: boolean);
    procedure SetIsRetrieveAutomatic(const Value: Boolean);
    procedure SetIsSaveAutomatic(const Value: Boolean);
    function GetTargetName: string;
    procedure SetTargetName(const Value: string);
    function GetTargetClassName: string;
    procedure SetTargetClassName(const Value: string);
    function GetParams: IDictionary<string, IAttributeMap>;
  public
    constructor Create;
    procedure AddParam(AttributeMap : IAttributeMap; TargetAtrributeName : string);

    property TargetName : string read GetTargetName write SetTargetName;
    property TargetClassName : string read GetTargetClassName write SetTargetClassName;
    property Params : IDictionary<string, IAttributeMap> read GetParams;

    property Cardinality: TCardinality read GetCardinality write SetCardinality;
    property IsRetrieveAutomatic: Boolean read GetIsRetrieveAutomatic write SetIsRetrieveAutomatic;
    property IsDeleteAutomatic: Boolean read GetIsDeleteAutomatic write SetIsDeleteAutomatic;
    property IsSaveAutomatic: Boolean read GetIsSaveAutomatic write SetIsSaveAutomatic;
    property IsMust: boolean read GetIsMust write SetIsMust;
  end;

implementation

{ TUniDirectionalAssociationMap }

procedure TUniDirectionalAssociationMap.AddParam(AttributeMap: IAttributeMap; TargetAtrributeName : string);
begin
  FParams.Add(TargetAtrributeName, AttributeMap);
end;

constructor TUniDirectionalAssociationMap.Create;
begin
  FParams := TCollections.CreateDictionary<string, IAttributeMap>;
end;

function TUniDirectionalAssociationMap.GetCardinality: TCardinality;
begin
  result := FCardinality;
end;

function TUniDirectionalAssociationMap.GetIsDeleteAutomatic: Boolean;
begin
  result := FisDeleteAutomatic;
end;

function TUniDirectionalAssociationMap.GetIsMust: boolean;
begin
  result := FIsMust;
end;

function TUniDirectionalAssociationMap.GetIsRetrieveAutomatic: Boolean;
begin
  result := FIsRetrieveAutomatic;
end;

function TUniDirectionalAssociationMap.GetIsSaveAutomatic: Boolean;
begin
  result := FIsSaveAutomatic;
end;

function TUniDirectionalAssociationMap.GetParams: IDictionary<string, IAttributeMap>;
begin
  result := FParams;
end;

function TUniDirectionalAssociationMap.GetTargetClassName: string;
begin
  result := FTargetClassName;
end;

function TUniDirectionalAssociationMap.GetTargetName: string;
begin
  result := FTargetName;
end;

procedure TUniDirectionalAssociationMap.SetCardinality(const Value: TCardinality);
begin
  FCardinality := Value;
end;

procedure TUniDirectionalAssociationMap.SetIsDeleteAutomatic(const Value: Boolean);
begin
  FisDeleteAutomatic := Value;
end;

procedure TUniDirectionalAssociationMap.SetIsMust(const Value: boolean);
begin
  FIsMust := Value;
end;

procedure TUniDirectionalAssociationMap.SetIsRetrieveAutomatic(const Value: Boolean);
begin
  FIsRetrieveAutomatic := Value;
end;

procedure TUniDirectionalAssociationMap.SetIsSaveAutomatic(const Value: Boolean);
begin
  FIsSaveAutomatic := Value;
end;

procedure TUniDirectionalAssociationMap.SetTargetClassName(const Value: string);
begin
  FTargetClassName := Value;
end;

procedure TUniDirectionalAssociationMap.SetTargetName(const Value: string);
begin
  FTargetName := Value;
end;

end.
