unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btnDeleteRole: TButton;
    btnUpdate: TButton;
    btnGetRole: TButton;
    edtRoleName: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    cmbRoleType: TComboBox;
    ComboBox1: TComboBox;
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button3: TButton;
    Button4: TButton;
    procedure btnDeleteRoleClick(Sender: TObject);
    procedure btnGetRoleClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  RoleOM, RTORM.Broker, RTORM.PersistenceCritieria,
  RTORM.PersistentObject, Spring.Collections, Spring.Services,
  Spring.Container, ApplicationUserOM;

{$R *.dfm}

procedure TForm1.btnDeleteRoleClick(Sender: TObject);
var
  aObj : IRole;
  StrBld : TStringBuilder;
begin
  aObj := TRole.Create;
  aObj.Name := edtRoleName.Text;
  aObj.RoleType := TRoleType(cmbRoleType.ItemIndex + 1);
  aObj.Delete;

  {StrBld := TStringBuilder.Create;
  try
    StrBld.AppendLine(aObj.Name)
          .Append(aObj.Active).AppendLine
          .AppendLine(aObj.ModifiedByLoginId)
          .Append(aObj.DateModified).AppendLine
          .Append(aObj.DateCreated);
    ShowMessage(StrBld.ToString);
  finally
    StrBld.Free;
  end;}
end;

procedure TForm1.btnGetRoleClick(Sender: TObject);
var
  aObj : IRole;
  aPerm : IPermission;
  StrBld : TStringBuilder;
begin
  Memo1.Clear;

//  aObj := ServiceLocator.GetService<IRole>;
  aObj := TRole.Create(StrToInt(edtRoleName.Text));
  //aObj.RoleType := TRoleType(cmbRoleType.ItemIndex + 1);
  aObj.Retrieve;

  StrBld := TStringBuilder.Create;
  try
    StrBld.AppendLine(aObj.Name)
          .Append(aObj.Active).AppendLine
          .AppendLine(aObj.ModifiedByLoginId)
          .Append(aObj.DateModified).AppendLine
          .Append(aObj.DateCreated).AppendLine
          .AppendFormat('Role Type: %d', [Integer(aObj.RoleType)]);
    Memo1.Lines.Add(StrBld.ToString);
  finally
    StrBld.Free;
  end;

  aObj.Permissions.Values.ForEach(
    procedure(const Obj : IPermission)
    begin
      ListBox1.Items.Add(Obj.ResourceName);
    end
  );
end;

procedure TForm1.btnUpdateClick(Sender: TObject);
var
  aObj : IRole;
begin
  aObj := TRole.Create;
  aObj.Name := edtRoleName.Text;
  aObj.RoleType := TRoleType(cmbRoleType.ItemIndex + 1);

  PersistenceBroker.DataStore := ComboBox1.Text;

  aObj.Save;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  SelCrit : IPersistenceCritieria;
  RoleList : IList<IPersistentObject>;
  aObject : IPersistentObject;
  aRole: IRole;
begin
  ListBox1.Clear;
  SelCrit := TPersistentCritieria.Create(TRole.ClassName);
  SelCrit.AddSelectEqualTo('RoleType', cmbRoleType.ItemIndex + 1);

  RoleList := SelCrit.Perform;

  for aObject in RoleList do
  begin
    if Supports(aObject, IRole, aRole) then
      ListBox1.Items.AddObject(aRole.Name, TObject(aRole.ID));
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Perm : IPermission;
  SelCrit : IPersistenceCritieria;
  PermList : IList<IPersistentObject>;
  aObject : IPersistentObject;
begin
  ListBox1.Clear;
  SelCrit := TPersistentCritieria.Create(TPermission.ClassName);
  SelCrit.AddSelectEqualTo('ApplicationRoleID', '3');

  PermList := SelCrit.Perform;

  for aObject in PermList do
  begin
    if Supports(aObject, IPermission, Perm) then
      ListBox1.Items.Add(Perm.ResourceName);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  SelCrit : IPersistenceCritieria;
  RoleList : IList<IPersistentObject>;
  aObject : IPersistentObject;
  aRole: IRole;
begin
  ListBox1.Clear;
  SelCrit := TPersistentCritieria.Create(TRole.ClassName);
  //SelCrit.AddSelectEqualTo('Name', 'Tapper');
  SelCrit.AddSelectEqualTo('Name', Edit2.Text);

  RoleList := SelCrit.Perform;

  for aObject in RoleList do
  begin
    if Supports(aObject, IRole, aRole) then
      ListBox1.Items.AddObject(aRole.Name, TObject(aRole.ID));
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  User : IApplicationUser;
begin
  User :=TApplicationUser.Create('RTAPSON', '020');
  User.Retrieve;

  ShowMessage(user.EmailAddress);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  PersistenceBroker.DataStore := ComboBox1.Text;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Permech : string;
begin
  for Permech in PersistenceBroker.DataStores.Keys  do
  begin
      ComboBox1.Items.Add(Permech);
  end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  aObj : IRole;
  StrBld : TStringBuilder;
begin
  Memo1.Clear;

  aObj := TRole.Create(Integer(ListBox1.Items.Objects[ListBox1.ItemIndex]));
  aObj.Retrieve;

  StrBld := TStringBuilder.Create;
  try
    StrBld.AppendLine(aObj.Name)
          .Append(aObj.Active).AppendLine
          .AppendLine(aObj.ModifiedByLoginId)
          .Append(aObj.DateModified).AppendLine
          .Append(aObj.DateCreated).AppendLine
          .AppendFormat('Role Type: %d', [Integer(aObj.RoleType)]);
    Memo1.Lines.Add(StrBld.ToString);
  finally
    StrBld.Free;
  end;
end;

end.
