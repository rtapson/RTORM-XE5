unit RTORM.Sql;

interface

uses
  SysUtils, Data.DB;

type
  ISqlStatement = interface
    ['{F242493E-B779-409E-9C45-91DE23CBB96E}']
    procedure AddParameter; overload;
    procedure AddParameter(ParamValue: TObject; ParamType: TFieldType); overload;
    function Copy: ISqlStatement;
    procedure AddSqlClause(SqlClause: string);
    procedure AddSqlStatement(SqlStatement: ISqlStatement);
    function ToString: string;

    procedure UpdateParam(const ParamName : string; Value : string); overload;
    procedure UpdateParam(const ParamName : string; Value : integer); overload;
    procedure UpdateParam(const ParamName : string; Value : TDateTime); overload;
    procedure UpdateParam(const ParamName : string; Value : Currency); overload;
    procedure UpdateParam(const ParamName : string; Value : Boolean); overload;
  end;

  TSqlStatement = class(TInterfacedObject, ISqlStatement)
  private
    FStringBuilder : TStringBuilder;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddParameter; overload;
    procedure AddParameter(ParamValue: TObject; aParamType: TFieldType); overload;
    function Copy: ISqlStatement;
    procedure AddSqlClause(SqlClause: string);
    procedure AddSqlStatement(SqlStatement: ISqlStatement);
    function ToString: string; override;
    procedure UpdateParam(const ParamName : string; Value : string); overload;
    procedure UpdateParam(const ParamName : string; Value : integer); overload;
    procedure UpdateParam(const ParamName : string; Value : TDateTime); overload;
    procedure UpdateParam(const ParamName : string; Value : Currency); overload;
    procedure UpdateParam(const ParamName : string; Value : Boolean); overload;
  end;

implementation

uses
  CodeSiteLogging;

procedure TSqlStatement.AddParameter(ParamValue: TObject; aParamType: TFieldType);
begin
  CodeSite.EnterMethod(Self, 'AddParameter');
  CodeSite.ExitMethod(Self, 'AddParameter');
end;

function TSqlStatement.Copy: ISqlStatement;
begin
  CodeSite.EnterMethod(Self, 'Copy');
  CodeSite.ExitMethod(Self, 'Copy');
end;

procedure TSqlStatement.AddParameter;
begin
  CodeSite.EnterMethod(Self, 'AddParameter');
  CodeSite.ExitMethod(Self, 'AddParameter');
end;

constructor TSqlStatement.Create;
begin
  CodeSite.EnterMethod(Self, 'Create');
  FStringBuilder := TStringBuilder.Create;
  CodeSite.ExitMethod(Self, 'Create');
end;

destructor TSqlStatement.Destroy;
begin
  CodeSite.EnterMethod(Self, 'Destroy');
  FStringBuilder.Free;
  inherited;
  CodeSite.ExitMethod(Self, 'Destroy');
end;

function TSqlStatement.ToString: string;
begin
  CodeSite.EnterMethod(Self, 'ToString');
  result := FStringBuilder.ToString;
  CodeSite.ExitMethod(Self, 'ToString', result);
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: integer);
begin
  CodeSite.EnterMethod(Self, 'UpdateParam');
  CodeSite.Send(ParamName, Value);
  FStringBuilder.Replace(':' + ParamName, IntToStr(Value));
  CodeSite.ExitMethod(Self, 'UpdateParam');
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: string);
begin
  CodeSite.EnterMethod(Self, 'UpdateParam');
  CodeSite.Send(ParamName, Value);
  FStringBuilder.Replace(':' + ParamName, QuotedStr(Value));
  CodeSite.ExitMethod(Self, 'UpdateParam');
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: TDateTime);
begin
  CodeSite.EnterMethod(Self, 'UpdateParam');
  CodeSite.Send(ParamName, Value);
  FStringBuilder.Replace(':' + ParamName, QuotedStr(DateTimeToStr(Value)));
  CodeSite.ExitMethod(Self, 'UpdateParam');
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: Boolean);
begin
  CodeSite.EnterMethod(Self, 'UpdateParam');
  CodeSite.Send(ParamName, Value);
  if Value then
    FStringBuilder.Replace(':' + ParamName, QuotedStr('Y'))
  else
    FStringBuilder.Replace(':' + ParamName, QuotedStr('N'));
  CodeSite.ExitMethod(Self, 'UpdateParam');
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: Currency);
begin
  CodeSite.EnterMethod(Self, 'UpdateParam');
  CodeSite.Send(ParamName, Value);
  FStringBuilder.Replace(':' + ParamName, CurrToStr(Value));
  CodeSite.ExitMethod(Self, 'UpdateParam');
end;

procedure TSqlStatement.AddSqlClause(SqlClause: string);
begin
  CodeSite.EnterMethod(Self, 'AddSqlClause');
  FStringBuilder.Append(SqlClause);
  CodeSite.ExitMethod(Self, 'AddSqlClause', FStringBuilder.ToString);
end;

procedure TSqlStatement.AddSqlStatement(SqlStatement: ISqlStatement);
begin
  CodeSite.EnterMethod(Self, 'AddSqlStatement');
  AddSqlClause(SqlStatement.ToString);
  CodeSite.ExitMethod(Self, 'AddSqlStatement');
end;

end.
