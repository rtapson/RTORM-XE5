unit RTORM.Broker;

interface

uses
  RTORM.persistencemechanism, RTORM.persistentobject, Spring,
  Spring.Collections, RTORM.Maps, RTORM.PersistenceCritieria;

type
  IPersistenceBroker = interface
  ['{BC6DA0BF-DA99-4C6B-856D-4BF36A9F8508}']
    //procedure RetrieveClassMaps;
    procedure DisconnectFrom(aPersistenceMechanism : IPersistenceMechanism);
    procedure ConnectTo(aPersistenceMechanism : IPersistenceMechanism);
    procedure ProcessSql;
    procedure ProcessTransaction;
    function ProcessCritieria(CritieriaObject : IPersistenceCritieria): IList<IPersistentObject>;
    procedure RetrieveObject(aObj : IPersistentObject); overload;
    procedure RetrieveObject(aObj : IPersistentObject; DataStore : string); overload;
    procedure DeleteObject(aObj : IPersistentObject); overload;
    procedure DeleteObject(aObj : IPersistentObject; DataStore : string); overload;
    procedure SaveObject(aObj : IPersistentObject); overload;
    procedure SaveObject(aObj : IPersistentObject; DataStore : string); overload;
    procedure SetDatabase(const Value: string);
    function GetDatabase: string;

    function GetDataStores: IDictionary<string, IPersistenceMechanism>;

    procedure AddClassMap(TypeName : string; ClassMap : IClassMap);
    procedure AddPersistenceMechansim(Name : string; PersistenceMechanism : IPersistenceMechanism);
    property DataStore : string read GetDatabase write SetDatabase;
    property DataStores : IDictionary<string, IPersistenceMechanism> read GetDataStores;
  end;

function PersistenceBroker: IPersistenceBroker;

implementation

uses
  SysUtils, Spring.Services, Spring.Container;

type
  TPersistenceBroker = class(TInterfacedObject, IPersistenceBroker)
  private
    FDataStoreName : string;
    FMechanisms : IDictionary<string, IPersistenceMechanism>;
    FClassMaps :  IDictionary<string, IClassMap>;
    procedure ConnectTo(aPersistenceMechanism : IPersistenceMechanism);
    procedure DisconnectFrom(aPersistenceMechanism : IPersistenceMechanism);
    procedure DeleteObjectFromStorage(aObj : IPersistentObject; ClassMap : IClassMap; PersistenceMechanism : IPersistenceMechanism);
    procedure RetrieveObjectFromStorage(aObj : IPersistentObject; ClassMap : IClassMap; PersistenceMechanism : IPersistenceMechanism; IsLock :Boolean);
    procedure UpdateObjectFromStorage(aObj : IPersistentObject; ClassMap : IClassMap; PersistenceMechanism : IPersistenceMechanism; IsLock :Boolean);
    function GetDatabase: string;
    function GetMapperForClass(aObj : IPersistentObject): IClassMap; overload;
    function GetMapperForClass(ObjectClassName : string): IClassMap; overload;
    function GetMapperForClass(aObj : IPersistentObject; DataStore : string): IClassMap; overload;
    function GetDataStores: IDictionary<string, IPersistenceMechanism>;
    procedure SetDatabase(const Value: string);
  protected
    //procedure RetrieveClassMaps;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddClassMap(TypeName : string; ClassMap : IClassMap);
    procedure AddPersistenceMechansim(Name : string; PersistenceMechanism : IPersistenceMechanism);

    procedure RetrieveObject(aObj : IPersistentObject); overload;
    procedure RetrieveObject(aObj : IPersistentObject; DataStore : string); overload;
    procedure DeleteObject(aObj : IPersistentObject); overload;
    procedure DeleteObject(aObj : IPersistentObject; DataStore : string); overload;
    procedure SaveObject(aObj : IPersistentObject); overload;
    procedure SaveObject(aObj : IPersistentObject; DataStore : string); overload;

    function ProcessCritieria(CritieriaObject : IPersistenceCritieria): IList<IPersistentObject>;
    procedure ProcessSql;
    procedure ProcessTransaction;


    property DataStore : string read GetDatabase write SetDatabase;
    property DataStores : IDictionary<string, IPersistenceMechanism> read GetDataStores;
  end;


function PersistenceBroker: IPersistenceBroker;
begin
  result := ServiceLocator.GetService<IPersistenceBroker>;
end;

procedure TPersistenceBroker.AddClassMap(TypeName : string; ClassMap: IClassMap);
begin
  FClassMaps.Add(TypeName, ClassMap);
end;

procedure TPersistenceBroker.AddPersistenceMechansim(Name: string; PersistenceMechanism: IPersistenceMechanism);
begin
  FMechanisms.Add(Name, PersistenceMechanism);
end;

procedure TPersistenceBroker.ConnectTo(aPersistenceMechanism: IPersistenceMechanism);
begin
  FMechanisms.Add(aPersistenceMechanism.ConnectionName, aPersistenceMechanism);
end;

constructor TPersistenceBroker.Create;
begin
  FMechanisms := TCollections.CreateDictionary<string, IPersistenceMechanism>;
  FClassMaps := TCollections.CreateDictionary<string, IClassMap>;
end;

procedure TPersistenceBroker.DeleteObject(aObj : IPersistentObject);
begin
  DeleteObjectFromStorage(aObj, GetMapperForClass(aObj), FMechanisms.Items[GetDatabase]);
end;

procedure TPersistenceBroker.DeleteObject(aObj: IPersistentObject; DataStore: string);
begin
  DeleteObjectFromStorage(aObj, GetMapperForClass(aObj, DataStore), FMechanisms[DataStore]);
end;

procedure TPersistenceBroker.DeleteObjectFromStorage(aObj: IPersistentObject; ClassMap: IClassMap; PersistenceMechanism: IPersistenceMechanism);
begin
  ClassMap.DeleteObject(aObj, PersistenceMechanism);
end;

destructor TPersistenceBroker.Destroy;
begin
  inherited;
end;

procedure TPersistenceBroker.DisconnectFrom(aPersistenceMechanism: IPersistenceMechanism);
begin
  FMechanisms.Remove(aPersistenceMechanism.ConnectionName);
end;

function TPersistenceBroker.GetDatabase: string;
begin
  result := FDataStoreName;
  //result := 'SQL';
  //result := 'Datasnap';
end;

function TPersistenceBroker.GetDataStores: IDictionary<string, IPersistenceMechanism>;
begin
  result := FMechanisms;
end;

function TPersistenceBroker.GetMapperForClass(ObjectClassName: string): IClassMap;
begin
  if not FClassMaps.TryGetValue(ObjectClassName + '.' + GetDatabase, result) then
    raise Exception.CreateFmt('Class mapper not found: %s.%s', [ObjectClassName, GetDatabase]);
end;

function TPersistenceBroker.GetMapperForClass(aObj: IPersistentObject; DataStore: string): IClassMap;
begin
  if not FClassMaps.TryGetValue(TPersistentObject(aObj).ClassName + '.' + DataStore, result) then
    raise Exception.CreateFmt('Class mapper not found: %s.%s', [TPersistentObject(aObj).ClassName, GetDatabase]);
end;

function TPersistenceBroker.GetMapperForClass(aObj: IPersistentObject): IClassMap;
begin
  result := GetMapperForClass(aObj, GetDatabase);
end;

function TPersistenceBroker.ProcessCritieria(CritieriaObject : IPersistenceCritieria): IList<IPersistentObject>;
var
  Mapper : IClassMap;
begin
  Mapper := GetMapperForClass(CritieriaObject.ObjectClassName);
  result := Mapper.FindObjectsWhere(CritieriaObject, FMechanisms.Items[GetDatabase]);
end;

procedure TPersistenceBroker.ProcessSql;
begin

end;

procedure TPersistenceBroker.ProcessTransaction;
begin

end;

{procedure TPersistenceBroker.RetrieveClassMaps;
begin

end;}

procedure TPersistenceBroker.RetrieveObject(aObj : IPersistentObject);
begin
  RetrieveObjectFromStorage(aObj, GetMapperForClass(aObj), FMechanisms.Items[GetDatabase], False);
end;

procedure TPersistenceBroker.RetrieveObject(aObj: IPersistentObject; DataStore: string);
begin
  RetrieveObjectFromStorage(aObj, GetMapperForClass(aObj, DataStore), FMechanisms.Items[DataStore], False);
end;

procedure TPersistenceBroker.RetrieveObjectFromStorage(aObj: IPersistentObject; ClassMap : IClassMap; PersistenceMechanism: IPersistenceMechanism; IsLock: Boolean);
begin
  ClassMap.RetrieveObject(aObj, PersistenceMechanism);
end;

procedure TPersistenceBroker.SaveObject(aObj: IPersistentObject; DataStore: string);
begin
  UpdateObjectFromStorage(aObj, GetMapperForClass(aObj, DataStore), FMechanisms.Items[DataStore], False);
end;

procedure TPersistenceBroker.SetDatabase(const Value: string);
begin
  FDataStoreName := Value;
end;

procedure TPersistenceBroker.SaveObject(aObj : IPersistentObject);
begin
  UpdateObjectFromStorage(aObj, GetMapperForClass(aObj), FMechanisms.Items[GetDatabase], False);
end;

procedure TPersistenceBroker.UpdateObjectFromStorage(aObj: IPersistentObject; ClassMap: IClassMap; PersistenceMechanism: IPersistenceMechanism; IsLock: Boolean);
begin
  if aObj.IsPersistent then
    ClassMap.UpdateObject(aObj, PersistenceMechanism)
  else
    ClassMap.InsertObject(aObj, PersistenceMechanism);
end;

initialization
  GlobalContainer.RegisterComponent<TPersistenceBroker>.Implements<IPersistenceBroker>.AsSingleton;
  GlobalContainer.Build;

end.
