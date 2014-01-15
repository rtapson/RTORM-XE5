unit RTORM.PersistenceMechanism.TextFiles;

interface

uses
  RTORM.PersistenceMechanism, RTORM.PersistentObject;

type
  ITextFile = interface(IPersistencemechanism)
    ['{8F319649-8E0A-47A8-917B-2453FEE487A9}']
    procedure SaveObject(aObj : IPersistentObject);
  end;

  TTextFile = class(TPersistenceMechanism, ITextFile)
  public
    procedure SaveObject(aObj : IPersistentObject);
  end;


implementation

uses
  CodeSiteLogging, IOUtils, RTTI,  System.TypInfo, SysUtils;

{ TTextFile }

procedure TTextFile.SaveObject(aObj: IPersistentObject);
var
  sTemp : TStringBuilder;
  context: TRttiContext;
  rtti: TRTTIType;
  prop: TRttiProperty;
  EnumType: integer;
  aDate: TDateTime;
begin
  CodeSite.EnterMethod(Self, 'SaveObject');
  sTemp := TStringBuilder.Create;
  try
    context := TRttiContext.Create;
    try
      rtti := context.GetType(TObject(aObj).ClassInfo);
      for prop in rtti.GetProperties do
      begin
        //CodeSite.Send(prop.ToString);

        sTemp.AppendFormat('%s = ', [prop.Name]);

        case prop.PropertyType.TypeKind of
          tkUnknown:  ;
          tkInteger: sTemp.Append(prop.GetValue(TObject(aObj)).AsInteger).Appendline;
          tkChar: sTemp.Append(prop.GetValue(TObject(aObj)).AsString).Appendline;
          tkEnumeration:
            begin
              if prop.PropertyType.Name = 'Boolean' then
              begin
                if prop.GetValue(TObject(aObj)).AsOrdinal = 0 then
                   sTemp.Append('N').Appendline
                else
                   sTemp.Append('Y').Appendline;
              end
              else
              begin
                EnumType := prop.GetValue(TObject(aObj)).AsOrdinal;
                sTemp.Append(EnumType).Appendline;
              end;
            end;
          tkFloat:
            begin
              sTemp.Append(prop.GetValue(TObject(aObj)).AsCurrency).Appendline;
              {if meth.PropertyType.Handle = TypeInfo(TDateTime) then
              begin
                aDate := meth.GetValue(TObject(aObj)).AsType<TDateTime>;
                result.UpdateParam(meth.Name, aDate);
              end
              else
                result.UpdateParam(meth.Name, meth.GetValue(TObject(aObj))
                  .AsCurrency);}
            end;
          tkString: sTemp.Append(prop.GetValue(TObject(aObj)).AsString).Appendline;
          tkSet: ;
          tkClass: ;
          tkMethod: ;
          tkWChar: sTemp.Append(prop.GetValue(TObject(aObj)).AsString).Appendline;
          tkLString: sTemp.Append(prop.GetValue(TObject(aObj)).AsString).Appendline;
          tkWString:  sTemp.Append(prop.GetValue(TObject(aObj)).AsString).Appendline;
          tkVariant:  ;
          tkArray: ;
          tkRecord: ;
          tkInterface: ;
          tkInt64: ;
          tkDynArray: ;
          tkUString: sTemp.Append(prop.GetValue(TObject(aObj)).AsString).Appendline;
          tkClassRef: ;
          tkPointer: ;
          tkProcedure: ;
        end;
      end;
    finally
      context.Free;
    end;
    TFile.WriteAllText('c:\temp\rtormtest.txt', sTemp.ToString);
  finally
    sTemp.Free;
  end;
  CodeSite.ExitMethod(Self, 'SaveObject');
end;

//initialization
//  PersistenceBroker.AddPersistenceMechansim('TextFile', TTextFile.Create);

end.
