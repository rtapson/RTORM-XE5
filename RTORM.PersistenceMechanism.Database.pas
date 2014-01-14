unit RTORM.PersistenceMechanism.Database;

interface

uses
  RTORM.PersistenceMechanism, RTORM.Sql, RTORM.PersistentObject,
  Spring.Collections, RTORM.Maps.Attributes;

type
  IRelationalDatabase = interface(IPersistenceMechanism)
  ['{A6E39C21-8C74-42E3-B7E1-1A4DB09020F5}']
    procedure ProcessSql;
    function ExecuteSQL(aSQLStatement : ISqlStatement; Attributes : IDictionary<string, IAttributeMap>; aObj : IPersistentObject): IPersistentObject;
    procedure ExecuteStatementNonQuery(aSQLStatement : ISqlStatement);
    function GetClauseStringDelete: string;
    function GetClauseStringSelect: string;
    function GetClauseStringInsert: string;
    function GetClauseStringUpdate: string;
    function GetClauseStringFrom: string;
    function GetClauseStringOrderBy: string;
    function GetClauseStringWhere: string;
    function GetClauseStringAndBegin: string;
    function GetClauseStringAndEnd: string;
    function GetClauseStringOrBegin: string;
    function GetClauseStringOrEnd: string;
    function GetClauseStringDistinct: string;
    function GetClauseStringSet: string;
    function GetClauseStringValues: string;
    function GetClauseStringInnerJoin: string;
  end;

  TRelationalDatabase = class(TPersistenceMechanism, IRelationalDatabase)
  public
    procedure ProcessSql; virtual; abstract;
    function ExecuteSQL(aSQLStatement : ISqlStatement; Attributes : IDictionary<string, IAttributeMap>; aObj : IPersistentObject): IPersistentObject; virtual; abstract;
    procedure ExecuteStatementNonQuery(aSQLStatement : ISqlStatement); virtual; abstract;
    function GetClauseStringDelete: string; virtual; abstract;
    function GetClauseStringSelect: string; virtual; abstract;
    function GetClauseStringInsert: string; virtual; abstract;
    function GetClauseStringUpdate: string; virtual; abstract;
    function GetClauseStringFrom: string; virtual; abstract;
    function GetClauseStringOrderBy: string; virtual; abstract;
    function GetClauseStringWhere: string; virtual; abstract;
    function GetClauseStringAndBegin: string; virtual; abstract;
    function GetClauseStringAndEnd: string; virtual; abstract;
    function GetClauseStringOrBegin: string; virtual; abstract;
    function GetClauseStringOrEnd: string; virtual; abstract;
    function GetClauseStringDistinct: string; virtual; abstract;
    function GetClauseStringSet: string; virtual; abstract;
    function GetClauseStringValues: string; virtual; abstract;
    function GetClauseStringInnerJoin: string; virtual; abstract;
  end;


implementation

end.
