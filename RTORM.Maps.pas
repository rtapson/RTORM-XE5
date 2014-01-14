unit RTORM.Maps;

interface

uses
  RTORM.PersistentObject, RTORM.PersistenceMechanism, Spring.Collections,
  RTORM.Maps.Attributes, RTORM.Sql, RTORM.PersistenceMechanism.TextFiles,
  RTORM.PersistenceCritieria, SQLExpr, SysUtils, RTORM.UniDirectionalAssociationMap;

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
    function OpenSqlStatement(PersistenceMechanism: IPersistenceMechanism; aSqlStatement: ISqlStatement): TSQLDataset;
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
    procedure DatasetToObject(aDataset : TSQLDataset; aObj : IPersistentObject); virtual;
    procedure ProcessDataset(ClassName : string; aDataset: TSqlDataset; ObjectList : IList<IPersistentObject>); virtual;
  public
    procedure RetrieveObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    procedure DeleteObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    procedure UpdateObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    procedure InsertObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    function FindObjectsWhere(Critieria : IPersistenceCritieria; PersistenceMechanism: IPersistenceMechanism): IList<IPersistentObject>; override;
  end;

  ITextFileMapper = interface(IClassMap)
    ['{01101EE7-ED90-4E27-A9EE-D24C8CDB6C6F}']
  end;

  TTextFileMapper = class(TClassMap, ITextFileMapper)
  private
    FTextFile : ITextFile;
  public
    procedure RetrieveObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    procedure DeleteObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    procedure UpdateObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
    procedure InsertObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism); override;
  end;

implementation

uses
  CodeSiteLogging, rtti, System.TypInfo, DB, Classes, Spring.Services, Spring.Container,
  spring;

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
  FAttributeMaps := TCollections.CreateDictionary<string, IAttributeMap>;
  FAssociations := TCollections.CreateList<IUniDirectionalAssociationMap>;
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

procedure TRelationalDatabaseMapper.DatasetToObject(aDataset: TSQLDataset; aObj: IPersistentObject);
var
  Attrib: IAttributeMap;
  context: TRttiContext;
  rtti: TRTTIType;
  //pField: TRttiField;
  value : TValue;
  i : integer;
begin
  context := TRttiContext.Create;
  try
    rtti := context.GetType(TObject(aObj).ClassInfo);
    try
      {for pField in rtti.GetFields do
      begin
        CodeSite.Send(pField.ToString);
      end;}

      for Attrib in AttributeMaps.Values do
      begin
        case rtti.GetField('F' + Attrib.Name).FieldType.TypeKind of
          tkWChar,
          tkLString,
          tkWString,
          tkString,
          tkChar,
          tkUString : Value := aDataset.FieldByName(Attrib.ColumnMap.Name).AsString;
          tkInteger,
          tkInt64  :
            begin
              Value := StrToIntDef(aDataset.FieldByName(Attrib.ColumnMap.Name).AsString, 0);
            end;
          tkFloat  :
            begin
              case  aDataset.FieldByName(Attrib.ColumnMap.Name).DataType of
                ftDateTime, ftTimeStamp : Value := aDataset.FieldByName(Attrib.ColumnMap.Name).AsDateTime;
              else
                Value := StrToFloat(aDataset.FieldByName(Attrib.ColumnMap.Name).AsString);
              end;
            end;
          tkEnumeration:
            begin
              if rtti.GetField('F' + Attrib.Name).FieldType.Name = 'Boolean' then
                Value := TValue.From(aDataset.FieldByName(Attrib.ColumnMap.Name).AsString = 'Y')
              else
                Value := TValue.FromOrdinal(Value.TypeInfo, GetEnumValue(Value.TypeInfo, aDataset.FieldByName(Attrib.ColumnMap.Name).AsString));
            end;
          tkSet:
            begin
              i :=  StringToSet(Value.TypeInfo,aDataset.FieldByName(Attrib.ColumnMap.Name).AsString);
              TValue.Make(@i, Value.TypeInfo, Value);
            end;
        else
          raise ETypeNotSupported.Create('Type not Supported');
        end;
        rtti.GetField('F' + Attrib.Name).SetValue(TObject(aObj), Value)
      end;
    finally
      rtti.Free;
    end;
  finally
    context.free;
  end;
end;

procedure TRelationalDatabaseMapper.DeleteObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
    ExecuteSqlStatement(PersistenceMechanism, GetDeleteSQLFor(aObj, PersistenceMechanism));
end;

procedure TRelationalDatabaseMapper.ExecuteSqlStatement(PersistenceMechanism : IPersistenceMechanism; aSqlStatement: ISqlStatement);
begin
  FRelationalDatabase.Open;
  FRelationalDatabase.ExecuteStatementNonQuery(aSqlStatement);
end;

function TRelationalDatabaseMapper.FindObjectsWhere(Critieria: IPersistenceCritieria; PersistenceMechanism: IPersistenceMechanism): IList<IPersistentObject>;
var
  SqlStatement : ISqlStatement;
  aDataset: TSQLDataSet;
  //aObj : IPersistentObject;
begin
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
  begin
    SqlStatement := GetSelectSQL(False);
    SqlStatement.AddSqlStatement(GetFromAndWhereSql(Critieria));
    aDataset := OpenSqlStatement(PersistenceMechanism, SqlStatement);
    try
      result := TCollections.CreateList<IPersistentObject>;
      ProcessDataset(Critieria.ObjectClassName, aDataset, result);
    finally
      aDataset.Free;
    end;
  end;
end;

function TRelationalDatabaseMapper.GetSelectSql(Distinct: boolean): ISqlStatement;
var
  AttMap: IAttributeMap;
  IsFirst: boolean;
begin
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
          WhereClause := WhereClause + Format(' %s %s = :%s %s',
            [FRelationalDatabase.GetClauseStringAndBegin,
            Map.ColumnMap.FullyQualifiedName, Map.Name,
            FRelationalDatabase.GetClauseStringAndEnd]);
      end);



  result.AddSqlClause(' ' + WhereClause);
  CodeSite.Send('result', result.ToString);
  CodeSite.ExitMethod(Self, 'GetFromAndWhereSql');
end;

function TRelationalDatabaseMapper.GetWhereSql: ISqlStatement;
var
  IsFirst: boolean;
  Map: IAttributeMap;
begin
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
end;

procedure TRelationalDatabaseMapper.InsertObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
    ExecuteSqlStatement(PersistenceMechanism, GetInsertSQLFor(aObj, PersistenceMechanism));
end;

function TRelationalDatabaseMapper.OpenSqlStatement(PersistenceMechanism: IPersistenceMechanism; aSqlStatement: ISqlStatement): TSQLDataset;
begin
  FRelationalDatabase.Open;
  result := FRelationalDatabase.ExecuteSQL(aSqlStatement);
end;

procedure TRelationalDatabaseMapper.ProcessDataset(ClassName : string; aDataset: TSqlDataset; ObjectList: IList<IPersistentObject>);
var
  aObj : IPersistentObject;
begin
  while not aDataset.Eof do
  begin
    aObj := TInterfacedPersistent(GetClass(ClassName).Create) as IPersistentObject;
    DataSetToObject(aDataset, aObj);
    ObjectList.Add(aObj);
    aDataset.Next;
  end;
end;

procedure TRelationalDatabaseMapper.RetrieveObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
var
  aDataset: TSQLDataSet;
  aAssoc: IUniDirectionalAssociationMap;

  RetCrit : IPersistenceCritieria;
  aList : IList<IPersistentObject>;

  context: TRttiContext;
  rtti: TRTTIType;
  prop: TRttiProperty;

  aMap : IAttributeMap;
begin
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
  begin
    aDataset := OpenSqlStatement(PersistenceMechanism, GetSelectSQLFor(aObj, PersistenceMechanism));
    try
      DataSetToObject(aDataset, aObj);
    finally
      aDataset.Free;
    end;

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
end;

procedure TRelationalDatabaseMapper.UpdateObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
    ExecuteSqlStatement(PersistenceMechanism,  GetUpdateSQLFor(aObj, PersistenceMechanism));
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
end;

function TRelationalDatabaseMapper.GetInsertSQLFor(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
var
  Map: IAttributeMap;
  isDone: boolean;
  IsFirst: boolean;
begin
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
end;

function TRelationalDatabaseMapper.GetUpdateSQLFor(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
var
  Map: IAttributeMap;
  IsFirst: boolean;
  isDone: boolean;
begin
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
end;

function TRelationalDatabaseMapper.GetDeleteSQLFor(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
begin
  result := TSqlStatement.Create;
  result.AddSqlClause(Format('%s ', [FRelationalDatabase.GetClauseStringDelete]));
  result.AddSqlStatement(GetFromAndWhereSql);
  result := GetSqlWithParamValues(result, aObj);
end;

function TRelationalDatabaseMapper.GetFromAndWhereSql(Critieria: IPersistenceCritieria): ISqlStatement;
var
  IsFirst: boolean;
  aCritieria: ISelectionCritieria;
  Map : IAttributeMap;
  PrimaryTable : string;
begin
  result := TSqlStatement.Create;
  result.AddSqlClause(Format(' %s ', [FRelationalDatabase.GetClauseStringFrom]));

  for Map in AttributeMaps.Values do
  begin
    case Map.ColumnMap.ColumnType of
      ktPrimary:
        begin
          PrimaryTable := Map.ColumnMap.TableMap.Name;
          result.AddSqlClause(Map.ColumnMap.TableMap.FullyQualifiedName);
        end;
    end;
  end;

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
end;

function TRelationalDatabaseMapper.GetSelectSQLFor(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism): ISqlStatement;
var
  SqlStatement: ISqlStatement;
begin
  CodeSite.EnterMethod(Self, 'GetSelectSQLFor');
  if Supports(PersistenceMechanism, IRelationalDatabase, FRelationalDatabase) then
  begin
    SqlStatement := GetSelectSql(False);

    CodeSite.Send('SqlStatement1', SqlStatement.ToString);
    SqlStatement.AddSqlStatement(GetFromAndWhereSql);
    CodeSite.Send('SqlStatement2', SqlStatement.ToString);
    // Last step, setup the params.
    SqlStatement := GetSqlWithParamValues(SqlStatement, aObj);
    CodeSite.Send('SqlStatement3', SqlStatement.ToString);
    result := SqlStatement;
  end
  else
    raise Exception.Create('Only SQL Datases are supported.');
  CodeSite.ExitMethod(Self, 'GetSelectSQLFor');
end;

{ TTextFileMapper }

procedure TTextFileMapper.DeleteObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin

end;

procedure TTextFileMapper.InsertObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin
  if Supports(PersistenceMechanism, ITextFile, FTextFile) then
    FTextFile.SaveObject(aObj);
end;

procedure TTextFileMapper.RetrieveObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin

end;

procedure TTextFileMapper.UpdateObject(aObj: IPersistentObject; PersistenceMechanism: IPersistenceMechanism);
begin
  if Supports(PersistenceMechanism, ITextFile, FTextFile) then
    FTextFile.SaveObject(aObj);
end;

end.
