unit RTORM.Maps;

interface

uses
  SysUtils
  ,Spring.Collections
  ,RTORM.PersistentObject
  ,RTORM.PersistenceMechanism
  ,RTORM.Maps.Attributes
  ,RTORM.Sql
  ,RTORM.PersistenceCritieria
  ,RTORM.UniDirectionalAssociationMap
  ,RTORM.PersistenceMechanism.Database
  ;

type
  ETypeNotSupported = class(Exception);
  ETypeNotFound = class(Exception);

  IClassMap = interface
  ['{28000437-21FF-4310-9F43-6E2F5861689C}']
    function GetTypeName: string;
    function GetAttributeMaps: IDictionary<string, IAttributeMap>;
    procedure RetrieveObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
    procedure DeleteObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
    procedure UpdateObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
    procedure InsertObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
    function FindObjectsWhere(Critieria : IPersistenceCritieria; PersistenceMechanism: IPersistenceMechanism): IList<IPersistentObject>;
    function GetAssociations: IList<IUniDirectionalAssociationMap>;
    function GetForClass: IPersistentObject;
    procedure SetForClass(const Value: IPersistentObject);

    property Associations : IList<IUniDirectionalAssociationMap> read GetAssociations;
    property AttributeMaps: IDictionary<string, IAttributeMap> read GetAttributeMaps;
    property TypeName : string read GetTypeName;
    property ForClass : IPersistentObject read GetForClass write SetForClass;
  end;

  TClassMap = class(TInterfacedObject, IClassMap)
  private
    FTypeName : string;
    FAttributeMaps : IDictionary<string, IAttributeMap>;
    FAssociations : IList<IUniDirectionalAssociationMap>;
    FForClass : IPersistentObject;
    function GetAttributeMaps: IDictionary<string, IAttributeMap>;
    function GetTypeName: string;
    function GetAssociations: IList<IUniDirectionalAssociationMap>;
    function GetForClass: IPersistentObject;
    procedure SetForClass(const Value: IPersistentObject);
  public
    constructor Create; virtual;
    procedure RetrieveObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); virtual; abstract;
    procedure DeleteObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); virtual; abstract;
    procedure UpdateObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); virtual; abstract;
    procedure InsertObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); virtual; abstract;
    function FindObjectsWhere(Critieria : IPersistenceCritieria; PersistenceMechanism: IPersistenceMechanism): IList<IPersistentObject>; virtual; abstract;

    property Associations : IList<IUniDirectionalAssociationMap> read GetAssociations;
    property AttributeMaps: IDictionary<string, IAttributeMap> read GetAttributeMaps;
    property TypeName : string read GetTypeName;
    property ForClass : IPersistentObject read GetForClass write SetForClass;
  end;

  IRelationalDatabaseMapper = interface(IClassMap)
    ['{91FB1B7F-D93B-4DAF-8773-19F465F97F51}']
    function GetSelectSQLFor(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
    function GetInsertSQLFor(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
    function GetUpdateSQLFor(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
    function GetDeleteSQLFor(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
  end;

  TRelationalDatabaseMapper = class(TClassMap, IRelationalDatabaseMapper)
  private
    FRelationalDatabase : IRelationalDatabase;
    procedure ExecuteSqlStatement(PersistenceMechanism: IPersistenceMechanism; aSqlStatement: ISqlStatement);
    function OpenSqlStatement(PersistenceMechanism: IPersistenceMechanism; aSqlStatement: ISqlStatement; const ClassName : string): IList<IPersistentObject>;
    function GetSelectSql(Distinct: boolean): ISqlStatement;
    function GetFromAndWhereSql: ISqlStatement; overload;
    function GetFromAndWhereSql(Critieria : IPersistenceCritieria): ISqlStatement; overload;
    function GetWhereSql: ISqlStatement;
    function GetSqlWithParamValues(aSqlStatement: ISqlStatement; aObj: IPersistentObject): ISqlStatement;
    function GetInsertSQLFor(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
    function GetUpdateSQLFor(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
    function GetDeleteSQLFor(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
  protected
    function GetSelectSQLFor(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
  public
    procedure RetrieveObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    procedure DeleteObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    procedure UpdateObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    procedure InsertObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    function FindObjectsWhere(Critieria : IPersistenceCritieria; PersistenceMechanism: IPersistenceMechanism): IList<IPersistentObject>; override;
  end;

implementation

uses
  CodeSiteLogging, rtti, System.TypInfo, Classes;

{function GetTypeInfoFromName(aTypeName : String) : pTypeInfo;
var
 C : TRttiContext;
 T : TRttiType;
begin
 T := C.FindType(aTypeName);
 if Not Assigned(T) then
    raise ETypeNotFound.CreateFmt('Type %s is not found',[aTypeName]);

 result := T.Handle;
end;}

{ TClassMap }

constructor TClassMap.Create;
begin
  CodeSite.EnterMethod(Self, 'Create');
  FAttributeMaps := TCollections.CreateDictionary<string, IAttributeMap>;
  FAssociations := TCollections.CreateList<IUniDirectionalAssociationMap>;
  CodeSite.ExitMethod(Self, 'Create');
end;

function TClassMap.GetAssociations: IList<IUniDirectionalAssociationMap>;
begin
  result := FAssociations;
end;

function TClassMap.GetAttributeMaps: IDictionary<string, IAttributeMap>;
begin
  result := FAttributeMaps;
end;

function TClassMap.GetForClass: IPersistentObject;
begin
  result := FForClass;
end;

function TClassMap.GetTypeName: string;
begin
  result := FTypeName;
end;

procedure TClassMap.SetForClass(const Value: IPersistentObject);
begin
  FForClass := Value;
end;

procedure TRelationalDatabaseMapper.DeleteObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin
  CodeSite.EnterMethod(Self, 'DeleteObject');
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
    ExecuteSqlStatement(PersistenceMechanism, GetDeleteSQLFor(aObj, PersistenceMechanism));
  CodeSite.ExitMethod(Self, 'DeleteObject');
end;

procedure TRelationalDatabaseMapper.ExecuteSqlStatement(PersistenceMechanism : IPersistenceMechanism; aSqlStatement: ISqlStatement);
begin
  CodeSite.EnterMethod(Self, 'ExecuteSqlStatement');
  FRelationalDatabase.Open;
  FRelationalDatabase.ExecuteStatementNonQuery(aSqlStatement);
  CodeSite.ExitMethod(Self, 'ExecuteSqlStatement');
end;

function TRelationalDatabaseMapper.FindObjectsWhere(Critieria: IPersistenceCritieria; PersistenceMechanism: IPersistenceMechanism): IList<IPersistentObject>;
var
  SqlStatement : ISqlStatement;
begin
  CodeSite.EnterMethod(Self, 'FindObjectsWhere');

  result := TCollections.CreateList<IPersistentObject>;
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
  begin
    SqlStatement := GetSelectSQL(False);
    SqlStatement.AddSqlStatement(GetFromAndWhereSql(Critieria));
    result.AddRange(OpenSqlStatement(PersistenceMechanism, SqlStatement, Critieria.ObjectClassName));
  end;
  CodeSite.ExitMethod(Self, 'ExecuteSqlStatement');
end;

function TRelationalDatabaseMapper.GetSelectSql(Distinct: boolean): ISqlStatement;
var
  AttMap: IAttributeMap;
  IsFirst: boolean;
begin
  CodeSite.EnterMethod(Self, 'GetSeleteSql');

  result := TSqlStatement.Create;
  result.AddSqlClause(FRelationalDatabase.GetClauseStringSelect + ' ');
  if Distinct then
    result.AddSqlClause(FRelationalDatabase.GetClauseStringDistinct + ' ');
  IsFirst := True;
  for AttMap in AttributeMaps.Values do
  begin
    if not IsFirst then
      result.AddSqlClause(Format(', %s', [AttMap.ColumnMap.FullyQualifiedName]))
    else
      result.AddSqlClause(AttMap.ColumnMap.FullyQualifiedName);
    IsFirst := False;
  end;
  CodeSite.ExitMethod(Self, 'GetSeleteSql', result.ToString);
end;

function TRelationalDatabaseMapper.GetFromAndWhereSql: ISqlStatement;
var
  IsFirst: boolean;
  Map: IAttributeMap;
  PrimaryTable, WhereClause : string;

  KeyMaps : IEnumerable<IAttributeMap>;
begin
  CodeSite.EnterMethod(Self, 'GetFromAndWhereSql');
  result := TSqlStatement.Create;
  result.AddSqlClause(Format(' %s ', [FRelationalDatabase.GetClauseStringFrom]));
  { IsFirst := True;
    for Map in AttributeMaps.Values do
    begin
    if IsFirst then
    result.AddSqlClause(Map.ColumnMap.TableMap.Name)
    else
    result.AddSqlClause(Format(', %s', [Map.ColumnMap.TableMap.Name]));
    end; }
 (* IsFirst := True;
  for Map in AttributeMaps.Values do
  begin
    case Map.ColumnMap.ColumnType of
      ktNone:
        begin

        end;
      ktPrimary:
        begin
          if IsFirst then
          begin
            CodeSite.Send('IsFirst', IsFirst);
            PrimaryTable := Map.ColumnMap.FullyQualifiedName;
            result.AddSqlClause(Map.ColumnMap.TableMap.FullyQualifiedName);

            WhereClause := Format(' %s (%s = :%s)',
              [FRelationalDatabase.GetClauseStringWhere,
              Map.ColumnMap.FullyQualifiedName, Map.Name]);
            {result.AddSqlClause(Format(' %s (%s = :%s)',
              [FRelationalDatabase.GetClauseStringWhere,
              Map.ColumnMap.FullyQualifiedName, Map.Name]));}
            IsFirst := False;
          end
          else
          begin
            WhereClause := WhereClause + Format(' %s %s = :%s %s',
              [FRelationalDatabase.GetClauseStringAndBegin,
              Map.ColumnMap.FullyQualifiedName, Map.Name,
              FRelationalDatabase.GetClauseStringAndEnd]);
          end;
        end;
      ktForeign:
        begin
          result.AddSqlClause(' ' + FRelationalDatabase.GetClauseStringInnerJoin + ' ' + Map.ColumnMap.TableMap.FullyQualifiedName + ' ON ' + PrimaryTable + ' = ' + Map.ColumnMap.FullyQualifiedName);
        end;
    end;
  end;   *)

  KeyMaps := AttributeMaps.Values.Where(
    function(const Attribute : IAttributeMap): boolean
    begin
      result := Attribute.ColumnMap.ColumnType = ktPrimary;
    end);

  result.AddSqlClause(KeyMaps.First.ColumnMap.TableMap.FullyQualifiedName);

  result.AddSqlClause(' ' +FRelationalDatabase.GetClauseStringWhere);

  KeyMaps.ForEach(
      procedure(const Map : IAttributeMap)
      begin
        if WhereClause = '' then
          WhereClause := Format(' ( %s = :%s %s',
            [Map.ColumnMap.FullyQualifiedName, Map.Name,
            FRelationalDatabase.GetClauseStringAndEnd])
        else
          WhereClause := WhereClause + Format('%s %s = :%s %s',
            [FRelationalDatabase.GetClauseStringAndBegin,
            Map.ColumnMap.FullyQualifiedName, Map.Name,
            FRelationalDatabase.GetClauseStringAndEnd]);
      end);

  CodeSite.Send('WhereClause', WhereClause);
  result.AddSqlClause(' ' + WhereClause);
  CodeSite.ExitMethod(Self, 'GetFromAndWhereSql', result.ToString);
end;

function TRelationalDatabaseMapper.GetWhereSql: ISqlStatement;
var
  IsFirst: boolean;
  Map: IAttributeMap;
begin
  CodeSite.EnterMethod(Self, 'GetWhereSql');

  result := TSqlStatement.Create;
  IsFirst := True;
  for Map in AttributeMaps.Values do
  begin
    if Map.ColumnMap.ColumnType = ktPrimary then
    begin
      if IsFirst then
      begin
        result.AddSqlClause(Format(' %s (%s = :%s)',
          [FRelationalDatabase.GetClauseStringWhere,
          Map.ColumnMap.FullyQualifiedName, Map.Name]));
        IsFirst := False;
      end
      else
      begin
        result.AddSqlClause(Format(' %s %s = :%s %s',
          [FRelationalDatabase.GetClauseStringAndBegin,
          Map.ColumnMap.FullyQualifiedName, Map.Name,
          FRelationalDatabase.GetClauseStringAndEnd]));
      end;
    end;
  end;
  CodeSite.ExitMethod(Self, 'GetWhereSql');
end;

procedure TRelationalDatabaseMapper.InsertObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin
  CodeSite.EnterMethod(Self, 'InsertObject');
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
    ExecuteSqlStatement(PersistenceMechanism, GetInsertSQLFor(aObj, PersistenceMechanism));
  CodeSite.ExitMethod(Self, 'InsertObject');
end;

function TRelationalDatabaseMapper.OpenSqlStatement(PersistenceMechanism: IPersistenceMechanism; aSqlStatement: ISqlStatement; const ClassName : string): IList<IPersistentObject>;
begin
  CodeSite.EnterMethod(Self, 'OpenSqlStatement');
  FRelationalDatabase.Open;
  result := FRelationalDatabase.ExecuteSQL(aSqlStatement, Self.AttributeMaps, ClassName);
  CodeSite.ExitMethod(Self, 'OpenSqlStatement');
end;

procedure TRelationalDatabaseMapper.RetrieveObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
var
//  aDataset: TSQLDataSet;
  aAssoc: IUniDirectionalAssociationMap;

  RetCrit : IPersistenceCritieria;
  aList : IList<IPersistentObject>;

  context: TRttiContext;
  rtti: TRTTIType;
  prop: TRttiProperty;

  aMap : IAttributeMap;


  ObjList : IList<IPersistentObject>;
begin
  CodeSite.EnterMethod(Self, 'RetrieveObject');

  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
  begin
    ObjList := OpenSqlStatement(PersistenceMechanism, GetSelectSQLFor(aObj, PersistenceMechanism), TObject(AObj).ClassName);

    ObjList.TryGetFirst(aObj);

    context := TRttiContext.Create;
    try
      rtti := context.GetType(TObject(aObj).ClassInfo);

      for aAssoc in Associations do
      begin
        RetCrit := TPersistentCritieria.Create(aAssoc.TargetClassName);

        aAssoc.Params.Keys.ForEach(
          procedure(const Obj : string)
          begin
            aAssoc.Params.TryGetValue(Obj, aMap);
            RetCrit.AddSelectEqualTo(Obj, rtti.GetProperty(aMap.Name).GetValue(TObject(aObj)).AsInteger);
          end
        );

        aList := TCollections.CreateList<IPersistentObject>;
        aList := RetCrit.Perform;

        aList.ForEach(
          procedure(const obj: IPersistentObject)
          begin
            //Get list type, IList or IDictionary and then
            //set the props
            //prop :=  rtti.GetProperty(aAssoc.TargetName);
            //if prop.GetValue(obj).IsType<IDictionary<integer, IPermission> then

            //(aObj as IRole).Permissions.Add((Obj as IPermission).ClientResourceID, (Obj as IPermission));
          end
        );
      end;
    finally
      context.Free;
    end;
  end;
  CodeSite.ExitMethod(Self, 'RetrieveObject');
end;

procedure TRelationalDatabaseMapper.UpdateObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin
  CodeSite.EnterMethod(Self, 'UpdateObject');
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
    ExecuteSqlStatement(PersistenceMechanism,  GetUpdateSQLFor(aObj, PersistenceMechanism));
  CodeSite.ExitMethod(Self, 'UpdateObject');
end;

function TRelationalDatabaseMapper.GetSqlWithParamValues(aSqlStatement : ISqlStatement; aObj: IPersistentObject): ISqlStatement;
var
  Map: IAttributeMap;
  context: TRttiContext;
  rtti: TRTTIType;
  meth: TRttiProperty;
  EnumType: integer;
  aDate: TDateTime;
begin
  CodeSite.EnterMethod(Self, 'GetSqlWithParamValues');

  result := TSqlStatement.Create;
  result.AddSqlStatement(aSqlStatement);
  context := TRttiContext.Create;
  try
    rtti := context.GetType(TObject(aObj).ClassInfo);
    //for meth in rtti.GetProperties do
    //begin
    //  CodeSite.Send(meth.ToString);
    //end;
    for Map in AttributeMaps.Values do
    begin
      // if Map.ColumnMap.ColumnType = ktPrimary then
      // begin
      meth := rtti.GetProperty(Map.Name);
      if Assigned(meth) then
      begin
        case meth.PropertyType.TypeKind of
          tkUnknown:
            ;
          tkInteger:
            result.UpdateParam(meth.Name, meth.GetValue(TObject(aObj)).AsInteger);
          tkChar:
            result.UpdateParam(meth.Name, meth.GetValue(TObject(aObj)).AsString);
          tkEnumeration:
            begin
              if meth.PropertyType.Name = 'Boolean' then
              begin
                if meth.GetValue(TObject(aObj)).AsOrdinal = 0 then
                  result.UpdateParam(meth.Name, 'N')
                else
                  result.UpdateParam(meth.Name, 'Y');
              end
              else
              begin
                EnumType := meth.GetValue(TObject(aObj)).AsOrdinal;
                result.UpdateParam(meth.Name, EnumType);
              end;
            end;
          tkFloat:
            begin
              if meth.PropertyType.Handle = TypeInfo(TDateTime) then
              begin
                aDate := meth.GetValue(TObject(aObj)).AsType<TDateTime>;
                result.UpdateParam(meth.Name, aDate);
              end
              else
                result.UpdateParam(meth.Name, meth.GetValue(TObject(aObj)).AsCurrency);
            end;
          tkString:
            result.UpdateParam(meth.Name, meth.GetValue(TObject(aObj)).AsString);
          tkSet:
            ;
          tkClass:
            ;
          tkMethod:
            ;
          tkWChar:
            result.UpdateParam(meth.Name, meth.GetValue(TObject(aObj)).AsString);
          tkLString:
            result.UpdateParam(meth.Name, meth.GetValue(TObject(aObj)).AsString);
          tkWString:
            result.UpdateParam(meth.Name, meth.GetValue(TObject(aObj)).AsString);
          tkVariant:
            ;
          tkArray:
            ;
          tkRecord:
            ;
          tkInterface:
            ;
          tkInt64:
            ;
          tkDynArray:
            ;
          tkUString:
            result.UpdateParam(meth.Name, meth.GetValue(TObject(aObj))
              .AsString);
          tkClassRef:
            ;
          tkPointer:
            ;
          tkProcedure:
            ;
        end;
        // end;
      end;
    end;
  finally
    context.Free;
  end;
  CodeSite.ExitMethod(Self, 'GetSqlWithParamValues');
end;

function TRelationalDatabaseMapper.GetInsertSQLFor(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
var
  Map: IAttributeMap;
  isDone: boolean;
  IsFirst: boolean;
begin
  CodeSite.EnterMethod(Self, 'GetInsertSQLFor');

  result := TSqlStatement.Create;
  result.AddSqlClause(Format('%s ',
    [FRelationalDatabase.GetClauseStringInsert]));
  isDone := False;
  for Map in AttributeMaps.Values do
  begin
    if (Map.ColumnMap.ColumnType = ktPrimary) and (not isDone) then
    begin
      result.AddSqlClause(Format('%s ',
        [Map.ColumnMap.TableMap.FullyQualifiedName]));
      isDone := True;
    end;
  end;
  IsFirst := True;
  for Map in AttributeMaps.Values do
  begin
    if not(Map.ColumnMap.ColumnType = ktPrimary) then
    begin
      if IsFirst then
        result.AddSqlClause(Format('%s', [Map.ColumnMap.Name]))
      else
        result.AddSqlClause(Format(', %s', [Map.ColumnMap.Name]));
      IsFirst := False;
    end;
  end;
  result.AddSqlClause(Format(' %s ',
    [FRelationalDatabase.GetClauseStringValues]));
  IsFirst := True;
  for Map in AttributeMaps.Values do
  begin
    if not(Map.ColumnMap.ColumnType = ktPrimary) then
    begin
      if IsFirst then
        result.AddSqlClause(Format(':%s', [Map.Name]))
      else
        result.AddSqlClause(Format(', :%s', [Map.Name]));
      IsFirst := False;
    end;
  end;
  result.AddSqlClause(FRelationalDatabase.GetClauseStringAndEnd);
  result := GetSqlWithParamValues(result, aObj);
  CodeSite.ExitMethod(Self, 'GetInsertSQLFor');
end;

function TRelationalDatabaseMapper.GetUpdateSQLFor(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
var
  Map: IAttributeMap;
  IsFirst: boolean;
  isDone: boolean;
begin
  CodeSite.EnterMethod(Self, 'GetUpdateSQLFor');

  result := TSqlStatement.Create;
  result.AddSqlClause(Format('%s ',
    [FRelationalDatabase.GetClauseStringUpdate]));
  isDone := False;
  for Map in AttributeMaps.Values do
  begin
    if (Map.ColumnMap.ColumnType = ktPrimary) and (not isDone) then
    begin
      result.AddSqlClause(Map.ColumnMap.TableMap.FullyQualifiedName);
      isDone := True;
    end;
  end;
  result.AddSqlClause(Format(' %s ', [FRelationalDatabase.GetClauseStringSet]));
  IsFirst := True;
  for Map in AttributeMaps.Values do
  begin
    if not(Map.ColumnMap.ColumnType = ktPrimary) then
    begin
      if IsFirst then
        result.AddSqlClause(Format('%s = :%s', [Map.ColumnMap.Name, Map.Name]))
      else
        result.AddSqlClause(Format(', %s = :%s', [Map.ColumnMap.Name,
          Map.Name]));
      IsFirst := False;
    end;
  end;
  result.AddSqlStatement(GetWhereSql);
  result := GetSqlWithParamValues(result, aObj);
  CodeSite.ExitMethod(Self, 'GetUpdateSQLFor');
end;

function TRelationalDatabaseMapper.GetDeleteSQLFor(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
begin
  CodeSite.EnterMethod(Self, 'GetDeleteSQLFor');

  result := TSqlStatement.Create;
  result.AddSqlClause(Format('%s ', [FRelationalDatabase.GetClauseStringDelete]));
  result.AddSqlStatement(GetFromAndWhereSql);
  result := GetSqlWithParamValues(result, aObj);
  CodeSite.ExitMethod(Self, 'GetDeleteSQLFor');
end;

function TRelationalDatabaseMapper.GetFromAndWhereSql(Critieria: IPersistenceCritieria): ISqlStatement;
var
  IsFirst: boolean;
  aCritieria: ISelectionCritieria;
  Map : IAttributeMap;
  PrimaryTable : string;

  sList : TStringList;
begin
  CodeSite.EnterMethod(Self, 'GetFromAndWhereSql');

  result := TSqlStatement.Create;
  result.AddSqlClause(Format(' %s ', [FRelationalDatabase.GetClauseStringFrom]));

  sList := TStringList.Create;
  try
    sList.Duplicates := dupIgnore;

    for Map in AttributeMaps.Values do
    begin
      case Map.ColumnMap.ColumnType of
        ktPrimary:
          begin
            if sList.IndexOf(Map.ColumnMap.TableMap.FullyQualifiedName) = -1 then
            begin
              PrimaryTable := Map.ColumnMap.TableMap.Name;
              result.AddSqlClause(Map.ColumnMap.TableMap.FullyQualifiedName);
              sList.Add(Map.ColumnMap.TableMap.FullyQualifiedName);
            end;
          end;
      end;
    end;
    sList.Clear;

    for Map in AttributeMaps.Values do
    begin
      case Map.ColumnMap.ColumnType of
        ktForeign:
          begin
            //result.AddSqlClause(' ' + FRelationalDatabase.GetClauseStringInnerJoin + ' ' + Map.ColumnMap.TableMap.FullyQualifiedName + ' ON ' + PrimaryTable + ' = ' + Map.ColumnMap.FullyQualifiedName + ' ');
            result.AddSqlClause(Format(' %s %s ON %s.%s = %s', [FRelationalDatabase.GetClauseStringInnerJoin, Map.ColumnMap.TableMap.FullyQualifiedName, PrimaryTable, Map.ColumnMap.Name, Map.ColumnMap.FullyQualifiedName]));
          end;
      end;
    end;
  finally
    sList.Free;
  end;

  result.AddSqlClause(Format(' %s ', [FRelationalDatabase.GetClauseStringWhere]));

  IsFirst := True;
  for aCritieria in Critieria.CritieriaList do
  begin
    if AttributeMaps.TryGetValue(aCritieria.AttributeName, Map) then
    begin
      if IsFirst then
      begin
        result.AddSqlClause(Format('( %s %s )', [Map.ColumnMap.FullyQualifiedName, aCritieria.AsSQLClause]));
        IsFirst := False;
      end
      else
        result.AddSqlClause(Format(' %s %s %s %s',
            [FRelationalDatabase.GetClauseStringAndBegin,
             Map.ColumnMap.FullyQualifiedName,
             aCritieria.AsSQLClause,
             FRelationalDatabase.GetClauseStringAndEnd]));
    end
    else
      raise Exception.CreateFmt('AttributeMap not found for attribute %s', [aCritieria.AttributeName]);
  end;
  CodeSite.ExitMethod(Self, 'GetFromAndWhereSql', result.ToString);
end;

function TRelationalDatabaseMapper.GetSelectSQLFor(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
var
  SqlStatement: ISqlStatement;
begin
  CodeSite.EnterMethod(Self, 'GetSelectSQLFor');
  //if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
  //begin
    SqlStatement := GetSelectSql(False);

    CodeSite.Send('SqlStatement1', SqlStatement.ToString);
    SqlStatement.AddSqlStatement(GetFromAndWhereSql);

    CodeSite.Send('SqlStatement2', SqlStatement.ToString);
    // Last step, setup the params.
    SqlStatement := GetSqlWithParamValues(SqlStatement, aObj);
    CodeSite.Send('SqlStatement3', SqlStatement.ToString);
    result := SqlStatement;
  //end
  //else
  //  raise Exception.Create('Only SQL Datases are supported.');
  CodeSite.ExitMethod(Self, 'GetSelectSQLFor', result.ToString);
end;

end.
