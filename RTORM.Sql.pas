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

procedure TSqlStatement.AddParameter(ParamValue: TObject; aParamType: TFieldType);
begin

end;

function TSqlStatement.Copy: ISqlStatement;
begin
end;

procedure TSqlStatement.AddParameter;
begin

end;

constructor TSqlStatement.Create;
begin
  FStringBuilder := TStringBuilder.Create;
end;

destructor TSqlStatement.Destroy;
begin
  FStringBuilder.Free;
  inherited;
end;

function TSqlStatement.ToString: string;
begin
  result := FStringBuilder.ToString;
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: integer);
begin
  FStringBuilder.Replace(':' + ParamName, IntToStr(Value));
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: string);
begin
  FStringBuilder.Replace(':' + ParamName, QuotedStr(Value));
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: TDateTime);
begin
  FStringBuilder.Replace(':' + ParamName, QuotedStr(DateTimeToStr(Value)));
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: Boolean);
begin
  if Value then
    FStringBuilder.Replace(':' + ParamName, QuotedStr('Y'))
  else
    FStringBuilder.Replace(':' + ParamName, QuotedStr('N'));
end;

procedure TSqlStatement.UpdateParam(const ParamName: string; Value: Currency);
begin
  FStringBuilder.Replace(':' + ParamName, CurrToStr(Value));
end;

procedure TSqlStatement.AddSqlClause(SqlClause: string);
begin
  FStringBuilder.Append(SqlClause);
end;

procedure TSqlStatement.AddSqlStatement(SqlStatement: ISqlStatement);
begin
  AddSqlClause(SqlStatement.ToString);
end;

end.
