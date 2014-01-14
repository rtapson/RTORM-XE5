unit RTORM.Maps.TextFile;

interface

uses
  RTORM.Maps,
  RTORM.PersistenceMechanism.TextFiles,
  RTORM.PersistentObject,
  RTORM.PersistenceMechanism;

type
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
  SysUtils;

{ TTextFileMapper }

procedure TTextFileMapper.DeleteObject(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism);
begin

end;

procedure TTextFileMapper.InsertObject(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism);
begin
  if Supports(PersistenceMechanism, ITextFile, FTextFile) then
    FTextFile.SaveObject(aObj);
end;

procedure TTextFileMapper.RetrieveObject(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism);
begin

end;

procedure TTextFileMapper.UpdateObject(aObj: IPersistentObject;
  PersistenceMechanism: IPersistenceMechanism);
begin
  if Supports(PersistenceMechanism, ITextFile, FTextFile) then
    FTextFile.SaveObject(aObj);
end;

end.
