unit FrmUsuarios;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFormUsuarios = class(TForm_base)
    Image1: TImage;
    Label_nome: TLabel;
    Label1: TLabel;
    Layout_central: TLayout;
    ListView_usuarios: TListView;
    Image_editar: TImage;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure ListView_usuariosItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AdicionaListViewUsuarios();
  end;

var
  FormUsuarios: TFormUsuarios;

implementation

{$R *.fmx}

uses DMConexao, FrmAdministracao, FrmUsuariosAdm;

procedure TFormUsuarios.AdicionaListViewUsuarios;
begin
//
  ListView_usuarios.Items.clear; // limpa informa��es

  // Inicia Conex�o no Banco
  if DM_Conexao.FD_Conexao.Connected = False then
  begin
    DM_Conexao.FD_Conexao.Connected := True;
  end;

  //consulta
  DM_Conexao.FD_Query.Close;
  DM_Conexao.FD_Query.SQL.Clear;
  DM_Conexao.FD_Query.SQL.Add('select id, email from usuario');
  DM_Conexao.FD_Query.Open();

  //Inserindo no List View
  while not DM_Conexao.FD_Query.Eof do
  begin
    with ListView_usuarios.Items.Add do
    begin
      TagString := DM_Conexao.FD_Query.FieldByName('id').AsString;


      // Adiciona o nome da Categoria

      TListItemText(Objects.FindDrawable('id')).Text := DM_Conexao.FD_Query.FieldByName('id').AsString;

      TListItemText(Objects.FindDrawable('usuario')).Text := DM_Conexao.FD_Query.FieldByName('email').AsString;

      // Adiciona Imagens
      TListItemImage(Objects.FindDrawable('editar')).Bitmap := Image_editar.Bitmap;
    end;
    DM_Conexao.FD_Query.Next;

  end;

  if ListView_usuarios.Items.Count = 0 then
  // Se n�o tiver nenhum item no ListView
  begin
    with ListView_usuarios.Items.Add do
    begin
      TListItemText(Objects.FindDrawable('Linha')).Text :=
        'Sem Usu�rios...';
    end;
  end;


end;

procedure TFormUsuarios.FormCreate(Sender: TObject);
begin
  inherited;
  AdicionaListViewUsuarios();
  Image_editar.Visible := False;
end;

procedure TFormUsuarios.Image1Click(Sender: TObject);
begin
  inherited;
  FormAdministracao := TFormAdministracao.Create(self);
  application.MainForm := FormAdministracao;

  FormAdministracao.Label_nome.TagString := Label_nome.TagString;

  FormAdministracao.Show;
  FormUsuarios.Close;
end;

procedure TFormUsuarios.Image2Click(Sender: TObject);
begin
  inherited;
  FormUsuariosAdm := TFormUsuariosAdm.Create(self);
  application.MainForm := FormUsuariosAdm;

  FormUsuariosAdm.Label_nome.TagString := Label_nome.TagString;
  FormUsuariosAdm.Label_nome.Tag := 0; //Passa Tag 0 para  considerar Cria��o de Usu�rio

  FormUsuariosAdm.Show;
  FormUsuarios.Close;

end;

procedure TFormUsuarios.ListView_usuariosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  inherited;

  if ItemObject <> nil then // Usu�rio clicou em algum objeto
  begin
    if ItemObject.Name = 'editar' then
    begin

      // Busca informa��es do usu�rio no Banco.

      // Inicia Conex�o no Banco
      if DM_Conexao.FD_Conexao.Connected = False then
      begin
       DM_Conexao.FD_Conexao.Connected := True;
      end;

      DM_Conexao.FD_Query.Close;
      DM_Conexao.FD_Query.SQL.Clear;
      DM_Conexao.FD_Query.SQL.Add('select id,email, nome, senha,ativo,nivel From usuario ' +
                                   'Where id = :id');

      DM_Conexao.FD_Query.ParamByName('id').AsInteger := ListView_usuarios.Items[ItemIndex].TagString.ToInteger();
      DM_Conexao.FD_Query.Open();

      //Preenche informa��es no Form

      FormUsuariosAdm := TFormUsuariosAdm.Create(self);
      Application.MainForm := FormUsuariosAdm;

      //Informa que ser� uma edi��o de registro
      FormUsuariosAdm.label_info.Tag := 1; //Edi��o de Registro

      //Administrador
      if DM_Conexao.FD_Query.FieldByName('nivel').AsInteger = 1 then
      begin
        FormUsuariosAdm.Switch_administrador.IsChecked := True;
      end
      else
      begin
         FormUsuariosAdm.Switch_administrador.IsChecked := False;
      end;

      //Ativo
      if DM_Conexao.FD_Query.FieldByName('ativo').AsInteger = 1 then
      begin
        FormUsuariosAdm.Switch_ativo.IsChecked := True;
      end
      else
      begin
         FormUsuariosAdm.Switch_ativo.IsChecked := False;
      end;

      //Nome
      FormUsuariosAdm.Edit_nome.Text := DM_Conexao.FD_Query.FieldByName('nome').AsString;
      FormUsuariosAdm.Edit_nome.TagString := ListView_usuarios.Items[ItemIndex].TagString; //passa iD do registro na TagString da Edit
      //Passa e-mail usu�rio.
      FormUsuariosAdm.Label_nome.TagString := Label_nome.TagString;


      //Email
      FormUsuariosAdm.Edit_email.Text := DM_Conexao.FD_Query.FieldByName('email').AsString;
      //senha
      FormUsuariosAdm.Edit_senha.Text := DM_Conexao.Criptografa('D', DM_Conexao.FD_Query.FieldByName('senha').AsString);

      FormUsuariosAdm.Show;
      FormUsuarios.Close;


      //showmessage('id , ' + ListView_usuarios.Items[ItemIndex].TagString );
    end;
  end;
end;

end.
