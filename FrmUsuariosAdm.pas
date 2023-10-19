unit FrmUsuariosAdm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FrmBase, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Edit;

type
  TFormUsuariosAdm = class(TForm_base)
    Image_voltar: TImage;
    Label_nome: TLabel;
    label_info: TLabel;
    Layout_central: TLayout;
    RoundRect_opcoes: TRoundRect;
    RoundRect2: TRoundRect;
    RoundRect3: TRoundRect;
    RoundRect4: TRoundRect;
    RoundRect5: TRoundRect;
    Label_salvar: TLabel;
    Edit_senha: TEdit;
    Edit_email: TEdit;
    Edit_nome: TEdit;
    Switch_administrador: TSwitch;
    Layout_opcoesLeft: TLayout;
    Layout1: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Switch_ativo: TSwitch;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Image_voltarClick(Sender: TObject);
    procedure Label_salvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LimpaCampos();
  end;

var
  FormUsuariosAdm: TFormUsuariosAdm;

implementation

{$R *.fmx}

uses DMConexao, FrmUsuarios;

procedure TFormUsuariosAdm.FormShow(Sender: TObject);
begin
  inherited;

  //Verifica se é novo usuário.
  if label_info.Tag = 0 then
  begin
    label_info.Text := 'Preencha as informações para a criação do usuário';
    Label_salvar.Text := 'Criar Usuário';
    Switch_ativo.IsChecked := True; // Se for novo define True como padrão (ativo)
  end
  else
  begin
    label_info.Text := 'Altere as informações do Usuário ' + DM_Conexao.RetornaNomePeloEmail(label_nome.TagString);
    Label_salvar.Text := 'Salvar Alterações';
  end;
end;

procedure TFormUsuariosAdm.Image_voltarClick(Sender: TObject);
begin
  inherited;
  FormUsuarios := TFormUsuarios.Create(self);
  Application.MainForm := FormUsuarios;

  FormUsuarios.Label_nome.TagString := Label_nome.TagString;

  FormUsuarios.Show;
  FormUsuariosAdm.Close;
end;

procedure TFormUsuariosAdm.Label_salvarClick(Sender: TObject);
var
  ativo, nivel, id : integer;
begin
  inherited;
  //valida digitação
  if (Edit_nome.Text = '') or (Edit_email.Text = '' ) or (Edit_senha.Text = '') then
  begin
    ShowMessage('Preencha todos os campos!')
  end
  else
  begin

    //Verifica se é novo registro ou edição.

    if label_info.Tag = 0 then   //Novo Registro
    begin
      //verifica se o usuário existe
      if DM_Conexao.ValidarCadastro(Edit_email.Text) = True then
      begin
        ShowMessage('Esse e-mail já foi utilizado, use outro!');
      end
      else
      begin
        //Verifica posição do switch administrador
        if Switch_administrador.IsChecked = False then
        begin
          nivel := 0;
        end
        else
        begin
         nivel := 1;
        end;


        if Switch_ativo.IsChecked = False then
        begin
          ativo := 0;
        end
        else
        begin
          ativo := 1;
        end;

        //Chama função para inserir no banco.
        DM_Conexao.InserirUsuario(Edit_email.Text, Edit_senha.Text, Edit_nome.Text, ativo,nivel);

        ShowMessage('Usuário Criado com Sucesso!');
        LimpaCampos();

        //Volta para tela Anterior
        FormUsuarios := TFormUsuarios.Create(self);
        Application.MainForm := FormUsuarios;

        FormUsuarios.Label_nome.TagString := Label_nome.TagString;

        FormUsuarios.Show;
        FormUsuariosAdm.Close;

      end;
    end
    //Se for Edição de Registro
    else
    begin
        //Verifica posição do switch administrador
        if Switch_administrador.IsChecked = False then
        begin
          nivel := 0;
        end
        else
        begin
         nivel := 1;
        end;


        if Switch_ativo.IsChecked = False then
        begin
          ativo := 0;
        end
        else
        begin
          ativo := 1;
        end;

        id := Edit_nome.TagString.ToInteger();

        //Chama função para inserir no banco.
        DM_Conexao.ModificaUsuario(Edit_email.Text, Edit_senha.Text, Edit_nome.Text, ativo,nivel,id);

        ShowMessage('Usuário Modificado com Sucesso!');
        LimpaCampos();

        //Volta para tela Anterior
        FormUsuarios := TFormUsuarios.Create(self);
        Application.MainForm := FormUsuarios;

        FormUsuarios.Label_nome.TagString := Label_nome.TagString;

        FormUsuarios.Show;
        FormUsuariosAdm.Close;

    end;

  end;

 //DM_Conexao.InserirUsuario(Edit_emailCad.Text,Edit_senhaCad.Text,Edit_nomeCad.Text)
end;

procedure TFormUsuariosAdm.LimpaCampos;
begin
 Edit_nome.Text := '';
 Edit_email.Text := '';
 Edit_senha.Text := '';
 Switch_administrador.IsChecked := False;
Switch_ativo.IsChecked := True;
end;

end.
